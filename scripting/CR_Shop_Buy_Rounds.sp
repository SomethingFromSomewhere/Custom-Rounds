#include <custom_rounds>
#include <shop>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR/Shop] Buy Rounds",
	author      = 	"Someone",
	version     = 	"1.0",
	url         = 	"http://hlmod.ru"
};

KeyValues Kv;

public void OnPluginStart()
{
	LoadTranslations("custom_rounds.phrases");
	if (Shop_IsStarted()) Shop_Started();
}


public void Shop_Started()
{
	delete Kv;
	Kv = new KeyValues("Custom_Rounds");
	CategoryId iCategory_id = Shop_RegisterCategory("Custom_Rounds", "Раунды", "");
	
	char cBuffer[PLATFORM_MAX_PATH];
	Shop_GetCfgFile(cBuffer, sizeof(cBuffer), "custom_rounds.ini");
	if (!FileToKeyValues(Kv, cBuffer)) SetFailState("Файл конфигурации не найден %s", cBuffer);
	
	
	char cName[64], cDescription[64];
	Kv.Rewind();

	if (Kv.GotoFirstSubKey())
	{
		do
		{
			if (Kv.GetSectionName(cName, sizeof(cName)) && Shop_StartItem(iCategory_id, cName))
			{
				Kv.GetString("name", cName, sizeof(cName));
				Kv.GetString("description", cDescription, sizeof(cDescription), "");
				
				Shop_SetInfo(cName, cDescription, Kv.GetNum("price", 1000), Kv.GetNum("sell_price", 250), Item_BuyOnly);
				Shop_SetCallbacks(_, _, _, _, _, _, OnItemBuy);
				Shop_EndItem();
			}
		}
		while (Kv.GotoNextKey());
	}
}

public bool OnItemBuy(int iClient, CategoryId category_id, const char[] category, ItemId item_id, const char[] item, ItemType type, int price, int sell_price, int value)
{
	if(CR_IsNextRoundCustom())
	{
		PrintToChat(iClient, "%t %t", "Prefix", "Next_Round_Already_Custom");
		return false;
	}
	
	Kv.Rewind();
	if(Kv.JumpToKey(item))
	{
		if(!CR_SetNextRound(item, iClient))
		{
			PrintToChat(iClient, "%t %t", "Prefix", "Failed_To_Set_Round");
			return false;
		}
	}
	return false;
}