void Function_CreateRoundKeyValue(const char[] sName = "", KeyValues KvTemp = null)
{
	delete KvCurrent;
	KvCurrent = new KeyValues("Current");
	if(KvTemp == null)
	{
		Kv.Rewind();	
		if(Kv.JumpToKey(sName))
		{
			KvCopySubkeys(Kv, KvCurrent);
		}
	}
	else
	{
		KvTemp.Rewind();	
		KvCopySubkeys(KvTemp, KvCurrent);
	}
}

public void Function_FrameSpawn(int iClient)
{
	iClient = GetClientOfUserId(iClient);
	if((iClient = GetClientOfUserId(iClient)) != 0 && IsClientInGame(iClient) && IsPlayerAlive(iClient))
	{
		Forward_OnPlayerSpawn(iClient);
	}
}

public Action Function_TimerSpawn(Handle hTimer, int iUserID)
{
	if((iUserID = GetClientOfUserId(iUserID)) != 0 && IsPlayerAlive(iUserID))	Forward_OnPlayerSpawn(iUserID);
	return Plugin_Stop;
}