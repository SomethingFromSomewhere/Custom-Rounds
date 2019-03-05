#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Votes",
	author      = 	"Someone",
	version     = 	"1.0",
	url         = 	"http://hlmod.ru"
};

ArrayList g_hArray;
Menu g_hMenu = null;
int g_iPlayerChoose[MAXPLAYERS+1] = -1;

public void OnPluginStart()
{
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_minimum", 		"4", 		"Минимум игроков для голосования", 						_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Minimum);
	g_iMinimum			= 		CVAR.IntValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_ratio", 			"0.60", 	"Соотношение игроков для успешного голосования.", 		_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Ratio);
	g_fRatio		 	= 		CVAR.FloatValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_type", 			"1", 		"0 - запуск сразу | 1 - запуск в следующем раунде.", 	_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Type);
	g_bType		 		= 		CVAR.BoolValue;

	RegConsoleCmd(				"sm_voteround", 		CMD_VR			);
	RegConsoleCmd(				"sm_vr", 				CMD_VR			);
	
	g_hArray = new ArrayList();
	
	g_hMenu = new Menu(CR_Votes_Menu_Handler, MenuAction_Select|MenuAction_Display|MenuAction_DisplayItem);
	g_hMenu.SetTitle("Votes for Custom Rounds");
	g_hMenu.ExitButton = true;
}

public void ChangeCvar_Minimum(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iMinimum			=		convar.IntValue;
}

public void ChangeCvar_Ratio	(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_fRatio			= 		convar.FloatValue;
}

public void ChangeCvar_Type	(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bType		 		= 		convar.BoolValue;
}

public void CR_OnConfigLoad()
{
	g_hArray.Clear();
	g_hArray.Push(0);
	g_hMenu.RemoveAllItems();
	g_hMenu.AddItem(sName, "Cancel");
}

public void CR_OnConfigSectionLoad(const char[] sName)
{
	g_hMenu.AddItem(sName, sName);
	g_hArray.Push(0);
}

public Action CMD_VR(int iClient, int iArgs)
{
	if(iClient > 0 && IsClientInGame(iClient))	g_hMenu.Display(iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}
	
void ResetVote(int iClient)
{
	if(g_iPlayerChoose[iClient] != -1)
	{
		g_hArray.Set(g_iPlayerChoose[iClient], g_hArray.Get(g_iPlayerChoose[iClient])-1);
		g_iPlayerChoose[iClient] = -1;
	}
}

public int CR_Menu_Handler(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)	
	{
		case MenuAction_Select:
		{
			ResetVote(iClient);
			
			if(iItem != 0)
			{
				int iValue = g_hArray.Get(iItem)+1;
				g_hArray.Set(iItem, iValue);
				g_iPlayerChoose[iClient] = iItem;
				
				
				char sBuffer[128];
				hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
				CheckVotes(iValue, sBuffer);
			}
		}
		case MenuAction_DisplayItem:
		{
			char sBuffer[128];
			if(iItem == 0)	FormatEx(sBuffer, sizeof(sBuffer), "T", "CR_Votes_Cancel");
			else
			{
				hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
				Format(sBuffer, sizeof(sBuffer), "%s [%i/%i]", sBuffer, g_hArray.Get(iItem), GetReuiredPlayers());
			}
			
			return RedrawMenuItem(sBuffer);
		}
		case MenuAction_Display:
		{
			char sBuffer[128];
            FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_Votes_Menu", iClient);
            (view_as<Panel>(iItem)).SetTitle(sBuffer);
		}
		case MenuAction_DrawItem:	if(g_iPlayerChoose[iClient] == iItem)
		{
			return ITEMDRAW_DISABLED;
		}
	}
}

void CheckVotes(int iValue)
{
	if(iValue >= g_iRequired)
	{
		if(g_bType)	CR_SetNextRound(
	}
}

void GetReuiredPlayers()
{
	int i, iPlayers;
	for(i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i) && !IsFakeClient(i))
	{
		++iPlayers;
	}
	
	g_iRequired = RoundToCeil(float(iPlayers) * g_fRatio);
	if(g_iRequired < g_iMinimum) g_iRequired = g_iMinimum;
	
	CheckVotes();
}

public void OnClientPostAdminCheck(int iClient)
{
	if(!IsFakeClient(iClient)
	{
		++iPlayers;
		g_iRequired = RoundToCeil(float(iPlayers) * g_fRatio);
		if(g_iRequired < g_iMinimum) g_iRequired = g_iMinimum;
		CheckVotes();
	}
}

public void OnClientDisconnect(int iClient)
{
	g_iPlayerChoose[iClient] = -1;
	GetReuiredPlayers();
}

