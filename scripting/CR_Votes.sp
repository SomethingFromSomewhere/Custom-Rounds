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

ArrayList g_hArray, g_hPlayerVotes[MAXPLAYERS+1];
Menu g_hMenu = null;

public void OnPluginStart()
{
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_minimum", 		"4", 		"Minimum required players for vote.", 						_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Minimum);
	g_iMinimum			= 		CVAR.IntValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_maximum", 		"4", 		"Max votes per player at the same time.", 						_, true, 0.0)).AddChangeHook(ChangeCvar_Maximum);
	g_iMaximum			= 		CVAR.IntValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_ratio", 			"0.60", 	"Player ratio for succesfull vote.", 		_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Ratio);
	g_fRatio		 	= 		CVAR.FloatValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_vote_type", 			"1", 		"0 - immediately | 1 - next round.", 	_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Type);
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
	//g_hArray.Push(0);
	g_hMenu.RemoveAllItems();
	g_hMenu.AddItem(sName, "Cancel");
}

public void CR_OnConfigSectionLoadPost(const char[] sName)
{
	g_hMenu.AddItem(sName, sName);
}

public Action CMD_VR(int iClient, int iArgs)
{
	if(iClient > 0 && IsClientInGame(iClient))	g_hMenu.Display(iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public int CR_Menu_Handler(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)	
	{
		case MenuAction_Select:
		{
			if(iItem != 0)
			{
				char sBuffer[MAX_ROUND_NAME_LENGTH];
				hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
			
				int iNum;
				if(iNum = g_hPlayerVotes[iClient].Find(iItem-1)) == -1)
				{
					iItem = g_hRounds.Get(iNum);
					g_hPlayerVotes[iClient].Push(iItem);
					g_hRounds.Set(iItem-1, (iItem = g_hRounds.Get(iNum))+1);
					
					CheckVotes(iItem);
				}
				else g_hPlayerVotes[iClient].Erase(iNum);
			}
			else	ClearPlayer(iClient);
		}
		case MenuAction_DisplayItem:
		{
			char sBuffer[MAX_ROUND_NAME_LENGTH];
			if(iItem == 0)	FormatEx(sBuffer, sizeof(sBuffer), "T", "CR_Votes_Cancel", iClient);
			else
			{
				hMenu.GetItem(iItem, sBuffer, sizeof(sBuffer));
				Format(sBuffer, sizeof(sBuffer), "[%s|%i|%i] %s", g_hPlayerVotes[iClient].Find(iItem-1) ? '☑':'☒', g_hRounds.Get(iItem-1), g_iRequired, sBuffer);
			}
			
			if(g_hPlayerVotes[iClient].Find(iItem-1));
			
			return RedrawMenuItem(sBuffer);
		}
		case MenuAction_Display:
		{
			char sBuffer[128];
            FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_Votes_Menu", iClient);
            (view_as<Panel>(iItem)).SetTitle(sBuffer);
		}
		For
	}
}

void CheckVotes(int iValue)
{
	if(iValue >= g_iRequired)
	{
		g_bType	?	CR_SetNextRound(
	}
}
public void OnClientPostAdminCheck(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		++g_iPlayers;
		CountRatio();
	}
}

public void OnClientDisconnect(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		--g_iPlayers;
		CountRatio();
		
		ClearPlayer(iClient);
	}
}

void CountRatio()
{
	g_iRequired = RoundToCeil(float(iPlayers) * g_fRatio);
	if(g_iRequired < g_iMinimum) g_iRequired = g_iMinimum;
}

void ClearPlayer(int iClient)
{
	int i, iLen = g_hPlayerVotes[iClient].Lenght, iValue;
	for(int i = 1; i < iLen; i++)
	{
		iValue = g_hRounds.Get(i);
		if(iValue > 0)
		{
			g_hRounds.Set(iValue, g_hRounds.Get(iValue)-1);
		}
	}
	
	g_hPlayerVotes[iClient].Clear();
}