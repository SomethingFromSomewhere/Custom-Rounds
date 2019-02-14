void CreateNatives()
{
	CreateNative("CR_CancelNextRound", Native_CancelNextRound);
	CreateNative("CR_SetNextRound", Native_SetNextRound);
	CreateNative("CR_StopRound", Native_StopRound);
	CreateNative("CR_StartRound", Native_StartRound);
	
	CreateNative("CR_IsCustomRound", Native_IsCustomRound);
	CreateNative("CR_IsNextRoundCustom",  Native_IsNextRoundCustom);
	CreateNative("CR_IsRoundEnd", Native_IsRoundEnd);
	CreateNative("CR_IsRoundExists", Native_IsRoundExists);
	
	CreateNative("CR_GetNextRoundName",  Native_GetNextRoundName);
	CreateNative("CR_GetCurrentRoundName",  Native_GetCurrentRoundName);
	
	CreateNative("CR_GetKeyValue",  Native_GetKeyValue);
	CreateNative("CR_ReloadConfig",  Native_ReloadConfig);
	CreateNative("CR_GetArrayOfRounds",  Native_GetArrayOfRounds);
}


public int Native_CancelNextRound(Handle hPlugin, int numParams)
{
	if(!g_sNextRound[0] && !Forward_OnCancelNextRound(GetNativeCell(1)))	return false;
	
	g_sNextRound[0] = '\0';
	return true;
}

public int Native_SetNextRound(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_ROUND_NAME_LENGTH);

	Kv.Rewind();	
	if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
	{
		if(Forward_OnSetNextRound(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
		{
			g_sNextRound = sBuffer;
			return true;
		}
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	
	return false;
}

public int Native_StopRound(Handle hPlugin, int numParams)
{
	int iClient = GetNativeCell(1);
	if(!g_sCurrentRound[0] && !Forward_OnCancelCurrentRound(iClient))	return false;
	
	Forward_OnRoundEnd(iClient);	
	
	g_sCurrentRound[0] = '\0';	
	
	CS_TerminateRound(g_fRestartDelay, CSRoundEnd_GameStart, false);	// CSRoundEnd_Draw
	
	return true;
}

public int Native_StartRound(Handle hPlugin, int numParams)
{
	char sBuffer[MAX_ROUND_NAME_LENGTH];
	GetNativeString(1, sBuffer, MAX_ROUND_NAME_LENGTH);
	
	Kv.Rewind();	
	if(sBuffer[0] && Kv.JumpToKey(sBuffer, false))
	{
		if(Forward_OnForceStartRound(sBuffer, GetNativeCell(2)) && g_hArray.FindString(sBuffer) != -1)
		{
			g_sCurrentRound = sBuffer;
			CS_TerminateRound(0.0, CSRoundEnd_GameStart, false); // CSRoundEnd_Draw
			return true;
		}
	}
	else ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	
	return false;
}

public int Native_IsCustomRound(Handle hPlugin, int numParams)
{
	return g_bIsCR;
}

public int Native_IsNextRoundCustom(Handle hPlugin, int numParams)
{
	return g_sNextRound[0] != 0;
}

public int Native_IsRoundEnd(Handle hPlugin, int numParams)
{
	return g_bRoundEnd;
}

public int Native_IsRoundExists(Handle hPlugin, int numParams)
{
	char sName[MAX_ROUND_NAME_LENGTH];
	GetNativeString(1, sName, MAX_ROUND_NAME_LENGTH);
	return g_hArray.FindString(sName) != -1;
}

public int Native_GetNextRoundName(Handle hPlugin, int numParams)
{
	if(!g_sNextRound[0])	return false;
	SetNativeString(1, g_sNextRound, GetNativeCell(2), true);
	return true;
}

public int Native_GetCurrentRoundName(Handle hPlugin, int numParams)
{
	if(!g_sCurrentRound[0])	return false;
	SetNativeString(1, g_sCurrentRound, GetNativeCell(2), true);
	return true;
}

public int Native_GetKeyValue(Handle hPlugin, int numParams)
{
	return view_as<int>(Kv);
}

public int Native_GetArrayOfRounds(Handle hPlugin, int numParams)
{
	return view_as<int>(g_hArray);
}