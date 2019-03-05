//#include <cstrike_weapons>
#include <custom_rounds>
#include <restrict>

#pragma semicolon 1
#pragma newdecls required

public Action Restrict_OnCanPickupWeapon(int iClient, int iTeam, int iID, bool &bBlock)
{
	if(CR_IsCustomRound())
	{
		bBlock = false;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}	