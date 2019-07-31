#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Autostart",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

any g_aInfo, g_aAdditionalInfo;
ArrayList g_hArray;
int g_iMode;

public void OnPluginStart()
{
	g_hArray = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));
}

public void CR_OnConfigLoad()
{
	g_hArray.Clear();
}

public void CR_OnConfigLoaded()
{
	LoadConfig();
}

public void CR_OnConfigSectionLoadPost(const char[] sName, KeyValues Kv)
{
	g_hArray.PushString(sName);
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(g_iMode == 1)
	{
		g_aAdditionalInfo++;
		Check();
	}
}

void Check()
{
	switch(g_iMode)
	{
		case 1:	if(g_aAdditionalInfo >= g_aInfo)
		{
			g_aAdditionalInfo = 0;
			ChooseRandom();
		}
		case 2:	if(g_aInfo)
		{
			ChooseRandom();
			g_aInfo = false;
		}
		case 3:	if(GetRandomInt(0, 100) >= g_aAdditionalInfo)
		{
			ChooseRandom();
		}
	}
}

public void OnMapStart()
{
	if(g_iMode == 1) 		g_aAdditionalInfo = 0;
}

void ChooseRandom()
{
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	
	if(g_hArray.Length > 0)	g_hArray.GetString(GetRandomInt(0, g_hArray.Length-1), sBuffer, sizeof(sBuffer));
	
	if(sBuffer[0])	CR_SetNextRound(sBuffer);
}

public Action Timer_Rounds(Handle hTimer)
{
	g_aInfo = false;
	
	if(CR_IsNextRoundCustom())	g_aInfo = true;
	else						ChooseRandom();
}

void LoadConfig()
{
	KeyValues Kv = new KeyValues("Autostart");
	
	char sBuffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/custom_rounds/autostart.ini");
	if (!FileToKeyValues(Kv, sBuffer)) SetFailState("Missing config file %s", sBuffer);
	
	g_iMode = Kv.GetNum("mode", 1);
	
	switch(g_iMode)
	{
		case 1:
		{
			g_aInfo = Kv.GetNum("value", 3);	
			g_aAdditionalInfo = 0;
		}
		case 2:	g_aAdditionalInfo = CreateTimer(Kv.GetFloat("value", 600.0), Timer_Rounds, _, TIMER_REPEAT);
		case 3:	g_aInfo = Kv.GetNum("value", 25);
	}
	
	if (Kv.GotoFirstSubKey())
	{
		int i;
		do
		{
			if (Kv.GetSectionName(sBuffer, sizeof(sBuffer)) && (i = g_hArray.FindString(sBuffer)) != -1)
			{
				g_hArray.Erase(i);
			}
		} 
		while (Kv.GotoNextKey());
	}
	delete Kv;
	
}