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

#define Plugin_PrintToChatAll PrintToChatAll

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
		Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Round_Start", sName);
	}
}

public void CR_OnCancelCurrentRoundPost(int iClient, const char[] sName)
{
	if(iClient && iClient < 65)	Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Force_Round_End", iClient);
}

public void CR_OnCancelNextRoundPost(int iClient, const char[] sName)
{
	Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Next_Round_Cancel", iClient);
}

public void CR_OnSetNextRoundPost(int iClient, const char[] sName)
{
	if(CR_IsNextRoundCustom())	Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Change_Next_Round", iClient, sName);
	else Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Set_Next_Round", iClient, sName);
}

public void CR_OnForceRoundStartPost(int iClient, const char[] sName)
{
	Plugin_PrintToChatAll("%t %t", "Prefix", "CR_CHAT_Set_Current_Round", iClient, sName);
}