#pragma semicolon 1
#pragma newdecls required

#include <sdkhooks>
#include <custom_rounds>
#include <sdktools_entinput>
#include <sdktools_functions>

public Plugin myinfo =
{
	name        = 	"[CR] Weapons",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

ArrayList g_hWeapons;

bool g_bSave, g_bClear, g_bNoKnife, g_bUse, g_bSaved[MAXPLAYERS+1], g_bClearKey, g_bBlockPickUP, g_bBlockPick;
char g_sPrimary[MAXPLAYERS+1][32], g_sSecondary[MAXPLAYERS+1][32];

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_weapons_save_weapon", "1", "Save weapons before custom round start.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Save);
	g_bSave = CVAR.BoolValue;
	
	(CVAR = CreateConVar("sm_cr_weapons_clear_weapon", "1", "Strip all weapons from players, when custom rounds starts with weapons.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Clear);
	g_bClear = CVAR.BoolValue;
	
	g_hWeapons = new ArrayList(ByteCountToCells(64));
	
	AutoExecConfig(true, "cr_weapons", "sourcemod/custom_rounds");
}

public void ChangeCvar_Save(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bSave = convar.BoolValue;
}

public void ChangeCvar_Clear(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bClear = convar.BoolValue;
}

public void OnClientPutInServer(int iClient)
{
	SDKHook(iClient, SDKHook_WeaponCanUse, OnWeaponCanUse);
}

public void OnMapStart()
{
	g_bNoKnife = false;
	g_bUse = false;
	g_bBlockPick = false;
	int i;
	for(i = 1; i <= MaxClients; i++)
	{
		g_bSaved[i] = false;
		g_sPrimary[i][0] = '\0';
		g_sSecondary[i][0] = '\0';
	}
}


public void CR_OnRoundStart(KeyValues Kv)
{
	g_hWeapons.Clear();
	g_bBlockPick = false;
	g_bBlockPickUP = false;
	g_bClearKey = false;
	g_bNoKnife = false;
	g_bUse = false;
	
	if(Kv)
	{
		char sWeapon[32];

		if (Kv.JumpToKey("Weapons") && Kv.GotoFirstSubKey(false))
		{
			do
			{
				if(Kv.GetSectionName(sWeapon, sizeof(sWeapon)))
				{
					g_hWeapons.PushString(sWeapon);
					Kv.GetString(NULL_STRING, sWeapon, sizeof(sWeapon));
					if(sWeapon[0])	g_hWeapons.PushString(sWeapon);
				}
			}
			while (Kv.GotoNextKey(false));
			g_bUse = true;
			Kv.GoBack();
			Kv.GoBack();
		}
		
		g_bBlockPick = view_as<bool>(Kv.GetNum("block_pickup", 0));
		g_bNoKnife = view_as<bool>(Kv.GetNum("no_knife", 0));
		g_bClearKey = view_as<bool>(Kv.GetNum("no_weapon", 0));
		if(view_as<bool>(Kv.GetNum("clear_map", 0)))	ClearMap();
	}
	else
	{
		for(int iClient = 1; iClient <= MaxClients; iClient++)	if(IsClientInGame(iClient) && IsPlayerAlive(iClient) && g_bSaved[iClient])
		{
			if(g_sPrimary[iClient][0])	GivePlayerItem(iClient, g_sPrimary[iClient]);	g_sPrimary[iClient][0] = '\0';
			if(g_sSecondary[iClient][0])	GivePlayerItem(iClient, g_sSecondary[iClient]);	g_sSecondary[iClient][0] = '\0';
			g_bSaved[iClient] = false;
		}
	}
}

public void CR_OnPlayerSpawn(int iClient, KeyValues Kv)
{
	if(Kv)
	{
		if((g_bUse && g_bClear) || g_bClearKey)	ClearWeapons(iClient, (g_bSave && !g_bSaved[iClient]));
		if(g_bUse)
		{
			char sBuffer[32];
			int w, iSize = g_hWeapons.Length;
			for(w = 0; w < iSize; ++w)
			{
				g_hWeapons.GetString(w, sBuffer, sizeof(sBuffer));
				EquipPlayerWeapon(iClient, GivePlayerItem(iClient, sBuffer));
			}
		}
		if(g_bNoKnife)	RemoveKnife(iClient);
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(g_bUse)
	{
		int i;
		for(i = 1; i <= MaxClients; i++)	if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			ClearWeapons(i);
		}
		g_bBlockPickUP = true;
	}
}

void ClearWeapons(int iClient, bool bSave = false)
{
	int iEnt;
	for (int i = 0; i <= 3; i++)	if(i != 2)
    {
		while ((iEnt = GetPlayerWeaponSlot(iClient, i)) != -1)
		{
			if(bSave)
			{
				switch(i)
				{
					case 0:
					{
						GetEdictClassname(iEnt, g_sPrimary[iClient], sizeof(g_sPrimary[]));
						g_bSaved[iClient] = true;
					}
					case 1:
					{
						GetEdictClassname(iEnt, g_sSecondary[iClient], sizeof(g_sPrimary[]));
						g_bSaved[iClient] = true;
					}
				}
			}
			RemovePlayerItem(iClient, iEnt);
			AcceptEntityInput(iEnt, "Kill");
		}
    }
}

void ClearMap()
{
	char sBuffer[32];

	int e = GetMaxEntities();
	for(int i = MaxClients; i < e; i++)
	{
		if(IsValidEdict(i) && GetEntPropEnt(i, Prop_Data, "m_hOwnerEntity") < 0)
		{
			GetEdictClassname(i, sBuffer, sizeof(sBuffer));
			if(StrContains(sBuffer, "weapon_") == 0)	RemoveEdict(i);
		}
	}
}

void RemoveKnife(int iClient)
{
	int iEnt;	
	while ((iEnt = GetPlayerWeaponSlot(iClient, 2)) != -1)
	{
		RemovePlayerItem(iClient, iEnt);
		AcceptEntityInput(iEnt, "Kill");
	}
}

public Action OnWeaponCanUse(int iClient, int weapon) 
{
	if(g_bUse)
	{
		char sBuffer[32];
		GetEdictClassname(weapon, sBuffer, sizeof(sBuffer));
		if((g_bBlockPickUP || (g_bBlockPick && g_hWeapons.FindString(sBuffer) == -1)) && strcmp("defuser", sBuffer[5]) != 0 && strcmp("c4", sBuffer[5]) != 0)	return Plugin_Handled;
	}
	return Plugin_Continue;
}