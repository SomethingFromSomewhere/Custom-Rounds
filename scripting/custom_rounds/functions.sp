void Function_CreateRoundKeyValue(const char[] sName = "", bool bType, KeyValues KvTemp = null)
{
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
	if((iClient = GetClientOfUserId(iClient)) && IsClientInGame(iClient) && IsPlayerAlive(iClient))
	{
		Forward_OnPlayerSpawn(iClient);
	}
}

public Action Function_TimerSpawn(Handle hTimer, int iUserID)
{
	if((iUserID = GetClientOfUserId(iUserID)) && IsPlayerAlive(iUserID))	Forward_OnPlayerSpawn(iUserID);
	return Plugin_Stop;
}

void Function_LoadConfig()
{
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

	Forward_OnConfigLoaded();
}

bool Function_CheckMainKeyValue()
{
	if(!Kv)
	{
		Function_LoadConfig();
		LogMessage("[CR][WARNING] Main config not loaded. Attempting to load main config file...");
		if(!Kv)	
		{
			LogError("[CR][ERROR] Main config not loaded!");
			return false;
		}
	}
	return true;
}

void Function_GetRoundNameFromKeyValue(KeyValues KvTarget, char[] sBuffer)
{
	Kv.Rewind();
	KvTarget.GetSectionName(sBuffer, MAX_ROUND_NAME_LENGTH);
}