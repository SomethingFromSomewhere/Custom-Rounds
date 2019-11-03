#pragma semicolon 1
#pragma newdecls required

#include <cstrike>
#include <sdkhooks>
#include <custom_rounds>
#include <sdktools_entinput>
#include <sdktools_functions>

public Plugin myinfo =
{
	name        = 	"[CR] Weapons",
	author      = 	"Someone",
	version     = 	"2.1",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

ArrayList g_hWeapons, g_hSave[MAXPLAYERS+1];
int g_iDefinitionIndex, g_iTeam;
bool g_bSave, g_bClear, g_bNoKnife, g_bUse, g_bClearKey, g_bBlockPickUP, g_bBlockPick;
EngineVersion g_iEngine;

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_weapons_save_weapon", "1", "Save weapons before custom round start.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Save);
	g_bSave = CVAR.BoolValue;
	
	(CVAR = CreateConVar("sm_cr_weapons_clear_weapon", "1", "Strip all weapons from players, when custom rounds starts with weapons.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Clear);
	g_bClear = CVAR.BoolValue;
	
	g_hWeapons = new ArrayList();//ByteCountToCells(32));
	
	AutoExecConfig(true, "cr_weapons", "sourcemod/custom_rounds");

	if((g_iEngine = GetEngineVersion()) == Engine_CSGO)
	{
		g_iDefinitionIndex = FindSendPropInfo("CEconEntity", "m_iItemDefinitionIndex");
	}

	g_iTeam = FindSendPropInfo("CCSPlayer", "m_iTeamNum");
}

public void ChangeCvar_Save(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bSave = convar.BoolValue;
}

public void ChangeCvar_Clear(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bClear = convar.BoolValue;
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
		if(Kv.GetNum("clear_map", 0))	ClearMap();

		char sWeapon[32];

		if (Kv.JumpToKey("Weapons") && Kv.GotoFirstSubKey(false))
		{
			//PrintToServer("======= debug =======");
			do
			{
				
				if(Kv.GetSectionName(sWeapon, sizeof(sWeapon)))
				{
					if(!strcmp(sWeapon, "give"))			g_hWeapons.Push(0);	
					else if(!strcmp(sWeapon, "equip"))		g_hWeapons.Push(1);
					else if(!strcmp(sWeapon, "ignore"))		g_hWeapons.Push(2);
					else									continue;

					Kv.GetString(NULL_STRING, sWeapon, sizeof(sWeapon));
					sWeapon[0] == 'w' ? strcopy(sWeapon, sizeof(sWeapon), sWeapon[7]):strcopy(sWeapon, sizeof(sWeapon), sWeapon[5]);

					
					//PrintToServer(sWeapon);
					//PrintToServer("ID: %i", CS_AliasToWeaponID(sWeapon));
					g_hWeapons.Push(CS_AliasToWeaponID(sWeapon));//String(sWeapon);
					
				}
			}
			while (Kv.GotoNextKey(false));
		//	PrintToServer("======= debug =======");

			g_bUse = true;
			//PrintToServer(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>CUSTOM_ROUND<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
			Kv.GoBack();
			Kv.GoBack();
		}
		
		g_bBlockPick = view_as<bool>(Kv.GetNum("block_pickup", 0));
		g_bNoKnife = view_as<bool>(Kv.GetNum("no_knife", 0));
		
		g_hWeapons.Push(2);
		g_hWeapons.Push(CSWeapon_DEFUSER);
		g_hWeapons.Push(2);
		g_hWeapons.Push(CSWeapon_C4);
		if(g_bBlockPick && !g_bNoKnife)
		{
			g_hWeapons.Push(2);
			g_hWeapons.Push(CSWeapon_KNIFE);
			if(g_iEngine == Engine_CSGO)
			{
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_CUTTERS);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_T);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_BAYONET);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_FLIP);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_GUT);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_KARAMBIT);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_M9_BAYONET);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_TATICAL);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_FALCHION);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_SURVIVAL_BOWIE);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_BUTTERFLY);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_PUSH);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_URSUS);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_GYPSY_JACKKNIFE);
				g_hWeapons.Push(2);
				g_hWeapons.Push(CSWeapon_KNIFE_WIDOWMAKER);
				g_hWeapons.Push(2);
				g_hWeapons.Push(503);	// CSWeapon_KNIFE_20
			}


			//g_hWeapons.PushString("weapon_knife");
		}
		

		g_bClearKey = view_as<bool>(Kv.GetNum("no_weapon", 0));
	}
}

public void CR_OnPlayerSpawn(int iClient, KeyValues Kv)
{
	SDKUnhook(iClient, SDKHook_WeaponCanUse, OnWeaponCanUse);
	if(Kv)
	{
		if((g_bUse && g_bClear) || g_bClearKey)	ClearWeapons(iClient, 2);
		if(g_bUse)
		{
			char sBuffer[32];
			int w, iSize = g_hWeapons.Length, iTeam = GetClientTeam(iClient), iType;

			SetEntData(iClient, g_iTeam, 1, 4, false);
			for(; w < iSize; w+=2) if((iType = g_hWeapons.Get(w)) != 2)
			{
				//g_hWeapons.GetString(w+1, sBuffer, sizeof(sBuffer));
				CS_WeaponIDToAlias(g_hWeapons.Get(w+1), sBuffer, sizeof(sBuffer));
				Format(sBuffer, sizeof(sBuffer), "weapon_%s", sBuffer);
				if(!iType)
				{
					//g_hWeapons.GetString(w+1, sBuffer, sizeof(sBuffer));
					GivePlayerItem(iClient, sBuffer);
				}
				else
				{
					//g_hWeapons.GetString(w+1, sBuffer, sizeof(sBuffer));
					EquipPlayerWeapon(iClient, GivePlayerItem(iClient, sBuffer));
				}
			}
			SetEntData(iClient, g_iTeam, iTeam, 4, false);
			SDKHook(iClient, SDKHook_WeaponCanUse, OnWeaponCanUse);
		}
	}
	else if(g_bSave && g_hSave[iClient])
	{
		ClearWeapons(iClient, 3);
		char sBuffer[32];
		int iTeam = GetClientTeam(iClient);
		SetEntData(iClient, g_iTeam, 1, 4, false);
		for(int i, iLen = g_hSave[iClient].Length; i < iLen; i++)
		{
			g_hSave[iClient].GetString(i, sBuffer, sizeof(sBuffer));
			if(g_iEngine == Engine_CSGO)
			{
				if(		!strcmp(sBuffer, "fists") 	|| !strcmp(sBuffer, "axe") 
				|| 	!strcmp(sBuffer, "spanner") 	|| !strcmp(sBuffer, "hammer"))
				{
					EquipPlayerWeapon(iClient, GivePlayerItem(iClient, sBuffer));
				}
				else 
				{
					GivePlayerItem(iClient, sBuffer);
				}
			}
			else	GivePlayerItem(iClient, sBuffer);
		}
		delete g_hSave[iClient];
		SetEntData(iClient, g_iTeam, iTeam, 4, false);
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
	g_bNoKnife = false;
}

void ClearWeapons(int iClient, int iType)
{
	char sBuffer[32];
	for (int iEnt, i; i <= 3; i++)
    {
		//PrintToChat(iClient, "g_bNoKnife: %d iType %d Num %i", g_bNoKnife, iType, i);
		if(i == 2 && (iType == 3 || !g_bNoKnife)) continue;
		while ((iEnt = GetPlayerWeaponSlot(iClient, i)) != -1)
		{
			RemovePlayerItem(iClient, iEnt);
			switch(iType)
			{
				case 1:
				{
					RequestFrame(FrameDelete, iEnt);
					//AcceptEntityInput(iEnt, "Kill");
				}
				case 2:
				{
					if(g_bSave && !g_hSave[iClient])
					{
						g_hSave[iClient] = new ArrayList(ByteCountToCells(32));
						GetEdictClassname(iEnt, sBuffer, sizeof(sBuffer));
						g_hSave[iClient].PushString(sBuffer);
					}
					RequestFrame(FrameDelete, iEnt);
					//AcceptEntityInput(iEnt, "Kill");
				}
				//case 3
			}
		}
    }
}

void FrameDelete(int iEnt)
{
	if(IsValidEdict(iEnt)) RemoveEntity(iEnt);//AcceptEntityInput(iEnt, "Kill");
}

void ClearMap()
{

	int iEnt = MaxClients+1;
	while ((iEnt = FindEntityByClassname(iEnt, "weapon_*")) != INVALID_ENT_REFERENCE)
	{
		if(GetEntPropEnt(iEnt, Prop_Data, "m_hOwnerEntity") == -1)	RemoveEntity(iEnt);

		/*
		if(IsValidEdict(iEnt) && GetEntPropEnt(iEnt, Prop_Data, "m_hOwnerEntity") < 0 && GetEdictClassname(iEnt, sBuffer, sizeof(sBuffer)))
		{
			if(StrContains(sBuffer, "weapon_") == 0)	RemoveEdict(iEnt);
		}
		*/
	}
}

public Action OnWeaponCanUse(int iClient, int iWeapon) 
{
	if(g_bBlockPickUP) return Plugin_Handled;

	if(g_bBlockPick)
	{
		//static CSWeaponID iID;
		if(g_iEngine == Engine_CSGO)
		{
			//iID = CS_ItemDefIndexToID(GetEntData(iWeapon, g_iDefinitionIndex));

			//if((iID != CSWeapon_DEFUSER && iID != CSWeapon_C4) && ((!g_bNoKnife || (g_bNoKnife && (iID == CSWeapon_KNIFE_T || iID == CSWeapon_KNIFE || iID == CSWeapon_KNIFE_GG || iID > view_as<CSWeaponID>(499)))) || g_hWeapons.FindValue(iID) == -1))	return Plugin_Handled;
			if(g_hWeapons.FindValue(CS_ItemDefIndexToID(GetEntData(iWeapon, g_iDefinitionIndex))) == -1)	return Plugin_Handled;
		}
		else
		{
			static char sWeapon[32];

			GetEdictClassname(iWeapon, sWeapon, sizeof(sWeapon));
			sWeapon[0] == 'w' ? strcopy(sWeapon, sizeof(sWeapon), sWeapon[7]):strcopy(sWeapon, sizeof(sWeapon), sWeapon[5]);
			//iID = CS_AliasToWeaponID(sWeapon);

			if(g_hWeapons.FindValue(CS_AliasToWeaponID(sWeapon)) == -1)	return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}
