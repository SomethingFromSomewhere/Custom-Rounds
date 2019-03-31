KeyValues 	Kv, 			
			KvCurrent,
			KvNext;

ArrayList 	g_hArray;

bool		g_bRoundEnd;

float 		g_fRespawn,
			g_fRestartDelay;

Handle		g_hForward_OnPluginStart,				//	void 	CR_OnPluginStart()
			
			
			g_hForward_OnConfigLoad,				//	void	CR_OnConfigLoad()
			g_hForward_OnConfigLoaded,				//	void	CR_OnConfigLoaded()
			g_hForward_OnConfigSectionLoad,			//	bool	CR_OnConfigSectionLoad(const char[] sName)
			g_hForward_OnConfigSectionLoadPost,		//	void	CR_OnConfigSectionLoadPost(const char[] sName)
			
			
			g_hForward_OnForceRoundStart,			//	Action 	CR_OnForceRoundStart(int iClient, char[] sName)
			g_hForward_OnForceRoundStartPost,		//	void 	CR_OnForceRoundStartPost(int iClient, const char[] sName)
			
			
			g_hForward_OnSetNextRound,				//	Action 	CR_OnSetNextRound(int iClient, char[] sName)
			g_hForward_OnSetNextRoundPost,			//	void 	CR_OnSetNextRoundPost(int iClient, const char[] sName)
			
			
			g_hForward_OnCancelCurrentRound,		//	bool 	CR_OnCancelCurrentRound(int iClient, char[] sName)
			g_hForward_OnCancelCurrentRoundPost,	//	void 	CR_OnCancelCurrentRoundPost(int iClient, const char[] sName)
			
			
			g_hForward_OnCancelNextRound,			//	bool 	CR_OnCancelNextRound(int iClient, char[] sName)
			g_hForward_OnCancelNextRoundPost,		//	void 	CR_OnCancelNextRoundPost(int iClient, const char[] sName)
			
			
			g_hForward_OnPlayerSpawn,				//	void 	CR_OnPlayerSpawn(int iClient, KeyValues Kv)
			g_hForward_OnRoundStart,				//	void 	CR_OnRoundStart(KeyValues Kv)
			g_hForward_OnRoundEnd;					//	void 	CR_OnRoundEnd(KeyValues Kv)
