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

ArrayList g_hArray;

public bool CR_OnConfigSectionLoad(const char[] sSection, KeyValues Kv)
{
	if(g_hArray && g_hArray.FindString(sSection) == -1)
	{
		return false;
	}

	return true;
}

public void CR_OnConfigLoad()
{
	g_hArray = new ArrayList(ByteCountToCells(MAX_ROUND_NAME_LENGTH));
	char sCurrentMap[PLATFORM_MAX_PATH];
	GetCurrentMap(sCurrentMap, sizeof(sCurrentMap));
	GetMapDisplayName(sCurrentMap, sCurrentMap, sizeof(sCurrentMap));
	
	BuildPath(Path_SM, sCurrentMap, sizeof(sCurrentMap), "configs/custom_rounds/maps/%s", sCurrentMap);

	File hFile = OpenFile(sCurrentMap, "r");

	if(hFile)
	{
		while (hFile.EndOfFile())
		{
			hFile.ReadLine(sCurrentMap, sizeof(sCurrentMap));
			g_hArray.PushString(sCurrentMap);
		}
		delete hFile;
	}
}

public void CR_OnConfigLoaded()
{
	delete g_hArray;
}