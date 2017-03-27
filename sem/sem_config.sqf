/*
	SEM - "Simple Epoch Missions" configuration file
	By KiloSwiss
*/
/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/

	/* Mission start/timer settings */
	
SEM_MinPlayerStatic 	= 1;		// Minimum number of online players for basic missions to spawn.
SEM_MinPlayerDynamic 	= 1; 		// Minimum number of online players for additional/parallel running missions.
SEM_MaxPlayers 			= 40;

SEM_TimerStart			= 5;		// Minutes to start first Mission.

SEM_MissionTimerMin 	= 10;		// Minimum minutes between missions.
SEM_MissionTimerMax 	= 20;		// Maximum minutes between missions.

/* Reward/punish settings */
SEM_reward_AIkill 		= true;		// Defines if players get some Krypto as reward for each AI they kill.
SEM_punish_AIroadkill 	= true;		// Defines if players should be punished for killing AI units by driving them over with cars.
SEM_damage_AIroadkill 	= true;		// Defines if the players car should be damaged when driving over an AI unit.
SEM_Krypto_AIroadkill 	= 20;		// How much Krypto will be removed by punishing players for AI roadkills.


/* Advanced mission settings */

// Minutes after a finished mission where all mission objects (including AI) will be deleted.
SEM_MissionCleanup 		= 10;		// 0 or -1 equals never.
	
// Allow captured Vehicles do be permanent (saved to Database).
SEM_permanentVehicles 	= false;	// true or false

// Chance of AI dropping their guns and keeping their gear (vests, backpacks and magazines) when killed.
SEM_AIdropGearChance 	= 40;		//	Values: 0-100%	Where 0 means all gear gets removed from dead AI units.

// Disable Damage over a specific distance so players can't snipe the mission AI from safe distance.
SEM_AIdisableSniperDamage = true;	// Set to false to allow sniper damage from any distance.
SEM_AIsniperDamageDistance = 700;	// Max. distance (in meters) where AI takes damage (min. 300 -  max. 1000).


	/* ################# */			/* ################# */			/* ################# */
	/* Advanced settings */			/* Advanced settings */			/* Advanced settings */
	/* ################# */			/* ################# */			/* ################# */


SEM_removeWeaponsFromDeadAI = [];	// Weapons that should be removed from killed AI
SEM_removeMagazinesFromDeadAI = [];	// Magazines that should be removed from killed AI

//Marker Names where mission spawning is blocked.
SEM_blockMarker = 	[
//						"respawn_west"
					];
SEM_blockPos =		[
						[6717,19562,25],
						[19375,17620,25],
						[13323,14500,25],
						[9275,10857,25],
						[19359,9696,25]
					];

	/* Static Missions */
SEM_staticMissionsPath = "sem\missionsStatic\";
SEM_staticMissions = [
	["bSupplyCrash",	"Supply Van",		45,	15,		2,	false],
	["bPlaneCrash",		"Plane Crashsite",	45,	15,		2,	false],
	["bHeliCrash",		"Heli Crashsite",	45,	15,		2,	false],
	["bCamp_big",		"Bandit Base",		60,	50,		3,	false],
	["bCamp_small",		"Bandit Camp",		70,	50,		3,	false],
	["bDevice",			"Strange Device",	45,	15,		2,	false],
	/* example */
	["file name",		"marker name",		-1,	-1,		5,	false]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.		5.	6.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the mission marker.
	3. time out,		(Number) Minutes until running mission times out (0 or -1 equals no mission time out).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
	5. danger level		(Number) Color for the mission marker (0=white, 1=yellow, 2=orange, 3=red, 4=violet, 5=black)
	6. static/dynamic	Use dynamic (true) for convoys and static (false) for stationary missions.
*/];

	/* Dynamic Missions */
SEM_dynamicMissionsPath = "sem\missionsDynamic\";
SEM_dynamicMissions = [
	["convoySupply",	"Supply Convoy",	90,	-1,	0,	true],
	["convoyRepair",	"Repair Convoy",	90,	-1,	1,	true],
	["convoyStrider",	"Strider Convoy",	90,	-1,	2,	true],
	["convoyWeapon",	"Weapon Convoy",	90,	-1,	3,	true]	//NO COMMA AT THE LAST LINE!
/*	 1.					2.					3.	4.	5.	6.

	1. "file name"  	MUST be equal to the sqf file name!
	2. "marker name" 	Name of the mission marker.
	3. time out,		(Number) Minutes until running mission times out (0 or -1 equals no mission time out).
	4. probability		(Number) Percentage of probability how often a mission will spawn: 1 - 100 (0 and -1 equals OFF).
	5. danger level		(Number) Colour for the mission marker (0=white, 1=yellow, 2=orange, 3=red, 4=violet, 5=black)
	6. static/dynamic	Use dynamic (true) for convoys and static (false) for stationary missions.
*/
];


SEM_debug = "off"; // Valid values: "off", "log" and "full" or 0, 1 and 2.
/*Debug settings explained:

	0 or "off"	= Debug is off
		- This is the default setting.
	
	1 or "log"	= Only additional logging is active.
		- For debugging and proper error reports, please activate this!
		- Any RPT submitted for bug reports with debug off will be ignored!

	2 or "full"	= Many settings are changed + additional logging is active.
		- Missions time out after 10min.
		- Minimum players is set to 0 (for both static and dynamic missions).
		- Time between missions is 30sec.
		- Mission clean up happens after 2min.
		- AI only takes damage from below 100m.
		- More events and additional data is logged to the .rpt.
*/

/* DO NOT EDIT BELOW THIS LINE */
/**/SEM_config_loaded = true;/**/