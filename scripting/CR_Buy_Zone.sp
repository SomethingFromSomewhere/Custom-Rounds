#include <custom_rounds>
#include <sdktools_entinput>
#include <sdktools_functions>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Buy Zone",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

bool g_bNoBuy;

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv && (g_bNoBuy = view_as<bool>(Kv.GetNum("no_buy"))))
	{
		SetBuyZones("Disable");
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(g_bNoBuy)	SetBuyZones("Enable");	g_bNoBuy = false;
}

void SetBuyZones(const char[] sInput)
{
	int iEnt = MaxClients+1;

	while ((iEnt = FindEntityByClassname(iEnt, "func_buyzone")) != INVALID_ENT_REFERENCE) 
	{
		AcceptEntityInput(iEnt, sInput);
	}
}

