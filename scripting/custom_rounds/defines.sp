KeyValues 	Kv, 			KvCurrent;
ArrayList 	g_hArray;


bool		g_bRoundEnd;


float 		g_fRespawn,		g_fRestartDelay;


char 		g_sNextRound[MAX_ROUND_NAME_LENGTH];


Handle 		g_hForward_OnSetNextRound, 			g_hForward_OnForceStartRound,		g_hForward_OnRoundEnd, 			

			g_hForward_OnRoundStart, 			g_hForward_OnConfigLoad, 			g_hForward_OnConfigSectionLoad, 
			
			g_hForward_OnCancelNextRound, 		g_hForward_OnPlayerSpawn, 			g_hForward_OnConfigSectionLoadPost,
			
			g_hForward_OnCancelCurrentRound,	g_hForward_PluginStarted,			g_hForward_OnConfigLoaded;