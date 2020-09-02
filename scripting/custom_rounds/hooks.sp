void HookEvents()
{
	HookEvent("round_prestart", Event_Callback, 		EventHookMode_PostNoCopy	);
	HookEvent("round_start", 	Event_Callback, 		EventHookMode_PostNoCopy	);
	HookEvent("round_end", 		Event_Callback, 		EventHookMode_PostNoCopy	);
	HookEvent("player_spawn", 	Event_Callback										);

	CR_Debug("[Hooks] Events created.");
}

public void Event_Callback(Event hEvent, 	const char[] sName, 	bool bDonBroadcast)
{
	switch(sName[6])
	{
		case 'p':
		{
			CR_Debug("[Hooks] Event 'round_prestart' called.");

			g_bRoundEnd = false;

			if(!KvCurrent && KvNext)
			{
				KvCurrent = KvNext;
				KvNext = null;
			}
			Forward_OnPreRoundStart();
		}
		case 's':
		{
			CR_Debug("[Hooks] Event 'round_start' called.");

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
			CR_Debug("[Hooks] Event 'round_end' called.");

			g_bRoundEnd = true;
			Forward_OnRoundEnd();
		}
		case '_':
		{
			CR_Debug("[Hooks] Event 'player_spawn' called. UserID: %i. Client: %i.", hEvent.GetInt("userid"), GetClientOfUserId(hEvent.GetInt("userid")));

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
		CR_Debug("[Hooks] Event 'OnTerminateRound' called.");
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
