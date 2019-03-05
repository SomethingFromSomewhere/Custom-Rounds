void HookEvents()
{
	HookEvent("round_start", 	Event_RoundStart, 		EventHookMode_PostNoCopy);
	HookEvent("round_end", 		Event_RoundEnd, 		EventHookMode_PostNoCopy);
	HookEvent("player_spawn", 	Event_PlayerSpawn);
}

public void Event_RoundStart(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	g_bRoundEnd = false;

	if(!KvCurrent && g_sNextRound[0])
	{
		Function_CreateRoundKeyValue(g_sNextRound);
		g_sNextRound[0] = '\0';
	}
	Forward_OnRoundStart();
}

public void Event_RoundEnd(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	g_bRoundEnd = true;
}

public void Event_PlayerSpawn(Event hEvent, 	const char[] name, 	bool bDonBroadcast)
{
	if(g_fRespawn > 0.0)	CreateTimer(	g_fRespawn, Function_TimerSpawn, 
											hEvent.GetInt("userid"), 
											TIMER_FLAG_NO_MAPCHANGE);
	else					RequestFrame(	Function_FrameSpawn, 			
											hEvent.GetInt("userid"));
}

public Action CS_OnTerminateRound(float &fDelay, CSRoundEndReason &iReason)
{
	if(KvCurrent)	
	{
		Forward_OnRoundEnd();
		delete KvCurrent;
	}
}