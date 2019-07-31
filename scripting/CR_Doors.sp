#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>
#include <smartjaildoors>

public Plugin myinfo =
{
	name        = 	"[CR] Doors",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

public void CR_OnRoundStart(KeyValues Kv)
{
	if(Kv && Kv.GetNum("open_doors", 0) && SJD_IsCurrentMapConfigured())
	{
		SJD_OpenDoors();
	}
}
