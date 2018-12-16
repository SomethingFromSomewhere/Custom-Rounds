#pragma semicolon 1
#pragma newdecls required

#include <cstrike>
#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"Custom Rounds",
	author      = 	"Someone",
	version     = 	"1.3",
	url         = 	"http://hlmod.ru"
};

KeyValues Kv;
bool	g_bIsCR, g_bNextCR, g_bStartCR, g_bRoundEnd, g_bInverval;
int g_iInterval, g_iRounds;
float g_fRestartDelay;
char g_sNextRound[256], g_sCurrentRound[256];
	
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
	g_fRestartDelay = CVAR.FloatValue;
	
	(CVAR = CreateConVar("sm_cr_round_interval", "0", "Интервал между нестандартными раундами. 0 - отключено", _, true, 0.0)).AddChangeHook(ChangeCvar_Interval);
	g_iInterval = CVAR.IntValue;

	AutoExecConfig(true, "custom_rounds");
	
	RegAdminCmd("sm_cr", CMD_CR, ADMFLAG_GENERIC);
	RegAdminCmd("sm_cr_reload", CMD_RELOAD, ADMFLAG_ROOT);
	
	HookEvents();
}

public void OnAllPluginsLoaded()
{
	LoadConfig();
}

public void ChangeCvar_Interval(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iInterval = convar.IntValue;
	g_iRounds = 0;
}

public Action CMD_CR(int iClient, int iArgs)
{
	if(iClient)	Forward_OnChatCommand(iClient);
	return Plugin_Handled;
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
				Forward_OnConfigSectionLoad(sBuffer);
			}
		}
		while (Kv.GotoNextKey());
	}
}

public int Native_ReloadConfig(Handle hPlugin, int numParams)
{
	LoadConfig();
}

public void OnMapStart()
{
	g_bRoundEnd = false,
	g_bStartCR = false,
	g_bNextCR = false;
	g_bIsCR = false;
	g_bInverval = false;
	g_iInterval = 0;
	g_sCurrentRound[0] = '\0';
	g_sNextRound[0] = '\0';
}
