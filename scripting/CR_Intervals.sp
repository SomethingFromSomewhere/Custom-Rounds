#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Intervals",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

#define Plugin_PrintToChat PrintToChat

int g_iInterval, g_iRounds;

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_round_interval", "5", "Interval beetwen rounds. 0 - disabled", _, true, 0.0)).AddChangeHook(ChangeCvar_Interval);
	g_iInterval = CVAR.IntValue;
}

public void ChangeCvar_Interval(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iInterval = convar.IntValue;
	g_iRounds = 0;
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)											g_iRounds = g_iInterval;
	else if(g_iRounds > 0)							--g_iRounds;
}

public Action CR_OnSetNextRound(int iClient, char[] sName)
{
	if(g_iRounds-1 > 0)
	{
		if(iClient)
		{
			Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Intervals_Warning");
		}
		else PrintToServer("%t%t", "Prefix", "Intervals_Warning");

		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public Action CR_OnForceRoundStart(int iClient, char[] sName)
{
	if(g_iRounds != 0)
	{
		if(iClient)
		{
			Plugin_PrintToChat(iClient, "%t%t", "Prefix", "Intervals_Warning");
		}
		else PrintToServer("%t%t", "Prefix", "Intervals_Warning");

		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

public void OnMapStart()
{
	g_iRounds = 0;
}