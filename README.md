# [CORE] Custom Rounds

This plugin provides features for building custom rounds.

Main config file with custom rounds settings located in **configs/custom_rounds/rounds.ini**.

**Config example**:
```
"CustomRounds"
{
	"Knives"
	{
		"no_weapon"		"1"
		"no_buy"		"1"
	}
	
	"AWP - No Zoom"
	{
		"Weapons"
		{
			"weapon_awp"
		}
		
		"ammo"			"1"

		"no_zoom"		"1"
		"no_weapon"		"1"
		"no_knife"		"1"
		"no_buy"		"1"

		"message"		"No zoom round started!"
	}
	
	"Nova + Revolver"
	{
		"Weapons"
		{
			"weapon_nova"
			"weapon_revolver"
		}

		"no_buy"		"1"
		"clear_weapon"	"1"
	}
	
	
	"Drug"
	{
		"gravity"			"0.5"
		"speed"				"2"
		"hp"				"50"
		"armor"				"50"

		"cmd"				"sm_drug @all"
	}
}
```



## [Menu](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Menu.sp)

Basic menu for plugin. With this menu admins can launch rounds from admin menu.

## [Weapons](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Weapons.sp)

Provides keys for weapon control

```
	"block_pickup"		"1"		- 	Block all weapons to been pickuped if they not is specified in cofing.
	"no_knife"			"1"		-	Take knifes from players
	"no_weapon"			"1"		-	Clear all player weapons
	"clear_map"			"1"		-	Clear map from weapons
	
	"Weapons"					-	Gives specified weapons on each player spawn
	{
		"weapon_ak47"
		"weapon_deagle"
		"weapon_hegrenade"
		"weapon_smokegrenade"
		"weapon_fists"
	}
```

>**sm_cr_weapons_save_weapon** - Save weapons before custom round start."
>**sm_cr_weapons_clear_weapon** - Strip all weapons from players, when custom rounds starts with weapons."


## [Misc](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Misc.sp)

Provdies keys for misc things.

```
	"gravity"			"0.2"	-	Set players gravity.		(1.0 is default gravity)
	"speed"				"1.5"	-	Set players movespeed.		(1.0 is default movespeed)
	"invisibility"		"50"	-	Set player invisibility.	(255 is default alpha)
	"hp"				"120"	-	Set player health.
	"armor"				"120"	-	Set player armor.
	"helmet"			"1"		-	Set player helmet.
```

>**sm_cr_misc_save_armor** - Save players armor.


## [Server Commands](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Server_Commands.sp)

Provides keys for exec server commands.

```
	"cmd"				"sm_drug @all; mp_teammates_are_enemies 1"		-	Exec Commands/Cvars on round start.
	"end_cmd"			"mp_teammates_are_enemies 0"					-	Exec Commands/Cvar on round end.
```


## [No Zoom](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Ammo.sp)

Provdies key for no zoom.

```
	"no_zoom"			"1"		-	Set no zoom for rifles.
```

## [Only Headshot](https://github.com/theelsaud/CR-Only-HeadShot)

Provdies key for only headshot.

```
	"only_head"			"1"		-	Enables only headshot.
```

## [Ammo](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Ammo.sp)

Provides key for ammo control. Better use sv_infinite_ammo in ### [Server Commands](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Server_Commands.sp) if you use it. 

```
	"ammo"				"1"		-	Set absolute infinite ammo.
	"ammo"				"2"		-	Set infinite stock ammo.
```


## [Buy Zone](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Buy_Zone.sp)

Provide key for disable buy zones.

```
	"no_buy"			"1"		-	Disables all buy zones until custom round ends.
```


## [Messages](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Messages.sp)

Provide keys for message send on round start, or end.

```
	"message"			"My top round started."		-	Print message on round start.
	"end_message"		"My top round ended."		-	Print message on round end.
	
	Also you can use translation phrases in this keys from **custom_rounds.phrases.txt**. Example:
	
	"message"			"MyTopTranslationPhrase_RoundStart"
	"end_message"		"MyTopTranslationPhrase_RoundEnd"
```


## [Chat Triggers](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Chat_Triggers.sp)

Provide keys for custom chat triggers for launch rounds.

```
	"chat_force"		"round1"		-	Chat trigger for force round start.
	"chat_next"			"round1n"		-	Chat trigger for set next round.
```


## [Doors](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Doors.sp)

Provide key for open doors via [Smart Jail Doors](https://github.com/Kailo97/smartjaildoors) .

```
	"open_doors"		"1"				-	Open all specified doors.
```

###### Requires [Smart Jail Doors](https://github.com/Kailo97/smartjaildoors).


## [Chat](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Chat.sp)

Prints info about plugin events. Print info about started round, canceled current/next rounds and etc.


## [Invervals](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Intervals.sp)

Module for control round frequency.

>**sm_cr_round_interval** - Interval beetwen rounds. 0 - disabled.


## [Logs](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Logs.sp)

Module for log admins actions.

>**sm_cr_logs_path** - Log file name. Default is "Custom_Rounds". Leave empty for default SM log file.


## [Autostart](https://github.com/SomethingFromSomewhere/Custom-Rounds/blob/master/scripting/CR_Autostart.sp)

Module for start custom rounds without admins.
Config file located in **configs/custom_rounds/autostart.ini**.

**Config example**:
```
"Autostart"
{
	"mode"				"1"
	"rounds"			"5"		//	First mode 	- Every N rounds
	"seconds"			"300"	//	Second mode - Every N seconds
	"chance"			"3"		//	Third mode	- Random start.
	
	"Drug"						// Ignored rounds.
	{
	}

	"Nova + Revolver"
	{
	}
}
```


