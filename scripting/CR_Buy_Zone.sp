#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdktools_entinput>

public Plugin myinfo =
{
	name        = 	"[CR] Buy Zone",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa"
};

bool g_bNoBuy;

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		g_bNoBuy = view_as<bool>(Kv.GetNum("no_buy"));
		if(g_bNoBuy)	SetBuyZones("Disable");
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(g_bNoBuy)	SetBuyZones("Enable");	g_bNoBuy = false;
}


void SetBuyZones(const char[] status)
{
	int maxEntities = GetMaxEntities();
	char class[14];
	
	for (int i = MaxClients + 1; i < maxEntities; i++)
	{
		if (IsValidEdict(i))
		{
			GetEdictClassname(i, class, sizeof(class));
			if (!strcmp(class, "func_buyzone")) AcceptEntityInput(i, status);
		}
	}
}