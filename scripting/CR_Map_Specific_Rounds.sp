#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Map Specific Rounds",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

char g_sCurrentMap[32];

public bool CR_OnConfigSectionLoad(const char[] sSection)
{
	

}

public void CR_OnConfigLoad()
{
	
}

public void OnMapStart()
{
	GetCurrentMap(g_sCurrentMap, sizeof(g_sCurrentMap));
	GetMapDisplayName(g_sCurrentMap, g_sCurrentMap, sizeof(g_sCurrentMap));
	
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/custom_rounds/msr/%s
	g_sCurrentMap
}