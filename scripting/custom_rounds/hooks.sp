void HookEvents()
{
	HookEvent("round_start", Event_RoundStart, EventHookMode_PostNoCopy);
	HookEvent("round_end", Event_RoundEnd, EventHookMode_PostNoCopy);
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Post);
}

public Action Event_RoundStart(Event hEvent, const char[] name, bool bDonBroadcast)
{
	Forward_OnStartRound("", HOOK_PRE);
	g_bIsCR = false;
	
	if((g_bStartCR || g_bNextCR) && StartRound(g_sNextRound))
	{
		FormatEx(g_sCurrentRound, sizeof(g_sCurrentRound), "%s", g_sNextRound);
		g_bStartCR = false;
		g_bNextCR = false;
		g_bInverval = true;
	}
	g_bRoundEnd = false;
	
	Forward_OnStartRound(g_sCurrentRound, HOOK_POST);
	if(g_bIsCR && g_bInverval && ++g_iRounds > g_iInterval)	g_iRounds = 0;	g_bInverval = false;

	return Plugin_Continue;
}

static bool StartRound(const char[] sName)
{
	Kv.Rewind();	
	if(sName[0] && Kv.JumpToKey(sName, false))
	{
		g_bIsCR = true;
		Forward_OnStartRound(sName, HOOK_NORMAL);
		return true;
	}
	return false;
}

public Action Event_RoundEnd(Event hEvent, const char[] name, bool bDonBroadcast)
{
	if(g_bIsCR)	Forward_OnRoundEnd(g_sCurrentRound);
	g_bRoundEnd = true;
	return Plugin_Continue;
}

public Action Event_PlayerSpawn(Event hEvent, const char[] name, bool bDonBroadcast)
{
	RequestFrame(FrameSpawn, GetClientOfUserId(hEvent.GetInt("userid")));
}

public void FrameSpawn(int iClient)
{
	Forward_OnPlayerSpawn(iClient, HOOK_PRE);
	if(g_bIsCR)	Forward_OnPlayerSpawn(iClient, HOOK_NORMAL);
	Forward_OnPlayerSpawn(iClient, HOOK_POST);
}

