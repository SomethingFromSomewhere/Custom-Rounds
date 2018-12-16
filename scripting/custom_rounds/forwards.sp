static Handle g_hForward_OnSetNextRound, g_hForward_OnStartCurrentRound, g_hForward_OnRoundEnd, g_hForward_OnStartRound, g_hForward_OnConfigLoad, g_hForward_OnConfigSectionLoad, g_hForward_OnCancelNextRound, g_hForward_OnPlayerSpawn, g_hForward_OnChatCommand;

void CreateForwards()
{
	g_hForward_OnSetNextRound = CreateGlobalForward("CR_OnSetNextRound", ET_Ignore, Param_String, Param_Cell);
	g_hForward_OnStartCurrentRound = CreateGlobalForward("CR_OnStartCurrentRound", ET_Ignore, Param_String, Param_Cell);
	g_hForward_OnCancelNextRound = CreateGlobalForward("CR_OnCancelNextRound", ET_Ignore, Param_Cell);
	g_hForward_OnRoundEnd = CreateGlobalForward("CR_OnRoundEnd", ET_Ignore, Param_String, Param_Cell);
	g_hForward_OnStartRound = CreateGlobalForward("CR_OnStartRound", ET_Ignore, Param_String, Param_Cell);
	g_hForward_OnConfigLoad = CreateGlobalForward("CR_OnConfigLoad", ET_Ignore);
	g_hForward_OnConfigSectionLoad = CreateGlobalForward("CR_OnConfigSectionLoad", ET_Ignore, Param_String);
	g_hForward_OnPlayerSpawn = CreateGlobalForward("CR_OnPlayerSpawn", ET_Ignore, Param_Cell, Param_Cell);
	g_hForward_OnChatCommand = CreateGlobalForward("CR_OnChatCommand", ET_Ignore, Param_Cell);
}

void Forward_OnPlayerSpawn(int iClient, HOOK_TYPE Type)
{
	Call_StartForward(g_hForward_OnPlayerSpawn);
	Call_PushCell(iClient);
	Call_PushCell(Type);
	Call_Finish();
}

void Forward_OnChatCommand(int iClient)
{
	Call_StartForward(g_hForward_OnChatCommand);
	Call_PushCell(iClient);
	Call_Finish();
}

void Forward_OnSetNextRound(const char[] sName, int iClient)
{
	Call_StartForward(g_hForward_OnSetNextRound);
	Call_PushString(sName);
	Call_PushCell(iClient);
	Call_Finish();
}

void Forward_OnStartCurrentRound(const char[] sName, int iClient)
{
	Call_StartForward(g_hForward_OnStartCurrentRound);
	Call_PushString(sName);
	Call_PushCell(iClient);
	Call_Finish();
}

void Forward_OnCancelNextRound(int iClient)
{
	Call_StartForward(g_hForward_OnCancelNextRound);
	Call_PushCell(iClient);
	Call_Finish();
}

void Forward_OnRoundEnd(const char[] sName, int iClient = 0)
{
	Call_StartForward(g_hForward_OnRoundEnd);
	Call_PushString(sName);
	Call_PushCell(iClient);
	Call_Finish();
}

void Forward_OnStartRound(const char[] sName, HOOK_TYPE Type)
{
	Call_StartForward(g_hForward_OnStartRound);
	Call_PushString(sName);
	Call_PushCell(Type);
	Call_Finish();
}

void Forward_OnConfigLoad()
{
	Call_StartForward(g_hForward_OnConfigLoad);
	Call_Finish();
}

void Forward_OnConfigSectionLoad(const char[] sSection)
{
	Call_StartForward(g_hForward_OnConfigSectionLoad);
	Call_PushString(sSection);
	Call_Finish();
}