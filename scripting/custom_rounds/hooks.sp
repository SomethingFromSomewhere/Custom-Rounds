void HookEvents()
{
	HookEvent("round_start", 	Event_Callback, 		EventHookMode_PostNoCopy	);
	HookEvent("round_end", 		Event_Callback, 		EventHookMode_PostNoCopy	);
	HookEvent("player_spawn", 	Event_Callback										);
}

public void Event_Callback(Event hEvent, 	const char[] sName, 	bool bDonBroadcast)
{
	switch(sName[6])
	{
		case 's':
		{
			g_bRoundEnd = false;

			if(!KvCurrent && KvNext)
			{
				KvCurrent = KvNext;
				KvNext = null;
			}
			Forward_OnRoundStart();
		}
		case 'e':
		{
			g_bRoundEnd = true;
			Forward_OnRoundEnd();
		}
		case '_':
		{
			if(g_fRespawn > 0.0)	CreateTimer(	g_fRespawn, Function_TimerSpawn, 
													hEvent.GetInt("userid"), 
													TIMER_FLAG_NO_MAPCHANGE);
			else					RequestFrame(	Function_FrameSpawn, 			
													hEvent.GetInt("userid"));
		}
	}
}

public Action CS_OnTerminateRound(float &fDelay, CSRoundEndReason &iReason)
{
	if(KvCurrent)	
	{
		Forward_OnRoundEnd();
	}
}

public void OnMapStart()
{
	Function_LoadConfig();
	
	g_bRoundEnd 		= 	false;
	if(KvCurrent)	delete KvCurrent;
	if(KvNext)		delete KvNext;
}
