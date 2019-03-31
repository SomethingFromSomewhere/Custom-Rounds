void CreateForwards()
{
	g_hForward_OnPluginStart 				=		CreateGlobalForward(		"CR_OnPluginStart",				ET_Ignore											);
	
	g_hForward_OnConfigLoad 				=		CreateGlobalForward(		"CR_OnConfigLoad", 				ET_Ignore											);
	g_hForward_OnConfigLoaded 				=		CreateGlobalForward(		"CR_OnConfigLoaded", 			ET_Ignore											);
	g_hForward_OnConfigSectionLoad 			=		CreateGlobalForward(		"CR_OnConfigSectionLoad",		ET_Single, 		Param_String						);
	g_hForward_OnConfigSectionLoadPost		=		CreateGlobalForward(		"CR_OnConfigSectionLoadPost",	ET_Ignore, 		Param_String						);
	
	g_hForward_OnForceRoundStart 			=		CreateGlobalForward(		"CR_OnForceRoundStart",			ET_Event, 		Param_Cell, 		Param_String	);
	g_hForward_OnForceRoundStartPost		=		CreateGlobalForward(		"CR_OnForceRoundStartPost",		ET_Ignore, 		Param_Cell, 		Param_String	);
	
	g_hForward_OnSetNextRound 				=		CreateGlobalForward(		"CR_OnSetNextRound",			ET_Event, 		Param_Cell, 		Param_String	);
	g_hForward_OnSetNextRoundPost			=		CreateGlobalForward(		"CR_OnSetNextRoundPost",		ET_Ignore, 		Param_Cell, 		Param_String	);
	
	g_hForward_OnCancelCurrentRound 		=		CreateGlobalForward(		"CR_OnCancelCurrentRound",		ET_Single, 		Param_Cell, 		Param_String	);
	g_hForward_OnCancelCurrentRoundPost		=		CreateGlobalForward(		"CR_OnCancelCurrentRoundPost",	ET_Ignore, 		Param_Cell,			Param_String	);

	g_hForward_OnCancelNextRound 			=		CreateGlobalForward(		"CR_OnCancelNextRound",			ET_Single, 		Param_Cell, 		Param_String	);
	g_hForward_OnCancelNextRoundPost		=		CreateGlobalForward(		"CR_OnCancelNextRoundPost",		ET_Ignore, 		Param_Cell, 		Param_String	);
	
	g_hForward_OnPlayerSpawn 				=		CreateGlobalForward(		"CR_OnPlayerSpawn",				ET_Ignore, 		Param_Cell,			Param_Cell		);
	g_hForward_OnRoundStart 				=		CreateGlobalForward(		"CR_OnRoundStart", 				ET_Ignore, 		Param_Cell							);
	g_hForward_OnRoundEnd 					=		CreateGlobalForward(		"CR_OnRoundEnd",				ET_Ignore, 		Param_Cell							);
}

/*
	void CR_OnPluginStart()
*/

void Forward_PluginStarted()
{
	Call_StartForward(g_hForward_OnPluginStart);
	
	Call_Finish();
}


/*
	void CR_OnConfigLoad()
*/

void Forward_OnConfigLoad()
{
	Call_StartForward(g_hForward_OnConfigLoad);
	
	Call_Finish();
}


/*
	void CR_OnConfigLoaded()
*/

void Forward_OnConfigLoaded()
{
	Call_StartForward(g_hForward_OnConfigLoaded);
	
	Call_Finish();
}


/*
	bool CR_OnConfigSectionLoad(const char[] sName)
*/

bool Forward_OnConfigSectionLoad(const char[] sSection)
{
	Call_StartForward(g_hForward_OnConfigSectionLoad);

	Call_PushString(sSection);
	
	bool bAllow = true;
	Call_Finish(bAllow);
	return bAllow;
}


/*
	void CR_OnConfigSectionLoadPost(const char[] sName)
*/

void Forward_OnConfigSectionLoadPost(const char[] sSection)
{
	Call_StartForward(g_hForward_OnConfigSectionLoadPost);
	
	Call_PushString(sSection);
	
	Call_Finish();
}


/*
	Action 	CR_OnForceRoundStart(int iClient, char[] sName)
	void 	CR_OnForceRoundStartPost(int iClient, const char[] sName)
*/

bool Forward_OnForceRoundStart(char sName[MAX_ROUND_NAME_LENGTH], int iClient)
{
	Call_StartForward(g_hForward_OnForceRoundStart);
	
	char sNameCopy[MAX_ROUND_NAME_LENGTH];
	sNameCopy = sName;
	Call_PushCell(iClient);
	Call_PushStringEx(sNameCopy, MAX_ROUND_NAME_LENGTH, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	
	Action aAction = Plugin_Continue;
	Call_Finish(aAction);

	if(aAction > Plugin_Changed)		return false;
	else if(aAction == Plugin_Changed)	sName = sNameCopy;

	Call_StartForward(g_hForward_OnForceRoundStartPost);
	
	Call_PushCell(iClient);
	Call_PushString(sName);
	
	Call_Finish();

	return true;
}


/*
	Action 	CR_OnSetNextRound(int iClient, char[] sName)
	void 	CR_OnSetNextRoundPost(int iClient, const char[] sName)
*/

bool Forward_OnSetNextRound(char sName[MAX_ROUND_NAME_LENGTH], int iClient)
{
	Call_StartForward(g_hForward_OnSetNextRound);
	
	char sNameCopy[MAX_ROUND_NAME_LENGTH];
	sNameCopy = sName;
	Call_PushCell(iClient);
	Call_PushStringEx(sNameCopy, MAX_ROUND_NAME_LENGTH, SM_PARAM_STRING_UTF8|SM_PARAM_STRING_COPY, SM_PARAM_COPYBACK);
	
	Action aAction = Plugin_Continue;
	Call_Finish(aAction);
	
	if(aAction > Plugin_Changed)		return false;
	else if(aAction == Plugin_Changed)	sName = sNameCopy;

	Call_StartForward(g_hForward_OnSetNextRoundPost);
	
	Call_PushCell(iClient);
	Call_PushString(sName);
	
	Call_Finish();

	return true;
}


/*
	bool 	CR_OnCancelCurrentRound(int iClient, char[] sName)
	void 	CR_OnCancelCurrentRoundPost(int iClient, const char[] sName)
*/

bool Forward_OnCancelCurrentRound(int iClient)
{
	Call_StartForward(g_hForward_OnCancelCurrentRound);

	Call_PushCell(iClient);
	
	char sName[MAX_ROUND_NAME_LENGTH];
	Function_GetRoundNameFromKeyValue(KvCurrent, sName);
	Call_PushString(sName);

	bool bValue;
	Call_Finish(bValue);
	
	if(bValue)
	{
		Call_StartForward(g_hForward_OnCancelCurrentRoundPost);
		
		Call_PushCell(iClient);
		Call_PushString(sName);
		
		Call_Finish();
	}

	return bValue;
}


/*
	bool 	CR_OnCancelNextRound(int iClient, char[] sName)
	void 	CR_OnCancelNextRoundPost(int iClient, const char[] sName)
*/

bool Forward_OnCancelNextRound(int iClient)
{
	Call_StartForward(g_hForward_OnCancelNextRound);
	
	Call_PushCell(iClient);
	
	char sName[MAX_ROUND_NAME_LENGTH];
	Function_GetRoundNameFromKeyValue(KvNext, sName);
	Call_PushString(sName);

	bool bValue;
	Call_Finish(bValue);

	if(bValue)
	{
		Call_StartForward(g_hForward_OnCancelNextRoundPost);
		
		Call_PushCell(iClient);
		Call_PushString(sName);
		
		Call_Finish();
	}

	return bValue;
}


/*
	void 	CR_OnPlayerSpawn(int iClient, KeyValues Kv)
*/

void Forward_OnPlayerSpawn(int iClient)
{
	Call_StartForward(g_hForward_OnPlayerSpawn);
	
	Call_PushCell(iClient);
	Call_PushCell(KvCurrent);
	
	Call_Finish();
}


/*
	void 	CR_OnRoundStart(KeyValues Kv)
*/

void Forward_OnRoundStart()
{
	Call_StartForward(g_hForward_OnRoundStart);
	
	Call_PushCell(KvCurrent);
	
	Call_Finish();
}


/*
	void 	CR_OnRoundEnd(KeyValues Kv)
*/

void Forward_OnRoundEnd()
{
	Call_StartForward(g_hForward_OnRoundEnd);
	
	Call_PushCell(KvCurrent);
	
	Call_Finish();
}