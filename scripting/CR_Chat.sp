#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Chat",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		char sName[MAX_ROUND_NAME_LENGTH];
		Kv.GetSectionName(sName, sizeof(sName));
		PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Round_Start", sName);
	}
}

public bool CR_OnCancelCurrentRound(int iClient)
{
	if(iClient && iClient < 65)	PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Force_Round_End", iClient);
}

public bool CR_OnCancelNextRound(int iClient)
{
	PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Next_Round_Cancel", iClient);
}

public Action CR_OnSetNextRound(char[] sName, int iClient)
{
	if(CR_IsNextRoundCustom())	PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Change_Next_Round", iClient, sName);
	else PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Set_Next_Round", iClient, sName);
}

public bool CR_OnStartCurrentRound(const char[] sName, int iClient)
{
	PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Set_Current_Round", iClient, sName);
}