#include <custom_rounds>
#include <shop>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR/Shop] Buy Rounds",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
	if (Shop_IsStarted()) Shop_Started();
}

public void Shop_Started()
{
	KeyValues Kv = new KeyValues("CustomRounds");
	
	char sBuffer[PLATFORM_MAX_PATH], sDescription[128];
	
	Kv.GetString("category_name", sBuffer, sizeof(sBuffer));
	Kv.GetString("category_desc", sDescription, sizeof(sDescription));
	CategoryId iCategory_id = Shop_RegisterCategory("Custom_Rounds", sBuffer, sDescription);
	
	Shop_GetCfgFile(sBuffer, sizeof(sBuffer), "custom_rounds.ini");
	if (!FileToKeyValues(Kv, sBuffer)) SetFailState("Missing config file %s", sBuffer);

	if (Kv.GotoFirstSubKey())
	{
		do
		{
			if (Kv.GetSectionName(sBuffer, sizeof(sBuffer)) && Shop_StartItem(iCategory_id, sBuffer))
			{
				Kv.GetString("name", sBuffer, sizeof(sBuffer));
				Kv.GetString("description", sDescription, sizeof(sDescription));
				
				Shop_SetInfo(sBuffer, sDescription, Kv.GetNum("price"), Kv.GetNum("sell_price"), Item_BuyOnly, 1, Kv.GetNum("gold_price"), Kv.GetNum("gold_sell_price"));
				Shop_SetCallbacks(_, _, _, _, _, _, OnItemBuy);
				
				Kv.GetString("round", sBuffer, sizeof(sBuffer));
				Shop_SetCustomInfoString("n", sBuffer);
				Shop_SetCustomInfo("m", Kv.GetNum("mode"));
				
				Shop_EndItem();
			}
		}
		while (Kv.GotoNextKey());
	}
	delete Kv;
}

public bool OnItemBuy(int iClient, CategoryId category_id, const char[] category, ItemId iItem, const char[] item, ItemType type, int price, int sell_price, int value)
{
	/*
	if(CR_IsNextRoundCustom())
	{
		PrintToChat(iClient, "%t%t", "Prefix", "Next_Round_Already_Custom");
		return false;
	}
	*/
	
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	Shop_GetItemCustomInfoString(iItem, "n", sBuffer, sizeof(sBuffer));

	if((view_as<bool>(Shop_GetItemCustomInfo(iItem, "m")) ? !CR_StartRound(sBuffer, iClient):!CR_SetNextRound(sBuffer, iClient))
	{
		PrintToChat(iClient, "%t%t", "Prefix", "Failed_To_Set_Round");
		return false;
	}

	return true;
}