void CreateNatives()
{
	CreateNative("CR_SetNextRound", 			Native_SetNextRound				);
	CreateNative("CR_SetNextRoundFromKeyValue", Native_SetNextRoundFromKeyValue	);
	CreateNative("CR_CancelNextRound", 			Native_CancelNextRound			);
	
	CreateNative("CR_StartRound", 				Native_StartRound				);
	CreateNative("CR_StartRoundFromKeyValue", 	Native_StartRoundFromKeyValue	);
	CreateNative("CR_StopRound", 				Native_StopRound				);
	
	CreateNative("CR_IsCustomRound", 			Native_IsCustomRound			);
	CreateNative("CR_IsNextRoundCustom",		Native_IsNextRoundCustom		);
	CreateNative("CR_IsRoundEnd",				Native_IsRoundEnd				);
	CreateNative("CR_IsRoundExists",			Native_IsRoundExists			);
	
	CreateNative("CR_GetNextRoundName",			Native_GetNextRoundName			);
	CreateNative("CR_GetCurrentRoundName",		Native_GetCurrentRoundName		);
	
	CreateNative("CR_GetKeyValue",				Native_GetKeyValue				);
	CreateNative("CR_GetCurrentRoundKeyValue",	Native_GetCurrentRoundKeyValue	);
	CreateNative("CR_GetNextRoundKeyValue",		Native_GetNextRoundKeyValue		);

	CreateNative("CR_ReloadConfig",				Native_ReloadConfig				);
	CreateNative("CR_GetArrayOfRounds",			Native_GetArrayOfRounds			);
}

/*
	bool CR_SetNextRound(const char[] sName, int iClient = 0)
*/

public int Native_SetNextRound(Handle hPlugin, int numParams)
{
	if(Function_CheckMainKeyValue())
	{
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		GetNativeString(1, sBuffer, MAX_ROUND_NAME_LENGTH);

		Kv.Rewind();	
		if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
		{
			if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
			{
				Function_CreateRoundKeyValue(sBuffer, false);
				return true;
			}
		}
		else ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	}
	return false;
}


/*
	bool CR_SetNextRoundFromKeyValue(KeyValues Kv, int iClient = 0)
*/

public int  Native_SetNextRoundFromKeyValue(Handle hPlugin, int numParams)
{
	KeyValues KvTemp = GetNativeCell(1);

	if(KvTemp)
	{
		KvTemp.Rewind();
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		KvTemp.GetSectionName(sBuffer, sizeof(sBuffer));
		if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)))
		{
			Function_CreateRoundKeyValue(_, false, KvTemp);
			return true;
		}
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[SetNextRoundFromKeyValue] Invalid KeyValue.");
	return false;
}


/*
	bool CR_CancelNextRound(int iClient = 0)
*/

public int Native_CancelNextRound(Handle hPlugin, int numParams)
{
	if(!KvNext && Forward_OnCancelNextRound(GetNativeCell(1)))	return false;
	
	delete KvNext;
	return true;
}

/*
	bool CR_StartRound(const char[] sName, int iClient = 0)
*/

public int Native_StartRound(Handle hPlugin, int numParams)
{
	if(Function_CheckMainKeyValue())
	{
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		GetNativeString(1, sBuffer, MAX_ROUND_NAME_LENGTH);
	
		Kv.Rewind();
		if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
		{
			if(Forward_OnForceStartRound(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
			{
				CS_TerminateRound(0.0, CSRoundEnd_Draw, false);
				Function_CreateRoundKeyValue(sBuffer, true);
				return true;
			}
		}
		else ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	}
	
	return false;
}


/*
	bool CR_StartRoundFromKeyValue(KeyValues Kv)
*/

public int  Native_StartRoundFromKeyValue(Handle hPlugin, int numParams)
{
	KeyValues KvTemp = GetNativeCell(1);

	if(KvTemp)
	{
		KvTemp.Rewind();
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		KvTemp.GetSectionName(sBuffer, sizeof(sBuffer));
		if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)))
		{
			Function_CreateRoundKeyValue(_, true, KvTemp);
			return true;
		}
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[StartRoundFromKeyValue] Invalid KeyValue.");
	return false;
}


/*
	bool CR_StopRound(int iClient = 0)
*/

public int Native_StopRound(Handle hPlugin, int numParams)
{
	if(!KvCurrent && Forward_OnCancelCurrentRound(GetNativeCell(1)))	return false;

	CS_TerminateRound(g_fRestartDelay, CSRoundEnd_Draw, false);	// CSRoundEnd_Draw
	
	return true;
}


/*
	bool CR_IsNextRoundCustom()
*/

public int Native_IsCustomRound(Handle hPlugin, int numParams)
{
	return KvCurrent != null;
}


/*
	bool CR_IsNextRoundCustom()
*/

public int Native_IsNextRoundCustom(Handle hPlugin, int numParams)
{
	return KvNext != null;
}


/*
	bool CR_IsRoundEnd()
*/

public int Native_IsRoundEnd(Handle hPlugin, int numParams)
{
	return g_bRoundEnd;
}


/*
	bool CR_IsRoundExists(const char[] sRound)
*/

public int Native_IsRoundExists(Handle hPlugin, int numParams)
{
	char sName[MAX_ROUND_NAME_LENGTH];
	GetNativeString(1, sName, MAX_ROUND_NAME_LENGTH);
	return g_hArray.FindString(sName) != -1;
}


/*
	bool CR_GetCurrentRoundName(char[] sName, int iMaxLenght)
*/

public int Native_GetCurrentRoundName(Handle hPlugin, int numParams)
{
	if(!KvCurrent)	return false;
	KvCurrent.Rewind();

	char sBuffer[MAX_ROUND_NAME_LENGTH];
	Function_GetRoundNameFromKeyValue(KvCurrent, sBuffer);
	SetNativeString(1, sBuffer, GetNativeCell(2), true);

	return true;
}


/*
	bool CR_GetNextRoundName(char[] sName, int iMaxLenght)
*/

public int Native_GetNextRoundName(Handle hPlugin, int numParams)
{
	if(!KvNext)	return false;
	KvNext.Rewind();

	char sBuffer[MAX_ROUND_NAME_LENGTH];
	Function_GetRoundNameFromKeyValue(KvNext, sBuffer);
	SetNativeString(1, sBuffer, GetNativeCell(2), true);

	return true;
}


/*
	KeyValues CR_GetKeyValue()
*/

public int Native_GetKeyValue(Handle hPlugin, int numParams)
{
	return view_as<int>(Kv);
}


/*
	KeyValues CR_GetCurrentRoundKeyValue()
*/

public int Native_GetCurrentRoundKeyValue(Handle hPlugin, int numParams)
{
	return view_as<int>(KvCurrent);
}


/*
	KeyValues CR_GetNextRoundKeyValue()
*/

public int Native_GetNextRoundKeyValue(Handle hPlugin, int numParams)
{
	return view_as<int>(KvNext);
}


/*
	void CR_ReloadConfig()
*/

public int Native_ReloadConfig(Handle hPlugin, int numParams)	
{	
	Function_LoadConfig();	
}

/*
	ArrayList CR_GetArrayOfRounds()
*/

public int Native_GetArrayOfRounds(Handle hPlugin, int numParams)
{
	return view_as<int>(CloneHandle(g_hArray));
}