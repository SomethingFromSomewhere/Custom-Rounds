#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <sdkhooks>

public Plugin myinfo =
{
	name        = 	"[CR] No Zoom",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};


bool g_bNoZoom;
int m_flNextSecondaryAttack = -1;

public void OnPluginStart()
{
	m_flNextSecondaryAttack = FindSendPropInfo("CBaseCombatWeapon", "m_flNextSecondaryAttack");
}

public void OnClientPutInServer(int iClient)
{
	SDKHook(iClient, SDKHook_PreThink, OnPreThink);
}

public Action OnPreThink(int iClient)
{
	if(g_bNoZoom)	SetNoScope(GetEntPropEnt(iClient, Prop_Send, "m_hActiveWeapon"));
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)	g_bNoZoom = view_as<bool>(Kv.GetNum("no_zoom", 0));
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(Kv)	g_bNoZoom = false;
}

void SetNoScope(int iWeapon)
{
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