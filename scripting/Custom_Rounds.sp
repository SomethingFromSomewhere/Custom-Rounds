#include <cstrike>
#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"Custom Rounds",
	author      = 	"Someone",
	description =	"Provides feauture for building custom rounds",
	version     = 	"2.0",
	url 		= 	"https://hlmod.ru | https://discord.gg/UfD3dSa"
};

#include "custom_rounds/defines.sp"
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

	(CVAR = CreateConVar("sm_cr_respawn_type", "1", "Give equipments and etc. Any values sets timer after respawn. 0 - instantly.", _, true, 0.0)).AddChangeHook(ChangeCvar_Respawn);
	g_fRespawn = CVAR.FloatValue;

	AutoExecConfig(true, "custom_rounds");

	RegAdminCmd("sm_cr_reload", CMD_RELOAD, ADMFLAG_ROOT);
	
	g_hArray = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));
	
	HookEvents();
}

public void OnAllPluginsLoaded()
{
	LoadConfig();
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
	LoadConfig();
	return Plugin_Handled;
}

static void LoadConfig()
{
	delete Kv;
	Kv = new KeyValues("CustomRounds");

	g_hArray.Clear();
	Forward_OnConfigLoad();
	
	char sBuffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/custom_rounds/rounds.ini");
	if (!FileToKeyValues(Kv, sBuffer)) SetFailState("Файл конфигурации не найден %s", sBuffer);

	if (Kv.GotoFirstSubKey())
	{ 
		do
		{
			if(Kv.GetSectionName(sBuffer, sizeof(sBuffer)))
			{
				g_hArray.PushString(sBuffer);
				Forward_OnConfigSectionLoad(sBuffer);
			}
		}
		while (Kv.GotoNextKey());
	}
}

public int Native_ReloadConfig(Handle hPlugin, int numParams)	{	LoadConfig();	}

public void OnMapStart()
{
	g_bIsCR				=
	g_bRoundEnd 		= 	false;
	
	g_sCurrentRound[0] 	=
	g_sNextRound[0] 	= 	'\0';
}
