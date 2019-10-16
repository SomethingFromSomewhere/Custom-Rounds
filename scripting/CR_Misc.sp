#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Misc",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

bool g_bSave, g_bHasHelmet[MAXPLAYERS+1], g_bHasHeavy[MAXPLAYERS+1], g_bSaveArmor[MAXPLAYERS+1], g_bAllowSave, g_bUseGravity[MAXPLAYERS+1];
int g_iSaveArmor[MAXPLAYERS+1], g_iInvisible, g_iHP, g_iArmor, m_ArmorValue = -1, m_bHasHelmet = -1, m_bHasHeavyArmor = -1, g_iHelmet, g_iHeavy;
float g_fGravity, g_fSpeed;

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_misc_save_armor", "1", "Save armor.", _, true, 0.0, true, 1.0)).AddChangeHook(ChangeCvar_Save);
	g_bSave = CVAR.BoolValue;
	
	m_ArmorValue		= FindSendPropInfo(	"CCSPlayer", "m_ArmorValue");
	m_bHasHelmet		= FindSendPropInfo(	"CCSPlayer", "m_bHasHelmet");
	m_bHasHeavyArmor	= FindSendPropInfo(	"CCSPlayer", "m_bHasHeavyArmor");

	AutoExecConfig(true, "cr_misc", "sourcemod/custom_rounds");
}

public void ChangeCvar_Save(ConVar convar, const char[] oldValue, const char[] newValue)
{
	g_bSave = convar.BoolValue;
}

public void OnClientPutInServer(int iClient)
{
	g_bUseGravity[iClient] =
	g_bSaveArmor[iClient] = false;
}

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		g_fGravity = Kv.GetFloat("gravity", 1.0), g_fSpeed = Kv.GetFloat("speed", 1.0);
		g_iInvisible = Kv.GetNum("invisibility", -1), g_iHP = Kv.GetNum("hp", 0), g_iArmor = Kv.GetNum("armor", -1);
		g_iHelmet = Kv.GetNum("helmet", -1);
		g_iHeavy  = Kv.GetNum("heavy_armor", -1);
		g_bAllowSave = false;
	}
	else
	{
		if(g_bSave)
		{
			for(int i = 1; i <= MaxClients; ++i)	if(IsClientInGame(i) && IsPlayerAlive(i) && g_bSaveArmor[i])
			{
				SetEntData(i, m_ArmorValue, 	g_iSaveArmor[i]);
				SetEntData(i, m_bHasHelmet, 	g_bHasHelmet[i] ? 1:0);
				SetEntData(i, m_bHasHeavyArmor, g_bHasHeavy[i] ? 1:0);
				g_bSaveArmor[i] = false;
			}
		}
		g_bAllowSave = true;
	}
}

public void CR_OnPlayerSpawn(int iClient, KeyValues Kv)
{
	if(Kv)
	{
		if(g_fGravity != 1.0)		SetEntityGravity(iClient, g_fGravity);	g_bUseGravity[iClient] = true;
		if(g_fSpeed != 1.0)			SetEntPropFloat(iClient, Prop_Data, "m_flLaggedMovementValue", g_fSpeed);
		if(g_iInvisible > -1)		SetEntityRenderMode(iClient, RENDER_TRANSCOLOR);	SetEntityRenderColor(iClient, 255, 255, 255, g_iInvisible);
		if(g_iHP > 0)				SetEntityHealth(iClient, g_iHP);
		if(g_iArmor > -1 || g_iHelmet > -1 || g_iHeavy > -1)
		{
			if(g_bSave && g_bAllowSave && !g_bSaveArmor[iClient])
			{
				g_iSaveArmor[iClient]	= GetClientArmor(iClient);	
				g_bHasHelmet[iClient]	= view_as<bool>(GetEntData(iClient, m_bHasHelmet)); 
				g_bHasHeavy[iClient]	= view_as<bool>(GetEntData(iClient, m_bHasHeavyArmor));
				g_bSaveArmor[iClient]	= true;
			}
		}

		if(g_iArmor > -1) 	SetEntData(iClient, m_ArmorValue,		g_iArmor);
		if(g_iHelmet != -1) SetEntData(iClient, m_bHasHelmet,		g_iHelmet);
		if(g_iHeavy != -1)	SetEntData(iClient,	m_bHasHeavyArmor,	g_iHeavy);
	}
	else if(g_bSaveArmor[iClient])
	{
		SetEntData(iClient, m_ArmorValue,		g_iSaveArmor[iClient]);
		SetEntData(iClient, m_bHasHelmet, 		(g_bHasHelmet[iClient]) ? 1:0);
		SetEntData(iClient, m_bHasHeavyArmor,	(g_bHasHelmet[iClient]) ? 1:0);
		g_bSaveArmor[iClient] = false;
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(!CR_IsNextRoundCustom())
	{
		g_bAllowSave = true;
	}
	
	for(int i = 1; i <= MaxClients; ++i)	if(g_bUseGravity[i])
	{
		if(IsClientInGame(i))	SetEntityGravity(i, 1.0);
		g_bUseGravity[i] = false;
	}
	
	g_fGravity = 1.0;
	g_fSpeed = 1.0;
	g_iInvisible = -1;
	g_iHP = 0;
	g_iArmor = -1;
}