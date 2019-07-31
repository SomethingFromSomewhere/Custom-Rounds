#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Ammo",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

ConVar CVAR;
int g_iDefault = -1;

public void OnPluginStart()
{
	CVAR = FindConVar("sv_infinite_ammo");
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		g_iDefault = CVAR.IntValue;
		CVAR.SetInt(Kv.GetNum("ammo", 0));
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(Kv)
	{
		if(g_iDefault != -1)
		{
			CVAR.SetInt(g_iDefault);
			g_iDefault = -1;
		}
	}
}