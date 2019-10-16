#include <custom_rounds>
#include <sdkhooks>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] No Zoom",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};


bool g_bNoZoom, g_bHooked[MAXPLAYERS+1];
int m_flNextSecondaryAttack = -1;

public void OnPluginStart()
{
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
}

public Action OnPreThink(int iWeapon)
{
	iWeapon = GetEntPropEnt(iWeapon, Prop_Send, "m_hActiveWeapon");

	if (IsValidEdict(iWeapon))
	{
		static char sClassname[32];
		GetEdictClassname(iWeapon, sClassname, sizeof(sClassname));
		
		if (strcmp(sClassname[7], "knife") && strcmp(sClassname[7], "hegrenade") && strcmp(sClassname[7], "incgrenade") && strcmp(sClassname[7], "molotov") && strcmp(sClassname[7], "smokegrenade") && strcmp(sClassname[7], "tagrenade") && strcmp(sClassname[7], "flashbang") && strcmp(sClassname[7], "decoy"))
		{
			SetEntDataFloat(iWeapon, m_flNextSecondaryAttack, GetGameTime() + 2.0);
		}
	}
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)	g_bNoZoom = view_as<bool>(Kv.GetNum("no_zoom", 0));
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(Kv)	g_bNoZoom = false;
}

public void CR_OnPlayerSpawn(int iClient, KeyValues Kv)
{
	if(g_bHooked[iClient])
	{
		SDKUnhook(iClient, SDKHook_PreThink, OnPreThink);
		g_bHooked[iClient] = false;
	}
	if(Kv)
	{
		if(g_bNoZoom)
		{
			g_bHooked[iClient] = SDKHookEx(iClient, SDKHook_PreThink, OnPreThink);
		}
	}
}

public void OnClientPutInServer(int iClient)
{
	g_bHooked[iClient] = false;
}