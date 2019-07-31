#include <custom_rounds>

#pragma semicolon 1
#pragma newdecls required


public Plugin myinfo =
{
	name        = 	"[CR] Server Commands",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
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
