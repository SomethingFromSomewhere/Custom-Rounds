#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Server Commands",
	author      = 	"Someone",
	version     = 	"2.0",
	url			= 	"https://hlmod.ru/ | https://discord.gg/UfD3dSa",
};

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv)
	{
		char sBuffer[256];
		Kv.GetString("cmd", sBuffer, sizeof(sBuffer));
		if(sBuffer[0]) ServerCommand(sBuffer);
	}
}

public void CR_OnRoundEnd(KeyValues Kv)
{
	if(Kv)
	{
		char sBuffer[256];
		Kv.GetString("end_cmd", sBuffer, sizeof(sBuffer));
		if(sBuffer[0])	ServerCommand(sBuffer);
	}
}
