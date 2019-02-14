void HookEvents()
{
	HookEvent("round_start", 	Event_RoundStart, 		EventHookMode_PostNoCopy);
	HookEvent("round_end", 		Event_RoundEnd, 		EventHookMode_PostNoCopy);
	HookEvent("player_spawn", 	Event_PlayerSpawn);
}

public void Event_RoundStart(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	g_bRoundEnd = false;

	if(g_sCurrentRound[0])
	{
		Kv.Rewind();	
		if(Kv.JumpToKey(g_sCurrentRound))
		{
			g_bIsCR = true;
		}
	}
	else if(g_sNextRound[0])
	{
		Kv.Rewind();	
		if(Kv.JumpToKey(g_sNextRound))
		{
			g_sCurrentRound = g_sNextRound;
			g_bIsCR = true;
		}
		g_sNextRound[0] = '\0';
	}
	Forward_OnRoundStart(g_sCurrentRound);
}

public void Event_RoundEnd(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	g_bRoundEnd = true;
	Forward_OnRoundEnd();
	g_sCurrentRound[0] = '\0';
}

public void Event_PlayerSpawn(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	if(g_fRespawn > 0.0)	CreateTimer(	g_fRespawn, TimerSpawn, hEvent.GetInt("userid"), TIMER_FLAG_NO_MAPCHANGE);
	else					RequestFrame(	FrameSpawn, 			hEvent.GetInt("userid"));
}

public void FrameSpawn(int iClient)
{
	iClient = GetClientOfUserId(iClient);
	if((iClient = GetClientOfUserId(iClient)) != 0 && IsClientInGame(iClient) && IsPlayerAlive(iClient))
	{
		Forward_OnPlayerSpawn(iClient);
	}
}

public Action TimerSpawn(Handle hTimer, int iUserID)
{
	if((iUserID = GetClientOfUserId(iUserID)) != 0 && IsPlayerAlive(iUserID))	Forward_OnPlayerSpawn(iUserID);
	return Plugin_Stop;
}