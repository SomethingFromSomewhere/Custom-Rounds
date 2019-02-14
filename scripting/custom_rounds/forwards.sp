void CreateForwards()
{
	g_hForward_OnForceStartRound 												=		CreateGlobalForward(		"CR_OnForceStartRound",			ET_Event, 		Param_String,		Param_Cell);
	g_hForward_OnConfigSectionLoad 											=		CreateGlobalForward(		"CR_OnConfigSectionLoad",		ET_Ignore, 		Param_String);
	g_hForward_OnCancelCurrentRound 									=		CreateGlobalForward(		"CR_OnCancelCurrentRound",		ET_Single, 		Param_Cell);
	g_hForward_OnCancelNextRound 									=		CreateGlobalForward(		"CR_OnCancelNextRound",			ET_Single, 		Param_Cell);
	g_hForward_OnSetNextRound 									=		CreateGlobalForward(		"CR_OnSetNextRound",			ET_Event, 		Param_String,		Param_Cell);
	g_hForward_OnPlayerSpawn 								=		CreateGlobalForward(		"CR_OnPlayerSpawn",				ET_Ignore, 		Param_Cell,		Param_Cell);
	g_hForward_PluginStarted 							=		CreateGlobalForward(		"CR_PluginStarted",				ET_Ignore);
	g_hForward_OnRoundStart 						=		CreateGlobalForward(		"CR_OnRoundStart", 				ET_Ignore, 		Param_String,		Param_Cell);
	g_hForward_OnConfigLoad 					=		CreateGlobalForward(		"CR_OnConfigLoad", 				ET_Ignore);
	g_hForward_OnRoundEnd 					=		CreateGlobalForward(		"CR_OnRoundEnd",				ET_Ignore, 		Param_String,		Param_Cell);
}

bool Forward_OnForceStartRound(char sName[MAX_ROUND_NAME_LENGTH], int iClient)
{
	Call_StartForward(g_hForward_OnForceStartRound);
	
	char sNameCopy[MAX_ROUND_NAME_LENGTH];
	sNameCopy = sName;
	Call_PushStringEx(sNameCopy, MAX_ROUND_NAME_LENGTH, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(iClient);
	
	Action aAction = Plugin_Continue;
	Call_Finish(aAction);

	if(aAction == Plugin_Continue)	return true;
	else if(aAction == Plugin_Changed)
	{
		sName = sNameCopy;
		return true;
	}	
	return false;
}

void Forward_OnConfigSectionLoad(const char[] sSection)
{
	Call_StartForward(g_hForward_OnConfigSectionLoad);
	
	Call_PushString(sSection);
	
	Call_Finish();
}

bool Forward_OnCancelCurrentRound(int iClient)
{
	Call_StartForward(g_hForward_OnCancelCurrentRound);

	Call_PushCell(iClient);

	bool bValue;
	Call_Finish(bValue);

	return bValue;
}

bool Forward_OnCancelNextRound(int iClient)
{
	Call_StartForward(g_hForward_OnCancelNextRound);
	
	Call_PushCell(iClient);

	bool bValue;
	Call_Finish(bValue);

	return bValue;
}

bool Forward_OnSetNextRound(char sName[MAX_ROUND_NAME_LENGTH], int iClient)
{
	Call_StartForward(g_hForward_OnSetNextRound);
	
	char sNameCopy[MAX_ROUND_NAME_LENGTH];
	sNameCopy = sName;
	Call_PushStringEx(sNameCopy, MAX_ROUND_NAME_LENGTH, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	Call_PushCell(iClient);
	
	Action aAction = Plugin_Continue;
	Call_Finish(aAction);
	
	if(aAction == Plugin_Continue)	return true;
	else if(aAction == Plugin_Changed)
	{
		sName = sNameCopy;
		return true;
	}	
	return false;
}

void Forward_OnPlayerSpawn(int iClient)
{
	Call_StartForward(g_hForward_OnPlayerSpawn);
	
	Call_PushCell(iClient);
	Call_PushCell(view_as<bool>(g_sCurrentRound[0]));
	
	Call_Finish();
}

void Forward_PluginStarted()
{
	Call_StartForward(g_hForward_PluginStarted);
	
	Call_Finish();
}

void Forward_OnRoundStart(const char[] sName)
{
	Call_StartForward(g_hForward_OnRoundStart);
	
	Call_PushString(sName);
	Call_PushCell(Kv);
	
	Call_Finish();
}

void Forward_OnConfigLoad()
{
	Call_StartForward(g_hForward_OnConfigLoad);
	
	Call_Finish();
}

void Forward_OnRoundEnd(int iClient = 0)
{
	Call_StartForward(g_hForward_OnRoundEnd);
	
	Call_PushString(g_sCurrentRound);
	Call_PushCell(Kv);
	Call_PushCell(iClient);
	
	Call_Finish();
}