#if defined _custom_rounds_included
 #endinput
#endif
#define _custom_rounds_included

#define	MAX_ROUND_NAME_LENGTH	128	

enum HOOK_TYPE
{
	HOOK_PRE = 0,
	HOOK_NORMAL,
	HOOK_POST
}

/**
 *	Вызывается когда был загржуен ключ KeyValues. 
 *
 *	@param sName			Название раунда.
 *	@noreturn
*/
forward void CR_OnConfigSectionLoad(const char[] sName);

/**
 *	Вызывается когда конфиг начинает загружаться. 
 *
 *	@noreturn
*/
forward void CR_OnConfigLoad();

/**
 *	Вызывается когда нестандартный раунд начался. 
 *
 *	@param sName			Название раунда.
 *	@noreturn
*/
forward void CR_OnStartRound(const char[] sName, HOOK_TYPE Type);

/**
 *	Вызывается когда нестандартный раунд закончился. 
 *	
 *	@param sName			Название раунда.
 *	@param iClient			Индекс игрока, который завершил раунд.
 *	@noreturn
*/
forward void CR_OnRoundEnd(const char[] sName, int iClient);

/**
 *	Вызывается когда следующий раунд был отменен. 
 *
 *	@param iClient			Индекс игрока, который отменил раунд.
 *	@noreturn
*/
forward void CR_OnCancelNextRound(int iClient);

/**
 *	Вызывается когда был установлен следующий раунд. 
 *
 *	@param sName			Название следующего раунда.
 *	@param iClient			Индекс игрока, который установил раунд.
 *	@noreturn
*/
forward void CR_OnSetNextRound(const char[] sName, int iClient);

/**
 *	Вызывается когда был установлен и запущен раунд. 
 *
 *	@param sName			Название следующего раунда.
 *	@param iClient			Индекс игрока.
 *	@noreturn
*/
forward void CR_OnStartCurrentRound(const char[] sName, int iClient);

/**
 *	Вызывается когда игрок возродился в нестандартном раунде. 
 *
 *	@param iClient			Индекс игрока.
 *	@noreturn
*/
forward void CR_OnPlayerSpawn(int iClient, HOOK_TYPE Type);

/**
 *	Вызывается когда игрок написал !cr/sm_cr. 
 *
 *	@noreturn
*/
forward void CR_OnChatCommand(int iClient);

/**
 *	Перезагружает конфиг Custom Rounds. 
 *
 *	@noreturn
*/
native void CR_ReloadConfig();

/**
 *	Возвращает KeyValues плагина. 
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
 *	Проверяет на конец раунда. 
 *
 *	@return                 true в случае если конец раунда, иначе false.
*/
native bool CR_IsRoundEnd();

/**
 *	Возвращает тип следующего раунда. 
 *
 *	@return                 true в случае если раунд нестандартный, иначе false.
*/
native bool CR_IsNextRoundCustom();

/**
 *	Возвращает тип раунда. 
 *
 *	@return                 true в случае если раунд нестандартный, иначе false.
*/
native bool CR_IsCustomRound();

/**
 *	Запускает раунд. 
 *
 *	@param sName			Название раунда.
 *	@param iClient			Индекс игрока.
 *	@param bCheckInterval	Если true, то проверяет интервал (квар sm_cr_round_interval).
 *	@return                 false, если интервал между раундами не пройден;
 *  @error                  Раунд не найден.
 *	@noreturn
*/
native bool CR_StartRound(const char[] sName, int iClient = 0, bool bCheckInterval = false);

/**
 *  Устанавливет следующий раунд.
 *
 *  @param sName	        Название раунда.
 *  @param iClient          Индекс игрока.
 *	@param bCheckInterval	Если true, то проверяет интервал (квар sm_cr_round_interval).
 *	@return                 false, если интервал между раундами не пройден;
 *  @error                  Раунд не найден.
 */
native bool CR_SetNextRound(const char[] sName, int iClient = 0, bool bCheckInterval = false);

/**
 *  Останавливает раунд.
 *
 *  @param iClient          Индекс игрока.
 *	@return                 false, если текущий раунд обычный, иначе true;
 */
native bool CR_StopRound(int iClient = 0);

/**
 *  Отменяет следующий раунд.
 *	
 *  @param iClient          Индекс игрока.
 *	@return                 false, если следующего раунда нет, иначе true;
 */
native bool CR_CancelNextRound(int iClient = 0);

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
	MarkNativeAsOptional("CR_IsCustomRound");
	MarkNativeAsOptional("CR_IsNextRoundCustom");
	MarkNativeAsOptional("CR_IsRoundEnd");
	MarkNativeAsOptional("CR_GetNextRoundName");
	MarkNativeAsOptional("CR_GetCurrentRoundName");
	MarkNativeAsOptional("CR_GetKeyValue");
	MarkNativeAsOptional("CR_ReloadConfig");
}
#endif
