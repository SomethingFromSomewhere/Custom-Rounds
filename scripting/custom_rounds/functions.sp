void Function_CreateRoundKeyValue(const char[] sName = "", bool bType, KeyValues KvTemp = null)
{
	CR_Debug("[Functions] Function 'CreateRoundKeyValue' called. Name %s.", sName);
	if(!KvTemp)
	{
		Kv.Rewind();	
		if(Kv.JumpToKey(sName))
		{
			if(bType)
			{
				if(KvCurrent)	delete KvCurrent;
				KvCurrent = new KeyValues(sName);
				KvCopySubkeys(Kv, KvCurrent);
			}
			else
			{
				if(KvNext)		delete KvNext;
				KvNext = new KeyValues(sName);
				KvCopySubkeys(Kv, KvNext);
			}
		}
	}
	else
	{
		KvTemp.Rewind();
		if(bType)	
		{
			if(KvCurrent)	delete KvCurrent;
			KvCurrent = KvTemp;
		}
		else
		{
			if(KvNext)		delete KvNext;
			KvNext = KvTemp;
		}
	}
}

public void Function_FrameSpawn(int iClient)
{
	CR_Debug("[Functions] Function 'FrameSpawn' called. UserID: %i. Client: %i.", iClient, GetClientOfUserId(iClient));

	if((iClient = GetClientOfUserId(iClient)) && IsClientInGame(iClient) && IsPlayerAlive(iClient))	Forward_OnPlayerSpawn(iClient);
}

public Action Function_TimerSpawn(Handle hTimer, int iClient)
{
	CR_Debug("[Functions] Function 'TimerSpawn' called. UserID: %i. Client: %i.", iClient, GetClientOfUserId(iClient));

	if((iClient = GetClientOfUserId(iClient)) && IsClientInGame(iClient) && IsPlayerAlive(iClient))	Forward_OnPlayerSpawn(iClient);
	return Plugin_Stop;
}

void Function_LoadConfig()
{
	CR_Debug("[Functions] Function 'LoadConfig' start call.");
	if(Kv)	delete Kv;
	Kv = new KeyValues("CustomRounds");

	g_hArray.Clear();
	Forward_OnConfigLoad();
	
	char sBuffer[PLATFORM_MAX_PATH];
	BuildPath(Path_SM, sBuffer, sizeof(sBuffer), "configs/custom_rounds/rounds.ini");
	if (!FileToKeyValues(Kv, sBuffer))
	{
		delete Kv;
		LogMessage("[WARNING] Missing rounds config file %s", sBuffer);
		CR_Debug("[Functions] Function 'LoadConfig' call. No Config file.");
	}

	if (Kv && Kv.GotoFirstSubKey())
	{
		do
		{
			if(Kv.GetSectionName(sBuffer, sizeof(sBuffer)) && Forward_OnConfigSectionLoad(sBuffer, Kv))
			{
				g_hArray.PushString(sBuffer);
				Forward_OnConfigSectionLoadPost(sBuffer, Kv);
			}
		}
		while (Kv.GotoNextKey());
	}

	CR_Debug("[Functions] Function 'LoadConfig' end call.");

	Forward_OnConfigLoaded();
}

bool Function_CheckMainKeyValue()
{
	if(!Kv)
	{
		Function_LoadConfig();

		CR_Debug("[Functions] Function 'CheckMainKeyValue' called. Attempt to load config.");
		LogMessage("[CR][WARNING] Main config not loaded. Attempting to load main config file...");

		if(!Kv)	
		{
			LogError("[CR][ERROR] Main config not loaded!");
			CR_Debug("[Functions] Function 'CheckMainKeyValue' called. Attempt to load config failed.");

			return false;
		}
	}

	CR_Debug("[Functions] Function 'CheckMainKeyValue' called.");

	return true;
}

void Function_GetRoundNameFromKeyValue(KeyValues KvTarget, char[] sBuffer, int iLen)
{
	Kv.Rewind();
	KvTarget.GetSectionName(sBuffer, iLen);
	CR_Debug("[Functions] Function 'GetRoundNameFromKeyValue' called.");
}