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
	version     = 	"2.1",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

ArrayList g_hWeapons, g_hSave[MAXPLAYERS+1];

bool g_bSave, g_bClear, g_bNoKnife, g_bUse, g_bClearKey, g_bBlockPickUP, g_bBlockPick;

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_weapons_save_weapon", "1", "Save weapons before custom round start.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Save);
	g_bSave = CVAR.BoolValue;
	
	(CVAR = CreateConVar("sm_cr_weapons_clear_weapon", "1", "Strip all weapons from players, when custom rounds starts with weapons.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Clear);
	g_bClear = CVAR.BoolValue;
	
	g_hWeapons = new ArrayList(ByteCountToCells(32));
	
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

public void OnClientDisconnect(int iClient)
{
	if(g_hSave[iClient]) delete g_hSave[iClient];
}

public void OnMapStart()
{
	g_bNoKnife = false;
	g_bUse = false;
	g_bBlockPick = false;
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
					if(!strcmp(sWeapon, "give"))			g_hWeapons.Push(0);	
					else if(!strcmp(sWeapon, "equip"))		g_hWeapons.Push(1);
					else if(!strcmp(sWeapon, "ignore"))		g_hWeapons.Push(2);

					Kv.GetString(NULL_STRING, sWeapon, sizeof(sWeapon));
					g_hWeapons.PushString(sWeapon);
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
		if(!Kv.GetNum("clear_map", 0))	ClearMap();
	}
}

public void CR_OnPlayerSpawn(int iClient, KeyValues Kv)
{
	if(Kv)
	{
		if((g_bUse && g_bClear) || g_bClearKey)	ClearWeapons(iClient, view_as<int>((g_bSave && !g_hSave[iClient])));
		if(g_bUse)
		{
			char sBuffer[32];
			int w, iSize = g_hWeapons.Length;
			for(w = 0; w < iSize; w+=2)
			{
				switch(g_hWeapons.Get(w))
				{
					case 0: 
					{
						g_hWeapons.GetString(w+1, sBuffer, sizeof(sBuffer));
						GivePlayerItem(iClient, sBuffer);
					}
					case 1: 
					{
						g_hWeapons.GetString(w+1, sBuffer, sizeof(sBuffer));
						EquipPlayerWeapon(iClient, GivePlayerItem(iClient, sBuffer));
					}
					default: continue;
				}
			}
		}
	}
	else if(g_hSave[iClient])
	{
		ClearWeapons(iClient, 3);
		char sBuffer[32];
		for(int i, iLen = g_hSave[iClient].Length; i < iLen; i++)
		{
			g_hSave[iClient].GetString(i, sBuffer, sizeof(sBuffer));

			if(		!strcmp(sBuffer[7], "fists") 	|| !strcmp(sBuffer[7], "axe") 
				|| 	!strcmp(sBuffer[7], "spanner") 	|| !strcmp(sBuffer[7], "hammer"))
			{
				EquipPlayerWeapon(iClient, GivePlayerItem(iClient, sBuffer));
			}
			else GivePlayerItem(iClient, sBuffer);
		}
		delete g_hSave[iClient];
	}
}

/*
public Action WeaponSpawn(Handle hTimer, DataPack hPack)
{
	hPack.Reset();
	EquipPlayerWeapon(hPack.ReadCell(), hPack.ReadCell());
	
	delete hPack;
}
*/

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(g_bUse)
	{
		for(int i = 1; i <= MaxClients; i++)	if(IsClientInGame(i) && IsPlayerAlive(i))
		{
			ClearWeapons(i, 1);
		}
		g_bBlockPickUP = true;
	}
}

void ClearWeapons(int iClient, int iType)
{
	char sBuffer[32];
	for (int iEnt, i; i <= 3; i++)
    {
		if(iType != 3 && g_bNoKnife && i == 2) continue;
		while ((iEnt = GetPlayerWeaponSlot(iClient, i)) != -1)
		{
			if(iType == 2)
			{
				if(!g_hSave[iClient]) g_hSave[iClient] = new ArrayList(ByteCountToCells(32));
				GetEdictClassname(iEnt, sBuffer, sizeof(sBuffer));
				g_hSave[iClient].PushString(sBuffer);
			}
			RemovePlayerItem(iClient, iEnt);
			if(iType == 1) AcceptEntityInput(iEnt, "Kill");
		}
    }
}

void ClearMap()
{
	//char sBuffer[32];

	int iEnt = MaxClients+1;
	while ((iEnt = FindEntityByClassname(iEnt, "weapon_*")) != INVALID_ENT_REFERENCE)
	{
		if(GetEntPropEnt(iEnt, Prop_Data, "m_hOwnerEntity") == 0)	RemoveEdict(iEnt);
		/*
		if(IsValidEdict(iEnt) && GetEntPropEnt(iEnt, Prop_Data, "m_hOwnerEntity") < 0 && GetEdictClassname(iEnt, sBuffer, sizeof(sBuffer)))
		{
			if(StrContains(sBuffer, "weapon_") == 0)	RemoveEdict(iEnt);
		}
		*/
	}
}

public Action OnWeaponCanUse(int iClient, int weapon) 
{
	if(g_bBlockPickUP) return Plugin_Handled;

	if(g_bBlockPick)
	{
		static char sBuffer[32];
		GetEdictClassname(weapon, sBuffer, sizeof(sBuffer));
		if(g_hWeapons.FindString(sBuffer) == -1 && strcmp("defuser", sBuffer[5]) != 0 && strcmp("c4", sBuffer[7]) != 0)	return Plugin_Handled;
	}
	return Plugin_Continue;
}