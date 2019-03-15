#if defined _custom_rounds_included
 #endinput
#endif
#define _custom_rounds_included

#define	MAX_ROUND_NAME_LENGTH	128	

/**
 *	Called once round begin loading from config. 
 *
 *	@param sName			Round name.
 *	@return					true to allow, false otherwise.
*/
forward bool CR_OnConfigSectionLoad(const char[] sName);

/**
 *	Called once round loaded from config. 
 *
 *	@param sName			Round name.
 *	@noreturn
*/
forward void CR_OnConfigSectionLoadPost(const char[] sName);

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
 *	Plugin fully loaded. 
 *
 *	@noreturn
*/
forward void CR_OnPluginStart();

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
 *	Called once client or server try to cancel current custom round.
 *
 *	@param iClient			Client index who try to cancel current round, or 0 if server.
 *	@param sName			Name of the current round.
 *
 *	@return					true for allow, false otherwise.
*/
forward bool CR_OnCancelCurrentRound(int iClient, const char[] sName);

/**
 *	Called once client or server try to cancel next custom round.
 *
 *	@param iClient			Client index who try to cancel next round, or 0 if server.
 *	@param sName			Name of the next round.
 *
 *	@return					true for allow, false otherwise.
*/
forward bool CR_OnCancelNextRound(int iClient, const char[] sName);

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
forward Action CR_OnSetNextRound(char[] sName, int iClient);

/**
 *	Called once client or server try to force start custom round.
 *
 *	@param sName			Name of the next round.
 *	@param iClient			Client index who set next round, or 0 if server.
 *
 *	@return					Plugin_Continue 	-	allow; 
 							Plugin_Changed		-	allow with changes (sName);
							Plugin_Changed/Stop -	dissalow.
*/
forward Action CR_OnForceRoundStart(char[] sName, int iClient);

/**
 *	Called once player spawned.
 *
 *	@param iClient			Client index.
 *	@param Kv				KeyValues с настройками раунда.
 *	@noreturn
*/
forward void CR_OnPlayerSpawn(int iClient, KeyValues Kv);

/**
 *	Reloads Custom Rounds config.
 *
 *	@noreturn
*/
native void CR_ReloadConfig();

/**
 *	Returns KeyValues with custom rounds settings. 
 *
 *	@return                 KeyValues Custom Rounds.
*/
native KeyValues CR_GetKeyValue();

/**
 *	Проверяет на конец раунда. 
 *
 * 	@param sName			Буфер, в который будет записано название раунда.
 * 	@param iMaxLength		Размер буфера.
 *	@return                 false в случае если текущий раунд обычный, иначе true.
*/
native bool CR_GetCurrentRoundName(char[] sName, int iMaxLenght);

/**
 *	Возвращает название следующего раунда. 
 *
 * 	@param sName			Буфер, в который будет записано название раунда.
 * 	@param iMaxLength		Размер буфера.
 *	@return                 false в случае если нет следующего раунда, иначе true.
*/
native bool CR_GetNextRoundName(char[] sName, int iMaxLenght);

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
 *	Checks if next round custom.
 *
 *	@return                 true if next round custom, false otherwise.
*/
native bool CR_IsNextRoundCustom();

/**
 *	Checks if current round custom.
 *
 *	@return                 true if custom, false otherwise.
*/
native bool CR_IsCustomRound();

/**
 *	Запускает раунд. 
 *
 *	@param sName			Название раунда.
 *	@param iClient			Индекс игрока.
 *
 *  @error                  Раунд не найден.
 *
 *	@return					true, если раунд запустился,  иначе false.
*/
native bool CR_StartRound(const char[] sName, int iClient = 0);

/**
 *	Запускает раунд с указанным KeyValues. 
 *
 *	@param Kv				KeyValue с настройками.
 *
 *  @error                  Невалидный KeyValue;
 *
 *	@return					true, если раунд запустился,  иначе false.
*/
native bool CR_StartRoundFromKeyValue(KeyValues Kv);

/**
 *  Устанавливет следующий раунд.
 *
 *  @param sName	        Название раунда.
 *  @param iClient          Индекс игрока.
 *
 *  @error                  Раунд не найден.
 *
 *	@return                 true, если раунд установился, иначе false.
 */
native bool CR_SetNextRound(const char[] sName, int iClient = 0);

/**
 *  Cancels current round.
 *	
 *  @param iClient          Client index who canceled the round, or 0 for server.
 *	@return                 true if current round canceled, false if current round default, or blocked by forward.
 */
native bool CR_StopRound(int iClient = 0);

/**
 *  Cancels next round.
 *	
 *  @param iClient          Client index who canceled the round, or 0 for server.
 *	@return                 true if next round canceled, false if next round default, or blocked by forward.
 */
native bool CR_CancelNextRound(int iClient = 0);

/**
 *  Return array filled by loaded custom rounds.
 *	
 *	@retrun					ArrayList with rounds.
 */
native ArrayList CR_GetArrayOfRounds();

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
	MarkNativeAsOptional("CR_CancelNextRound");
	MarkNativeAsOptional("CR_StopRound");
	MarkNativeAsOptional("CR_SetNextRound");
	MarkNativeAsOptional("CR_StartRound");
	MarkNativeAsOptional("CR_StartRoundFromKeyValue");
	MarkNativeAsOptional("CR_IsCustomRound");
	MarkNativeAsOptional("CR_IsNextRoundCustom");
	MarkNativeAsOptional("CR_IsRoundEnd");
	MarkNativeAsOptional("CR_IsRoundExists");
	MarkNativeAsOptional("CR_GetNextRoundName");
	MarkNativeAsOptional("CR_GetCurrentRoundName");
	MarkNativeAsOptional("CR_GetKeyValue");
	MarkNativeAsOptional("CR_ReloadConfig");
	MarkNativeAsOptional("CR_GetArray");
}
#endif
