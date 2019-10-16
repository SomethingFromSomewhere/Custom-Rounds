#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required

public Plugin myinfo =
{
	name        = 	"[CR] Map Specific Rounds",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

public bool CR_OnConfigSectionLoad(const char[] sSection, KeyValues Kv)
{
	char sBuffer[32*12];
	Kv.GetString("map_only", sBuffer, sizeof(sBuffer));

	if(sBuffer[0])
	{
		char sCurrentMap[32];
		GetCurrentMap(sCurrentMap, sizeof(sCurrentMap));
		GetMapDisplayName(sCurrentMap, sCurrentMap, sizeof(sCurrentMap));
		
		if(StrContains(sBuffer, sCurrentMap) == -1)
		{
			return false;
		}
	}
	else
	{
		Kv.GetString("map_not", sBuffer, sizeof(sBuffer));
		if(sBuffer[0])
		{
			char sCurrentMap[32];
			GetCurrentMap(sCurrentMap, sizeof(sCurrentMap));
			GetMapDisplayName(sCurrentMap, sCurrentMap, sizeof(sCurrentMap));

			if(StrContains(sBuffer, sCurrentMap) == -1)
			{
				return true;
			}
		}
	}

	return true;
}
