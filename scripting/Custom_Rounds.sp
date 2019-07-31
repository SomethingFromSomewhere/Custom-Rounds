#include <cstrike>
#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"Custom Rounds",
	author      = 	"Someone",
	description =	"Provides feauture for building custom rounds",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

#include "custom_rounds/defines.sp"
#include "custom_rounds/functions.sp"
#include "custom_rounds/natives.sp"
#include "custom_rounds/forwards.sp"
#include "custom_rounds/hooks.sp"

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateForwards();
	CreateNatives();

	RegPluginLibrary("custom_rounds");

	return APLRes_Success;
}

public void OnPluginStart()
{
	ConVar CVAR;

	CVAR = FindConVar("mp_round_restart_delay");
	if(!CVAR)	(CVAR = CreateConVar("sm_cr_restart_delay", "5.0", "Time until round restart. 0 - instantly.", _, true, 0.0));
	CVAR.AddChangeHook(ChangeCvar_RoundRestartDelay);
	g_fRestartDelay = CVAR.FloatValue;

	(CVAR = CreateConVar("sm_cr_respawn_type", "1", "Time before spawn hook calls after player respawn. Any values sets timer after respawn. 0 - instantly.", _, true, 0.0)).AddChangeHook(ChangeCvar_Respawn);
	g_fRespawn = CVAR.FloatValue;

	AutoExecConfig(true, "custom_rounds");

	RegAdminCmd("sm_cr_reload", CMD_RELOAD, ADMFLAG_ROOT);

	g_hArray = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));

	HookEvents();
	
	LoadTranslations("custom_rounds.phrases");
}

public void OnAllPluginsLoaded()
{
	Function_LoadConfig();
	Forward_PluginStarted();
}

public void ChangeCvar_RoundRestartDelay(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_fRestartDelay = convar.FloatValue;
}

public void ChangeCvar_Respawn(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_fRespawn = convar.FloatValue;
}

public Action CMD_RELOAD(int iClient, int iArgs)
{
	Function_LoadConfig();
	ReplyToCommand(iClient, "%tConfig successfully reloaded.", "Prefix");
	return Plugin_Handled;
}