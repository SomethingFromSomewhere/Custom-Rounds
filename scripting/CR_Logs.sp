#pragma semicolon 1
#pragma newdecls required

#include <custom_rounds>

public Plugin myinfo =
{
	name        = 	"[CR] Logs",
	author      = 	"Someone",
	version     = 	"2.0",
	url         = 	"http://hlmod.ru | https://discord.gg/UfD3dSa | https://dev-source.ru/user/61"
};

char g_sPath[PLATFORM_MAX_PATH];

public void OnPluginStart()
{
	ConVar CVAR;
	(CVAR = CreateConVar("sm_cr_logs_path", "Custom_Rounds", "Path and name to logfile.")).AddChangeHook(ChangeCvar_Path);
	CVAR.GetString(g_sPath, sizeof(g_sPath));
	if(g_sPath[0])	BuildPath(Path_SM, g_sPath, sizeof(g_sPath), "logs/%s.log", g_sPath);
}

public void ChangeCvar_Path(ConVar convar, const char[] oldValue, const char[] newValue)
{
	convar.GetString(g_sPath, sizeof(g_sPath));
	if(g_sPath[0])	BuildPath(Path_SM, g_sPath, sizeof(g_sPath), "logs/*.log", g_sPath);
}

public void CR_OnConfigLoad()
{
	if(g_sPath[0]) LogToFile(g_sPath, "Настройки загружены.");
	else LogAction(-1, -1, "Настройки загружены.");	
}

public void CR_OnSetNextRoundPost(int iClient, const char[] sName)
{
	if(g_sPath[0]) LogToFile(g_sPath, "\"%N\" сделал %s следующим раундом.", iClient, sName);
	else LogAction(iClient, -1, "\"%L\" сделал %s следующим раундом.", iClient, sName);
}

public void CR_OnForceRoundStartPost(int iClient, const char[] sName)
{
	if(g_sPath[0]) LogToFile(g_sPath, "\"%N\" запустил раунд %s.", iClient, sName);
	else LogAction(iClient, -1, "\"%L\" запустил раунд %s.", iClient, sName);
}

public void CR_OnCancelCurrentRoundPost(int iClient, const char[] sName)
{
	if(g_sPath[0]) LogToFile(g_sPath, "\"%N\" отменил раунд %s.", iClient, sName);
	else LogAction(iClient, -1, "\"%L\"отменил раунд %s.", iClient, sName);
}

public void CR_OnCancelNextRoundPost(int iClient, const char[] sName)
{
	if(g_sPath[0]) LogToFile(g_sPath, "\"%N\" отменил следующий раунд %s.", iClient, sName);
	else LogAction(iClient, -1, "\"%L\"отменил следующий раунд %s.", iClient, sName);
}