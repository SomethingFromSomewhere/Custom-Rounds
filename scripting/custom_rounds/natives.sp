void CreateNatives()
{
	CreateNative("CR_CancelNextRound", Native_CancelNextRound);
	CreateNative("CR_SetNextRound", Native_SetNextRound);
	CreateNative("CR_StopRound", Native_StopRound);
	CreateNative("CR_StartRound", Native_StartRound);
	CreateNative("CR_IsCustomRound", Native_IsCustomRound);
	CreateNative("CR_IsNextRoundCustom",  Native_IsNextRoundCustom);
	CreateNative("CR_IsRoundEnd", Native_IsRoundEnd);
	CreateNative("CR_GetNextRoundName",  Native_GetNextRoundName);
	CreateNative("CR_GetCurrentRoundName",  Native_GetCurrentRoundName);
	CreateNative("CR_GetKeyValue",  Native_GetKeyValue);
	CreateNative("CR_ReloadConfig",  Native_ReloadConfig);
}

public int Native_IsCustomRound(Handle hPlugin, int numParams)
{
	return g_bIsCR;
}

public int Native_IsNextRoundCustom(Handle hPlugin, int numParams)
{
	return g_bNextCR;
}

public int Native_IsRoundEnd(Handle hPlugin, int numParams)
{
	return g_bRoundEnd;
}

public int Native_CancelNextRound(Handle hPlugin, int numParams)
{
	if(!g_bNextCR)	return false;
	g_bNextCR = false;
	g_sNextRound[0] = '\0';
	Forward_OnCancelNextRound(GetNativeCell(1));
	return true;
}

public int Native_SetNextRound(Handle hPlugin, int numParams)
{
	char sBuffer[256];
	GetNativeString(1, sBuffer, sizeof(sBuffer));
	if(g_iInterval != 0 && view_as<bool>(GetNativeCell(3)) && g_bInverval && !(g_iInterval < g_iRounds+1))	return false;
	if(!SetNextRound(sBuffer, GetNativeCell(2)))	ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	return true;
}

static bool SetNextRound(const char[] sName, int iClient = 0)
{
	Kv.Rewind();	
	if(sName[0] && Kv.JumpToKey(sName, false))
	{
		FormatEx(g_sNextRound, sizeof(g_sNextRound), "%s", sName);
		Forward_OnSetNextRound(sName, iClient);
		g_bNextCR = true;

		return true;
	}
	return false;
}

public int Native_StopRound(Handle hPlugin, int numParams)
{
	if(!g_bIsCR)	return false;
	Forward_OnRoundEnd(g_sCurrentRound, GetNativeCell(1));	
	g_sCurrentRound[0] = '\0';	
	g_bIsCR = false;
	CS_TerminateRound(g_fRestartDelay, CSRoundEnd_Draw, true);	
	return true;
}

public int Native_StartRound(Handle hPlugin, int numParams)
{
	char sBuffer[256];
	GetNativeString(1, sBuffer, sizeof(sBuffer));
	if(g_iInterval != 0 && view_as<bool>(GetNativeCell(3)) && g_bInverval)	return false;
	if (!ForceStart(sBuffer))	ThrowNativeError(SP_ERROR_NATIVE, "Round name \"%s\" is invalid.", sBuffer);
	Forward_OnStartCurrentRound(sBuffer, GetNativeCell(2));
	return true;
}

static bool ForceStart(const char[] sName)
{
	Kv.Rewind();	
	if(sName[0] && Kv.JumpToKey(sName, false))
	{
		FormatEx(g_sNextRound, sizeof(g_sNextRound), "%s", sName);
		g_bStartCR = true;
		CS_TerminateRound(0.0, CSRoundEnd_Draw, true);
		return true;
	}
	return false;
}

public int Native_GetCurrentRoundName(Handle hPlugin, int numParams)
{
	if(!g_bIsCR)	return false;
	SetNativeString(1, g_sCurrentRound, GetNativeCell(2), true);
	return true;
}

public int Native_GetNextRoundName(Handle hPlugin, int numParams)
{
	if(!g_bNextCR)	return false;
	SetNativeString(1, g_sNextRound, GetNativeCell(2), true);
	return true;
}

public int Native_GetKeyValue(Handle hPlugin, int numParams)
{
	return view_as<int>(Kv);
}