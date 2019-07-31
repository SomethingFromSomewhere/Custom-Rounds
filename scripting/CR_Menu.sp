#include <sdktools_gamerules>
#include <adminmenu>
#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required


public Plugin myinfo =
{
	name        = 	"[CR] Menu",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};


Menu g_hMenu;
TopMenu g_hCRMenu = null;
TopMenuObject g_hCR = INVALID_TOPMENUOBJECT;

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
	g_hMenu = new Menu(CR_Menu_Handler, MenuAction_Select|MenuAction_Display|MenuAction_Cancel);
	g_hMenu.SetTitle("");
	g_hMenu.ExitBackButton = true;
	RegAdminCmd("sm_acr", CMD_ACR, ADMFLAG_GENERIC);
}


public Action CMD_ACR(int iClient, int iArgs)
{
	if(iClient)
	{
		g_hCRMenu.DisplayCategory(g_hCR, iClient);
	}
	return Plugin_Handled;
}

public void CR_OnConfigLoad()
{
	g_hMenu.RemoveAllItems();
}

public void CR_OnConfigSectionLoadPost(const char[] sName, KeyValues Kv)
{
	g_hMenu.AddItem(sName, sName);
}

public int CR_Menu_Handler(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)	
	{
		case MenuAction_Select:
		{		
			char szInfo[256];
			hMenu.GetItem(iItem, szInfo, sizeof(szInfo));
			CreateAskMenu(iClient, szInfo);
		}
		case MenuAction_Display:
        {
            char szTitle[128];
            FormatEx(szTitle, sizeof(szTitle), "%T", "CR_MENU_Rounds", iClient);
            (view_as<Panel>(iItem)).SetTitle(szTitle);
        }
		case MenuAction_Cancel:
		{
			if(iItem == MenuCancel_ExitBack)
			{
				g_hCRMenu.DisplayCategory(g_hCR, iClient);
			}
		}
	}
	return 0;
}

void CreateAskMenu(int iClient, const char[] sName)
{
	Menu hAsk = new Menu(MenuAsk_Handler);
	char sBuffer[256];
	SetGlobalTransTarget(iClient);
	
	hAsk.SetTitle("%T", "CR_MENU_Ask", iClient);
	
	hAsk.AddItem(sName, sName, ITEMDRAW_DISABLED);
	
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_MENU_Now", iClient);
	hAsk.AddItem("", sBuffer);
	
	FormatEx(sBuffer, sizeof(sBuffer), "%T", "CR_MENU_Next", iClient);
	hAsk.AddItem("", sBuffer);
	
	hAsk.ExitBackButton = true;
	hAsk.Display(iClient, MENU_TIME_FOREVER);
}

public int MenuAsk_Handler(Menu hMenu, MenuAction action, int iClient, int iItem)
{
	switch(action)	
	{
		case MenuAction_Select:
		{
			char sBuffer[MAX_ROUND_NAME_LENGTH];
			hMenu.GetItem(0, sBuffer, sizeof(sBuffer));
			if(iItem == 1)
			{
				if(!CR_IsRoundEnd())
				{
					if(GameRules_GetProp("m_bWarmupPeriod") != 1)
					{
						//if(!CR_StartRound(sBuffer, iClient, true))	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Interval");
						CR_StartRound(sBuffer, iClient);
					}
					else	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Warmup");
				}
				else	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Round_End");
			}
			else if(iItem == 2)		CR_SetNextRound(sBuffer, iClient);//if(!CR_SetNextRound(sBuffer, iClient, true))	PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_Interval");
		}
		case MenuAction_Cancel:
		{
			g_hCRMenu.DisplayCategory(g_hCR, iClient);
		}
		case MenuAction_End:
		{
			if(iItem == MenuEnd_ExitBack)	g_hMenu.Display(iClient, MENU_TIME_FOREVER);
			delete hMenu;
		}
	}
	return 0;
}

public void OnAdminMenuReady(Handle aTopMenu)
{
    TopMenu hTopMenu = TopMenu.FromHandle(aTopMenu);

    if (hTopMenu == g_hCRMenu)
    {
        return;
    }

    g_hCRMenu = hTopMenu;
    g_hCR = g_hCRMenu.AddCategory("custom_rounds_category", Handler_MenuCRAdmin, "sm_cr", ADMFLAG_BAN, "CustomRounds");

    if (g_hCR != INVALID_TOPMENUOBJECT)
    {
		g_hCRMenu.AddItem("crc", 	Handler_CRC, 	g_hCR, "sm_acr", ADMFLAG_BAN, "CR_CANCEL");
		g_hCRMenu.AddItem("crcn", 	Handler_CRCN, 	g_hCR, "sm_acr", ADMFLAG_BAN, "R_CANCEL_NEXT");
		g_hCRMenu.AddItem("crcr", 	Handler_CRCR, 	g_hCR, "sm_acr", ADMFLAG_BAN, "CR_CHOOSE_ROUND");
	}
}

public void Handler_MenuCRAdmin(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
    switch (action)
    {
		case TopMenuAction_DisplayOption:
        {
            FormatEx(sBuffer, maxlength, "%T", "CR_MENU_Rounds", iClient);
        }
		case TopMenuAction_DisplayTitle:
		{
			FormatEx(sBuffer, maxlength, "%T:", "CR_MENU_Rounds", iClient);
		}
    }
}

public void Handler_CRC(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
    switch (action)
    {
		case TopMenuAction_DisplayOption:
        {
            FormatEx(sBuffer, maxlength, "%T", "CR_MENU_Disable_Current", iClient);
        }
		case TopMenuAction_SelectOption:
        {
			if(CR_IsCustomRound())	CR_StopRound(iClient);
			else PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_No_Custom_Round");
			g_hCRMenu.DisplayCategory(g_hCR, iClient);
        }
    }
}

public void Handler_CRCN(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
    switch (action)
    {
		case TopMenuAction_DisplayOption:
        {
            FormatEx(sBuffer, maxlength, "%T", "CR_MENU_Cancel_Next", iClient);
        }
		case TopMenuAction_SelectOption:
        {
			if(CR_IsNextRoundCustom())	CR_CancelNextRound(iClient);
			else PrintToChat(iClient, "%t %t", "Prefix", "CR_MENU_No_Next_Custom_Round");
			g_hCRMenu.DisplayCategory(g_hCR, iClient);
        }
    }
}

public void Handler_CRCR(TopMenu hMenu, TopMenuAction action, TopMenuObject object_id, int iClient, char[] sBuffer, int maxlength)
{
    switch (action)
    {
		case TopMenuAction_DisplayOption:
        {
            FormatEx(sBuffer, maxlength, "%T", "CR_MENU_Choose_Round", iClient);
        }
		case TopMenuAction_SelectOption:
        {
			g_hMenu.Display(iClient, MENU_TIME_FOREVER);
        }
    }
}