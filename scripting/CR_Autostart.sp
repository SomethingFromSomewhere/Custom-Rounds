#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <cstrike>

public Plugin myinfo =
{
	name        = 	"[CR] Autostart",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

Handle g_hTimer;

ArrayList g_hArray;
int g_iMode, g_iRounds, g_iEvery, g_iRandom;
bool g_bTimer, g_bReload, g_bWait;
float g_fTime;

public void OnPluginStart()
{
	g_hArray = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));
}

public void CR_OnConfigLoad()
{
	g_hArray.Clear();
	LoadConfig();
}

public void CR_OnConfigSectionLoadPost(const char[] sName)
{
	g_hArray.PushString(sName);
}

public void CR_OnStartRound(KeyValues Kv)
{
	g_iRounds++;
	if(Kv)
	{
		Check();
	}
}

void Check()
{
	switch(g_iMode)
	{
		case 1:	if(g_iRounds >= g_iEvery)
		{
			g_iRounds = 0;
			ChooseRandom();
		}
		case 2:
		{
			if(g_bWait)
			{
				ChooseRandom();
				g_bWait = false;
			}
			if(g_bTimer)
			{
				if(g_hTimer != null)
				{
					KillTimer(g_hTimer);
					g_bReload = true;
				}
				g_hTimer = CreateTimer(g_fTime, Timer_Rounds, _, TIMER_REPEAT);
				g_bTimer = false;
			}
		}
		case 3:
		{
			if(GetRandomInt(0, g_iRandom) == 0)	ChooseRandom();
		}
	}
}

public void OnMapStart()
{
	g_iRounds = 0;
}

public void OnMapEnd()
{
	if(g_hTimer != null)
	{
		KillTimer(g_hTimer);
		g_hTimer = null;
	}
	g_bReload = false;
}

void ChooseRandom()
{
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	g_hArray.GetString(GetRandomInt(0, g_hArray.Length-1), sBuffer, sizeof(sBuffer));
	if(sBuffer[0])	CR_SetNextRound(sBuffer);
}

public Action Timer_Rounds(Handle hTimer)
{
	g_bWait = false;
	if(g_iMode != 2)
	{
		g_hTimer = null;
		return Plugin_Stop;
	}
	if(CR_IsNextRoundCustom())	g_bWait = true;
	else	ChooseRandom();
	return Plugin_Continue;
}

void LoadConfig()
{
	g_hArray.Clear();
	KeyValues Kv = new KeyValues("Autostart");
	
	char sBuffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/custom_rounds/autostart.ini");
	if (!FileToKeyValues(Kv, sBuffer)) SetFailState("Файл конфигурации не найден %s", sBuffer);

	g_iMode = Kv.GetNum("mode", 1);
	switch(g_iMode)
	{
		case 1:
		{
			g_iEvery = Kv.GetNum("rounds", 3);	
			g_iRounds = 0;
		}
		case 2:
		{
			if(g_bReload && g_bTimer && !g_hTimer)
			{
				KillTimer(g_hTimer);
				g_hTimer = CreateTimer(g_fTime, Timer_Rounds, _, TIMER_REPEAT);
			}
			g_bTimer = true;
			g_bReload = false;
			g_fTime = Kv.GetFloat("seconds", 600.0);
		}
		case 3:
		{
			g_iRandom = Kv.GetNum("chance", 25);
		}
	}
	
	if (Kv.GotoFirstSubKey())
	{
		int i;
		do
		{
			if (Kv.GetSectionName(sBuffer, sizeof(sBuffer)) && (i = g_hArray.FindString(sBuffer)) >= 0)
			{
				g_hArray.Erase(i);
			}
		} 
		while (Kv.GotoNextKey());
	}
	delete Kv;
}