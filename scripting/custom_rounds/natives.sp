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
	CreateNative("CR_GetRoundNumber",			Native_GetRoundNumber			);
}

/*
	bool CR_SetNextRound(const char[] sName, int iClient = 0)
*/

public int Native_SetNextRound(Handle hPlugin, int iLen)
{
	CR_Debug("[Natives] Native 'SetNextRound' start call.");
	if(Function_CheckMainKeyValue())
	{
		GetNativeStringLength(1, iLen);
		char[] sBuffer = new char[++iLen];
		GetNativeString(1, sBuffer, iLen);

		Kv.Rewind();	
		if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
		{
			if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
			{
				Function_CreateRoundKeyValue(sBuffer, false);
				CR_Debug("[Natives] Native 'SetNextRound' end call. Name: %s. State: true.", sBuffer);
				return true;
			}
			CR_Debug("[Natives] Native 'SetNextRound' end call. Name: %s. State: false.", sBuffer);
		}
		else ThrowNativeError(SP_ERROR_NATIVE, "[SetNextRound] Round name \"%s\" is invalid.", sBuffer);
	}
	return false;
}


/*
	bool CR_SetNextRoundFromKeyValue(KeyValues Kv, int iClient = 0)
*/

public int  Native_SetNextRoundFromKeyValue(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'SetNextRoundFromKeyValue' start call.");
	KeyValues KvTemp = GetNativeCell(1);

	if(KvTemp)
	{
		KvTemp.Rewind();
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		KvTemp.GetSectionName(sBuffer, sizeof(sBuffer));
		if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)))
		{
			Function_CreateRoundKeyValue(_, false, KvTemp);
			CR_Debug("[Natives] Native 'SetNextRoundFromKeyValue' end call. Name: %s. State: true.");
			return true;
		}
		CR_Debug("[Natives] Native 'SetNextRoundFromKeyValue' end call. Name: %s. State: false.");
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[SetNextRoundFromKeyValue] Invalid KeyValue.");
	return false;
}


/*
	bool CR_CancelNextRound(int iClient = 0)
*/

public int Native_CancelNextRound(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'CancelNextRound' start call.");
	if(!KvNext && Forward_OnCancelNextRound(GetNativeCell(1)))	return false;

	delete KvNext;

	CR_Debug("[Natives] Native 'CancelNextRound' end call.");
	return true;
}


/*
	bool CR_StartRound(const char[] sName, int iClient = 0)
*/

public int Native_StartRound(Handle hPlugin, int iLen)
{
	CR_Debug("[Natives] Native 'StartRound' start call.");
	if(Function_CheckMainKeyValue())
	{
		GetNativeStringLength(1, iLen);
		char[] sBuffer = new char[++iLen];
		GetNativeString(1, sBuffer, iLen);
	
		Kv.Rewind();
		if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
		{
			if(Forward_OnForceRoundStart(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
			{
				CS_TerminateRound(0.0, CSRoundEnd_Draw, true);
				Function_CreateRoundKeyValue(sBuffer, true);
				CR_Debug("[Natives] Native 'StartRound' end call. Name: %s. State: true.");
				return true;
			}
			CR_Debug("[Natives] Native 'StartRound' end call. Name: %s. State: false.");
		}
		else ThrowNativeError(SP_ERROR_NATIVE, "[StartRound] Round name \"%s\" is invalid.", sBuffer);
	}
	
	return false;
}


/*
	bool CR_StartRoundFromKeyValue(KeyValues Kv)
*/

public int  Native_StartRoundFromKeyValue(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'StartRoundFromKeyValue' start call.");
	KeyValues KvTemp = GetNativeCell(1);

	if(KvTemp)
	{
		KvTemp.Rewind();
		char sBuffer[MAX_ROUND_NAME_LENGTH];
		KvTemp.GetSectionName(sBuffer, sizeof(sBuffer));
		if(Forward_OnForceRoundStart(sBuffer, GetNativeCell(2)))
		{
			Function_CreateRoundKeyValue(_, true, KvTemp);
			CR_Debug("[Natives] Native 'StartRoundFromKeyValue' end call. Name: %s. State: true");
			return true;
		}
		CR_Debug("[Natives] Native 'StartRoundFromKeyValue' end call. Name: %s. State: false");
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "[StartRoundFromKeyValue] Invalid KeyValue.");
	return false;
}


/*
	bool CR_StopRound(int iClient = 0)
*/

public int Native_StopRound(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'StopRound' start call.");
	if(!KvCurrent && Forward_OnCancelCurrentRound(GetNativeCell(1)))	return false;

	CS_TerminateRound(g_fRestartDelay, CSRoundEnd_Draw, false);
	CR_Debug("[Natives] Native 'StopRound' end call.");
	
	return true;
}


/*
	bool CR_IsNextRoundCustom()
*/

public int Native_IsCustomRound(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'IsNextRoundCustom' called. Result: %s.", KvCurrent != null ? "true":"false");
	return KvCurrent != null;
}


/*
	bool CR_IsNextRoundCustom()
*/

public int Native_IsNextRoundCustom(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'IsNextRoundCustom' called. Result: %s.", KvNext != null ? "true":"false");
	return KvNext != null;
}


/*
	bool CR_IsRoundEnd()
*/

public int Native_IsRoundEnd(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'IsRoundEnd' called. Result: %s.", g_bRoundEnd ? "true":"false");
	return g_bRoundEnd;
}


/*
	bool CR_IsRoundExists(const char[] sRound)
*/

public int Native_IsRoundExists(Handle hPlugin, int iLen)
{
	GetNativeStringLength(1, iLen);
	char[] sName = new char[++iLen];
	GetNativeString(1, sName, iLen);

	CR_Debug("[Natives] Native 'IsRoundExists' called. Result: %s.", g_hArray.FindString(sName) != -1 ? "true":"false");

	return g_hArray.FindString(sName) != -1;
}


/*
	bool CR_GetCurrentRoundName(char[] sName, int iMaxLenght)
*/

public int Native_GetCurrentRoundName(Handle hPlugin, int iLen)
{
	CR_Debug("[Natives] Native 'GetCurrentRoundName' start call.");
	if(!KvCurrent)	return false;
	KvCurrent.Rewind();

	iLen = GetNativeCell(2);
	char[] sName = new char[iLen];

	Function_GetRoundNameFromKeyValue(KvCurrent, sName, iLen);
	SetNativeString(1, sName, iLen, true);

	CR_Debug("[Natives] Native 'GetCurrentRoundName' end call. Name: %s. Len: %i.", sName, iLen);

	return true;
}


/*
	bool CR_GetNextRoundName(char[] sName, int iMaxLenght)
*/

public int Native_GetNextRoundName(Handle hPlugin, int iLen)
{
	CR_Debug("[Natives] Native 'GetNextRoundName' start call.");
	if(!KvNext)	return false;
	KvNext.Rewind();

	iLen = GetNativeCell(2);
	char[] sName = new char[iLen];

	Function_GetRoundNameFromKeyValue(KvNext, sName, iLen);
	SetNativeString(1, sName, iLen, true);

	CR_Debug("[Natives] Native 'GetNextRoundName' end call. Name: %s. Len: %i.", sName, iLen);

	return true;
}


/*
	KeyValues CR_GetKeyValue()
*/

public int Native_GetKeyValue(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'GetKeyValue' called.");
	return view_as<int>(Kv);
}


/*
	KeyValues CR_GetCurrentRoundKeyValue()
*/

public int Native_GetCurrentRoundKeyValue(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'GetCurrentRoundKeyValue' called.");
	return view_as<int>(KvCurrent);
}


/*
	KeyValues CR_GetNextRoundKeyValue()
*/

public int Native_GetNextRoundKeyValue(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'GetNextRoundKeyValue' called.");
	return view_as<int>(KvNext);
}


/*
	void CR_ReloadConfig()
*/

public int Native_ReloadConfig(Handle hPlugin, int numParams)	
{
	CR_Debug("[Natives] Native 'ReloadConfig' called.");
	Function_LoadConfig();	
}


/*
	ArrayList CR_GetArrayOfRounds()
*/

public int Native_GetArrayOfRounds(Handle hPlugin, int numParams)
{
	CR_Debug("[Natives] Native 'GetArrayOfRounds' called.");

	return !GetNativeCell(1) ? view_as<int>(g_hArray):view_as<int>(CloneHandle(g_hArray, hPlugin));
}


/*
	int CR_GetRoundNumber(const char[] sName)
*/

public int Native_GetRoundNumber(Handle hPlugin, int iLen)
{
	GetNativeStringLength(1, iLen);
	char[] sName = new char[++iLen];
	GetNativeString(1, sName, iLen);

	CR_Debug("[Natives] Native 'GetRoundNumber' called. Round: %s. Value: %i.", sName, g_hArray.FindString(sName));

	return g_hArray.FindString(sName);
}