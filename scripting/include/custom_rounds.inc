#if defined _custom_rounds_included
 #endinput
#endif
#define _custom_rounds_included

#define	MAX_ROUND_NAME_LENGTH	128	

/**
 *	Plugin fully loaded. 
 *
 *	@noreturn
*/
forward void CR_OnPluginStart();

/**
 *	Called once config started loading. 
 *
 *	@noreturn
*/
forward void CR_OnConfigLoad();

/**
 *	Called once config fully loaded. 
 *
 *	@noreturn
*/
forward void CR_OnConfigLoaded();

/**
 *	Called once round begin loading from config. 
 *
 *	@param sName			Round name.
 *	@param Kv				KeyValues with rounds settings.
 *	@return					true to allow, false otherwise.
*/
forward bool CR_OnConfigSectionLoad(const char[] sName, KeyValues Kv);

/**
 *	Called once round loaded from config. 
 *
 *	@param sName			Round name.
 *	@param Kv				KeyValues with rounds settings.
 *	@noreturn
*/
forward void CR_OnConfigSectionLoadPost(const char[] sName, KeyValues Kv);

/**
 *	Called once client or server try to force start custom round.
 *
 *	@param sName			Name of the round.
 *	@param iClient			Client index who set next round, or 0 if server.
 *
 *	@return					Plugin_Continue 	-	allow; 
 							Plugin_Changed		-	allow with changes (sName);
							Plugin_Changed/Stop -	dissalow.
*/
forward Action CR_OnForceRoundStart(int iClient, char[] sName);

/**
 *	Called once client or server started custom round in current round.
 *
 *	@param sName			Name of the round.
 *	@param iClient			Client index who set next round, or 0 if server.
 *
 *	@noreturn
*/
forward void CR_OnForceRoundStartPost(int iClient, const char[] sName);

/**
 *	Called once client or server sets next round.
 *
 *	@param sName			Name of the next round.
 *	@param iClient			Client index who set next round, or 0 if server.
 *
 *	@return					Plugin_Continue 	-	allow; 
 							Plugin_Changed		-	allow with changes (sName);
							Plugin_Changed/Stop -	dissalow.
*/
forward Action CR_OnSetNextRound(int iClient, char[] sName);

/**
 *	Called once client or server set next round.
 *
 *	@param sName			Name of the next round.
 *	@param iClient			Client index who set next round, or 0 if server.
 *
 *	@noreturn
*/
forward void CR_OnSetNextRoundPost(int iClient, const char[] sName);

/**
 *	Called once client or server try to cancel current custom round.
 *
 *	@param iClient			Client index who try to cancel current round, or 0 if server.
 *	@param sName			Name of the current round.
 *
 *	@return					true for allow cancel, false otherwise.
*/
forward bool CR_OnCancelCurrentRound(int iClient, const char[] sName);

/**
 *	Called once client or server cancel current custom round.
 *
 *	@param iClient			Client index who try to cancel current round, or 0 if server.
 *	@param sName			Name of the current round.
 *
 *	@noreturn
*/
forward void CR_OnCancelCurrentRoundPost(int iClient, const char[] sName);

/**
 *	Called once client or server try to cancel next custom round.
 *
 *	@param iClient			Client index who try to cancel next round, or 0 if server.
 *	@param sName			Name of the next round.
 *
 *	@return					true for allow cancel, false otherwise.
*/
forward bool CR_OnCancelNextRound(int iClient, const char[] sName);

/**
 *	Called once client or server cancel next custom round.
 *
 *	@param iClient			Client index who try to cancel next round, or 0 if server.
 *	@param sName			Name of the next round.
 *
 *	@noreturn
*/
forward void CR_OnCancelNextRoundPost(int iClient, const char[] sName);

/**
 *	Called once player spawned.
 *
 *	@param iClient			Client index.
 *	@param Kv				KeyValues с настройками раунда.
 *	@noreturn
*/
forward void CR_OnPlayerSpawn(int iClient, KeyValues Kv);

/**
 *	Called every time when round starts. 
 *
 *	@param Kv				KeyValue with round section.
 *	@noreturn
*/
forward void CR_OnRoundStart(KeyValues Kv);

/**
 *	Called once custom round ended.
 *	
 *	@param sName			Name of the ended round, or `` if round default.
 *	@param Kv				KeyValue with round section.
 *	@param iClient			Client index who canceled next round, or 0 if server.
 *	@noreturn
*/
forward void CR_OnRoundEnd(KeyValues Kv);

/**
 *  Sets next round.
 *
 *  @param sName	        Round name.
 *  @param iClient          Client index.
 *
 *  @error                  Round not found.
 *
 *	@return                 true if next round set, false otherwise.
 */
native bool CR_SetNextRound(const char[] sName, int iClient = 0);

/**
 *  Sets next round with specific KeyValues settings.
 *
 *  @param Kv				KeyValues with settings.
 *  @param iClient          Client index.
 *
 *  @error                  Invalid KeyValue.
 *
 *	@return                 true if next round set, false otherwise.
 */
native bool CR_SetNextRoundFromKeyValue(KeyValues Kv, int iClient = 0);

/**
 *  Cancels next round.
 *	
 *  @param iClient          Client index who canceled the round, or 0 for server.
 *	@return                 true if next round canceled, false if next round default, or blocked by forward.
 */
native bool CR_CancelNextRound(int iClient = 0);

/**
 *	Launch custom round.
 *
 *	@param sName			Round name.
 *	@param iClient			Client index.
 *
 *  @error                  Round not found.
 *
 *	@return					true if round started, false otherwise.
*/
native bool CR_StartRound(const char[] sName, int iClient = 0);

/**
 *	Launch custom round with specific KeyValues settings. 
 *
 *	@param Kv				KeyValue with settings.
  *	@param iClient			Client index.
 *
 *  @error					Invalid KeyValue;
 *
 *	@return					true if round started, false otherwise.
*/
native bool CR_StartRoundFromKeyValue(KeyValues Kv, int iClient = 0);

/**
 *  Cancels current round.
 *	
 *  @param iClient          Client index who canceled the round, or 0 for server.
 *	@return                 true if current round canceled, false if current round default, or blocked by forward.
 */
native bool CR_StopRound(int iClient = 0);

/**
 *	Checks if current round custom.
 *
 *	@return                 true if custom, false otherwise.
*/
native bool CR_IsCustomRound();

/**
 *	Checks if next round custom.
 *
 *	@return                 true if next round custom, false otherwise.
*/
native bool CR_IsNextRoundCustom();

/**
 *	Check is round end or not. (Time between `round_end` and `round_start`)
 *
 *	@return                 true if round end, false otherwise.
*/
native bool CR_IsRoundEnd();

/**
 *	Checks if round exists.
 *
 *	@return                 true if exists, false otherwise.
*/
native bool CR_IsRoundExists(const char[] sRound);

/**
 *	Return current round name.
 *
 * 	@param sName			Buffer for copy.
 * 	@param iMaxLength		Buffer length.
 *	@return                 true if current round custom, false otherwise.
*/
native bool CR_GetCurrentRoundName(char[] sName, int iMaxLenght);

/**
 *	Return next round name.
 *
 * 	@param sName			Buffer for copy.
 * 	@param iMaxLength		Buffer length.
 *	@return                 true if next round custom, false otherwise.
*/
native bool CR_GetNextRoundName(char[] sName, int iMaxLenght);

/**
 *	Returns KeyValue with custom rounds settings. 
 *
 *	@return					Core KeyValue.
*/
native KeyValues CR_GetKeyValue();

/**
 *	Returns KeyValue with current custom round settings.
 *
 *	@return					Current round KeyValue, or null if current round default.
*/
native KeyValues CR_GetCurrentRoundKeyValue();

/**
 *	Returns KeyValue with next custom round settings.
 *
 *	@return					Next round KeyValue, or null if next round default.
*/
native KeyValues CR_GetNextRoundKeyValue();

/**
 *	Reloads Custom Rounds config.
 *
 *	@noreturn
*/
native void CR_ReloadConfig();

/**
 *  Return copy of array filled by loaded custom rounds.
 *	
 *	@retrun					ArrayList with rounds.
 */
native ArrayList CR_GetArrayOfRounds();

/**
 *  Return round number in array.
 *	
 *	@retrun					Round index, or -1 on failure
 */
native int CR_GetRoundNumber(const char[] sName);

public SharedPlugin __pl_custom_rounds= 
{
	name = "custom_rounds",
	file = "Custom_Rounds.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_custom_rounds_SetNTVOptional()
{
	MarkNativeAsOptional("CR_StartRound");
	MarkNativeAsOptional("CR_StartRoundFromKeyValue");
	MarkNativeAsOptional("CR_StopRound");

	MarkNativeAsOptional("CR_SetNextRound");
	MarkNativeAsOptional("CR_SetNextRoundFromKeyValue");
	MarkNativeAsOptional("CR_CancelNextRound");
	
	MarkNativeAsOptional("CR_IsCustomRound");
	MarkNativeAsOptional("CR_IsNextRoundCustom");
	MarkNativeAsOptional("CR_IsRoundEnd");
	MarkNativeAsOptional("CR_IsRoundExists");

	MarkNativeAsOptional("CR_GetCurrentRoundName");
	MarkNativeAsOptional("CR_GetNextRoundName");

	MarkNativeAsOptional("CR_GetKeyValue");
	MarkNativeAsOptional("CR_GetCurrentRoundKeyValue");
	MarkNativeAsOptional("CR_GetNextRoundKeyValue");
	
	MarkNativeAsOptional("CR_ReloadConfig");
	MarkNativeAsOptional("CR_GetArrayOfRounds");
	MarkNativeAsOptional("CR_GetRoundNumber");
}
#endif
