#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

#define Plugin_PrintToChatAll PrintToChatAll

public Plugin myinfo =
{
	name        = 	"[CR] Messages",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		char sBuffer[128];
		Kv.GetString("message", sBuffer, sizeof(sBuffer));
		if(sBuffer[0])
		{
			if(TranslationPhraseExists(sBuffer))	Plugin_PrintToChatAll("%t", sBuffer);
			else									Plugin_PrintToChatAll(sBuffer);
		}
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(Kv)
	{
		char sBuffer[128];
		Kv.GetString("end_message", sBuffer, sizeof(sBuffer));
		if(sBuffer[0])
		{
			if(TranslationPhraseExists(sBuffer))	Plugin_PrintToChatAll("%t", sBuffer);
			else									Plugin_PrintToChatAll(sBuffer);
		}
	}
}
