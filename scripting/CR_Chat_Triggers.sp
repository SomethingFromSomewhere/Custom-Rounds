#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdktools_gamerules>

public Plugin myinfo =
{
	name        = 	"[CR] Chat Triggers",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

#define Plugin_PrintToChat PrintToChat

StringMap g_hTrieForce, g_hTrieNext;

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
	g_hTrieForce = new StringMap();
	g_hTrieNext = new StringMap();
}

public void CR_OnConfigLoad()
{
	g_hTrieForce.Clear();
	g_hTrieNext.Clear();
}

public void CR_OnConfigSectionLoadPost(const char[] sName, KeyValues Kv)
{
	char sBuffer[256];
	Kv.GetString("chat_force", sBuffer, sizeof(sBuffer));
	if(sBuffer[0])	g_hTrieForce.SetString(sBuffer, sName);
	Kv.GetString("chat_next", sBuffer, sizeof(sBuffer));
	if(sBuffer[0] && !g_hTrieForce.GetString(sName, "", 0))	g_hTrieNext.SetString(sBuffer, sName);
}

public void OnClientSayCommand_Post(int iClient, const char[] sCommand, const char[] sArgs)
{
	if(CheckCommandAccess(iClient, "sm_acr", ADMFLAG_GENERIC))
	{
		char sBuffer[256];
		if(g_hTrieForce.GetString(sArgs, sBuffer, sizeof(sBuffer)))
		{
			if(!CR_IsRoundEnd())
			{
				if(GameRules_GetProp("m_bWarmupPeriod") != 1)
				{
					if(!CR_StartRound(sBuffer, iClient))	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_MENU_Interval");
				}
				else	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_MENU_Warmup");
			}
			else	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_MENU_Round_End");
			return;
		}
		
		if(g_hTrieNext.GetString(sArgs, sBuffer, sizeof(sBuffer)))
		{
			if(!CR_SetNextRound(sBuffer, iClient))	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_MENU_Interval");
		}
	}
}