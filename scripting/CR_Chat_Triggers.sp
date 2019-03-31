#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdktools_gamerules>

public Plugin myinfo =
{
	name        = 	"[CR] Chat Triggers",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

StringMap g_hTrieForce, g_hTrieNext;

KeyValues Kv;

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
	Kv = CR_GetKeyValue();
}

public void CR_OnConfigSectionLoadPost(const char[] sName)
{
	char sBuffer[256];
	Kv.GetString("chat_force", sBuffer, sizeof(sBuffer));
	if(sBuffer[0])	g_hTrieForce.SetString(sBuffer, sName); sBuffer[0] = '\0';
	Kv.GetString("chat_next", sBuffer, sizeof(sBuffer));
	if(sBuffer[0] && !g_hTrieForce.GetString(sName, "", 0))	g_hTrieNext.SetString(sBuffer, sName);	sBuffer[0] = '\0';
}

public void OnClientSayCommand_Post(int iClient, const char[] sCommand, const char[] Args)
{
	if(CheckCommandAccess(iClient, "sm_cr", ADMFLAG_GENERIC))
	{
		char sBuffer[256];
		if(g_hTrieForce.GetString(Args, sBuffer, sizeof(sBuffer)))
		{
			if(!CR_IsRoundEnd())
			{
				if(GameRules_GetProp("m_bWarmupPeriod") != 1)
				{
					if(!CR_StartRound(sBuffer, iClient))	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Interval");
				}
				else	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Warmup");
			}
			else	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Round_End");
			return;
		}
		
		if(g_hTrieNext.GetString(Args, sBuffer, sizeof(sBuffer)))
		{
			if(!CR_SetNextRound(sBuffer, iClient))	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Interval");
		}
	}
}