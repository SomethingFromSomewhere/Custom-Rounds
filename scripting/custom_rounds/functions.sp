void Function_CreateRoundKeyValue(const char[] sName = "", KeyValues KvTemp = null)
{
	delete KvCurrent;
	if(!KvTemp)
	{
		Kv.Rewind();	
		if(Kv.JumpToKey(sName))
		{
			KvCurrent = new KeyValues(sName);
			KvCopySubkeys(Kv, KvCurrent);
		}
	}
	else
	{
		KvTemp.Rewind();
		KvCurrent = KvTemp;
		//KvCopySubkeys(KvTemp, KvCurrent);
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
	delete Kv;
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
			if(Kv.GetSectionName(sBuffer, sizeof(sBuffer)) && Forward_OnConfigSectionLoad(sBuffer))
			{
				g_hArray.PushString(sBuffer);
				Forward_OnConfigSectionLoadPost(sBuffer);
			}
		}
		while (Kv.GotoNextKey());
	}

	Forward_OnConfigLoaded();
}
