#include <custom_rounds>
#include <sdktools_gamerules>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Votes",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

#define Plugin_PrintToChat PrintToChat
#define Plugin_PrintToChatAll PrintToChatAll

ArrayList g_hPlayerVotes[MAXPLAYERS+1];
ArrayList g_hQueue;
Menu g_hMenu;
int g_iMinimum, g_iMaximum, g_iPlayers, g_iRequired, g_iRounds, g_iInterval, g_iTime[MAXPLAYERS+1];
float g_fRatio;
bool g_bType;
char g_sBlocked[MAX_ROUND_NAME_LENGTH];

public void OnPluginStart()
{
	ConVar CVAR;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_votes_minimum", 			"4", 		"Minimum required players for vote.", 						_, true, 0.0)).AddChangeHook(ChangeCvar_Minimum);
	g_iMinimum			= 		CVAR.IntValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_votes_maximum", 			"4", 		"Max votes per player at the same time. 0 - disable", 		_, true, 0.0)).AddChangeHook(ChangeCvar_Maximum);
	g_iMaximum			= 		CVAR.IntValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_votes_ratio", 			"0.60", 	"Player ratio for succesfull vote.", 						_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Ratio);
	g_fRatio		 	= 		CVAR.FloatValue;
	
	(CVAR				= 		CreateConVar("sm_custon_rounds_votes_type", 			"1", 		"0 - start immediately | 1 - set next round.", 				_, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Type);
	g_bType		 		= 		CVAR.BoolValue;

	(CVAR				= 		CreateConVar("sm_custon_rounds_votes_interval", 		"0", 		"Interval between rounds. 0 - disable.", 					_, true, 0.0)).AddChangeHook(ChangeCvar_Interval);
	g_iInterval			= 		CVAR.IntValue;

	RegConsoleCmd(				"sm_voteround", 		CMD_VR			);
	RegConsoleCmd(				"sm_vr", 				CMD_VR			);
	RegConsoleCmd(				"sm_cr", 				CMD_VR			);

	if(!g_hQueue) g_hQueue = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));
	
	g_hMenu = new Menu(CR_Votes_Menu_Handler, MenuAction_DrawItem|MenuAction_Select|MenuAction_Display|MenuAction_DisplayItem);
	g_hMenu.SetTitle("Votes");
	g_hMenu.ExitButton = true;

	AutoExecConfig(true, "cr_votes", "sourcemod/custom_rounds");

	LoadTranslations("custom_rounds.phrases");
}

public void OnMapStart()
{
	g_iRounds = 0;
}

public void ChangeCvar_Minimum(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iMinimum			=		convar.IntValue;
	CountRatio();
	int iCount;
	CountVotes(iCount);
	if(iCount > 0)	Plugin_PrintToChatAll("%t%t", "Prefix", "CR_VOTES_ConVar_Change", iCount);
}

public void ChangeCvar_Maximum(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iMaximum			=		convar.IntValue;
}

public void ChangeCvar_Ratio(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_fRatio			= 		convar.FloatValue;
	CountRatio();
	int iCount;
	CountVotes(iCount);
	if(iCount > 0)	Plugin_PrintToChatAll("%t%t", "Prefix", "CR_VOTES_ConVar_Change", iCount);
}

public void ChangeCvar_Type(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bType			= 		convar.BoolValue;
}

public void ChangeCvar_Interval(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_iInterval		= 		convar.IntValue;
	g_iRounds = 0;
}

public void CR_OnConfigLoad()
{
	g_iPlayers = 0; // Стоит проверить
	g_hQueue.Clear();
	g_hMenu.RemoveAllItems();
	g_hMenu.AddItem(NULL_STRING, "Cancel");
}

public void CR_OnConfigSectionLoadPost(const char[] sName)
{
	g_hMenu.AddItem(NULL_STRING, sName);
}

public Action CMD_VR(int iClient, int iArgs)
{
	if(iClient > 0 && IsValidForCheck(iClient))	g_hMenu.Display(iClient, MENU_TIME_FOREVER);
	return Plugin_Handled;
}

public int CR_Votes_Menu_Handler(Menu hMenu, MenuAction iAction, int iClient, int iItem)
{
	switch(iAction)	
	{
		case MenuAction_Select:
		{
			if(g_iTime[iClient] > GetTime()) Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Wait");
			else
			{
				if(!iItem)
				{
					if(g_hPlayerVotes[iClient].Length)
					{
						g_hPlayerVotes[iClient].Clear();
						Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Cancel_All");
						for(int i = 1; i <= MaxClients; i++) if(IsValidForCheck(i) && i != iClient)
						{
							Plugin_PrintToChat(i, "%t%t", "Prefix", "CR_VOTES_Cancel_All_Announce", iClient);
						}
					}
					else Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Cancel_No_Votes");
				}
				else
				{
					char sBuffer[MAX_ROUND_NAME_LENGTH];
					hMenu.GetItem(iItem, "", 0, _, sBuffer, sizeof(sBuffer));
					iItem--;

					if(g_hQueue.FindString(sBuffer) != -1 || !strcmp(g_sBlocked, sBuffer))	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Not_Available");
					else
					{
						if(g_hPlayerVotes[iClient].FindValue(iItem) == -1)
						{
							if(g_iMaximum != 0 && g_hPlayerVotes[iClient].Length+1 > g_iMaximum)	Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Maximum_Votes", g_iMaximum);
							else 
							{
								int iNum = GetRoundVoteCount(iItem);
								Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Voted", sBuffer, iNum+1, g_iRequired);
								for(int i = 1; i <= MaxClients; i++) if(IsClientInGame(i) && !IsFakeClient(i) && i != iClient)
								{
									Plugin_PrintToChat(i, "%t%t", "Prefix", "CR_VOTES_Voted_Announce", iClient, sBuffer, iNum+1, g_iRequired);
								}

								if(iNum+1 >= g_iRequired)
								{
									ProcessQueueOperations(sBuffer);

									ClearPlayersSpecificVote(iItem);
									Plugin_PrintToChatAll("%t%t", "Prefix", "CR_VOTES_Announce", sBuffer);
								}
								else	g_hPlayerVotes[iClient].Push(iItem);
							}

						}
						else
						{
							g_hPlayerVotes[iClient].Erase(g_hPlayerVotes[iClient].FindValue(iItem));
							int iNum = GetRoundVoteCount(iItem);
							Plugin_PrintToChat(iClient, "%t%t", "Prefix", "CR_VOTES_Cancel", sBuffer, iNum, g_iRequired);
							for(int i = 1; i <= MaxClients; i++) if(IsValidForCheck(i) && i != iClient)
							{
								Plugin_PrintToChat(i, "%t%t", "Prefix", "CR_VOTES_Cancel_Announce", iClient, sBuffer, iNum, g_iRequired);
							}
						}
					}
				}
				g_iTime[iClient] += 3;
			}
			g_hMenu.Display(iClient, MENU_TIME_FOREVER);
		}
		case MenuAction_DrawItem:
		{
			char sBuffer[MAX_ROUND_NAME_LENGTH];
			hMenu.GetItem(iItem, "", 0, _, sBuffer, sizeof(sBuffer));
			if(g_hQueue.FindString(sBuffer) != -1 || !strcmp(g_sBlocked, sBuffer))
			{
				return ITEMDRAW_DISABLED;
			}
		}
		case MenuAction_DisplayItem:
		{
			char sBuffer[128];
			if(!iItem)	FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_VOTES_Cancel_Item", iClient);
			else
			{
				hMenu.GetItem(iItem, "", 0, _, sBuffer, sizeof(sBuffer));
				iItem--;
				Format(sBuffer, sizeof(sBuffer), "[%s][%i/%i] %s", g_hPlayerVotes[iClient].FindValue(iItem) != -1 ? "✅":"❎", GetRoundVoteCount(iItem), g_iRequired, sBuffer);
			}
			
			return RedrawMenuItem(sBuffer);
		}
		case MenuAction_Display:
		{
			char sBuffer[128];
			g_iMaximum != 0 ? FormatEx(sBuffer, sizeof(sBuffer), "%T%T", "CR_VOTES_Title", iClient, "CR_VOTES_Title_Votes", iClient, g_hPlayerVotes[iClient].Length, g_iMaximum):FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_VOTES_Title", iClient);
			(view_as<Panel>(iItem)).SetTitle(sBuffer);
		}
	}
	return 0;
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)											g_iRounds = g_iInterval;
	else if(g_iRounds > 0)							--g_iRounds;
	if(g_hQueue.Length)
	{
		if(g_bType && (!g_iInterval || g_iRounds-1 < 1) && !CR_IsNextRoundCustom())
		{
			char sBuffer[MAX_ROUND_NAME_LENGTH];
			g_hQueue.GetString(0, sBuffer, sizeof(sBuffer));
			g_hQueue.Erase(0);
			CR_SetNextRound(sBuffer);
			strcopy(g_sBlocked, sizeof(g_sBlocked), sBuffer);
		}
		else if(!g_bType && (!g_iInterval || g_iRounds < 1) && !Kv && GameRules_GetProp("m_bWarmupPeriod") != 1)
		{
			char sBuffer[MAX_ROUND_NAME_LENGTH];
			g_hQueue.GetString(0, sBuffer, sizeof(sBuffer));
			g_hQueue.Erase(0);
			CR_StartRound(sBuffer);
			strcopy(g_sBlocked, sizeof(g_sBlocked), sBuffer);
		}
	}
}

int GetRoundVoteCount(int iNum)
{
	int iCount;
	for(int i = 1; i <= MaxClients; i++) if(IsValidForCheck(i) && g_hPlayerVotes[i] && g_hPlayerVotes[i].FindValue(iNum) != -1)
	{
		iCount++;
	}
	return iCount;
}

void ClearPlayersSpecificVote(int iNum)
{
	int iVoteNum;
	for(int i = 1; i <= MaxClients; i++) if(IsValidForCheck(i) && (iVoteNum = g_hPlayerVotes[i].FindValue(iNum)) != -1)
	{
		g_hPlayerVotes[i].Erase(iVoteNum);
	}
}

bool IsValidForCheck(int iClient)
{
	return IsClientInGame(iClient) && !IsFakeClient(iClient);
}

public void OnClientPostAdminCheck(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		g_hPlayerVotes[iClient] = new ArrayList();
		++g_iPlayers;
		CountRatio();
	}
}

public void OnClientDisconnect(int iClient)
{
	if(!IsFakeClient(iClient))
	{
		g_iPlayers--;
		CountRatio();
		
		delete g_hPlayerVotes[iClient];

		int iCount;
		CountVotes(iCount);

		if(iCount > 0)	Plugin_PrintToChatAll("%t%t", "Prefix", "CR_VOTES_Player_Leave", iCount);
	}
}

void CountVotes(int &iCount)
{
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	for(int i = 1, iLen = GetMenuItemCount(g_hMenu); i <= iLen; i++)
	{
		if(GetRoundVoteCount(i) >= g_iRequired)
		{
			g_hMenu.GetItem(i, "", 0, _, sBuffer, sizeof(sBuffer));
			ProcessQueueOperations(sBuffer);
			ClearPlayersSpecificVote(i);
			iCount++;
		}
	}
}

void CountRatio()
{
	g_iRequired = RoundToCeil(float(g_iPlayers) * g_fRatio);
	if(g_iRequired < g_iMinimum) g_iRequired = g_iMinimum;
}

void ProcessQueueOperations(const char[] sBuffer)
{
	if(g_bType)	
	{
		if(CR_IsNextRoundCustom())
		{
			g_hQueue.PushString(sBuffer);
		}
		else CR_SetNextRound(sBuffer);
	}
	else if(CR_IsCustomRound())
	{
		g_hQueue.PushString(sBuffer);
	}
	else CR_StartRound(sBuffer);
}