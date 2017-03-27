class CfgPatches {
	class SEM {
		units[] = {};
		weapons[] = {};
		SEM_version = 0.8.3;
		requiredVersion = 1.38;
		requiredAddons[] = {"a3_epoch_server"};
	};
};

class CfgFunctions {
	class SEM {
		class main {
			file = "sem";
			class semInit {
				//preInit = 1;
				postInit = 1;
			};
		};

		class SEM_scripts
		{
			file = "sem\scripts";
			class createComposition {};
			class getWorldData {};
			class missionController {};
			class missionCleanup {};
			class findMissionPos {};
			class selectMission {};
			class selectClosest {};
			class endCondition {};
			class spawnVehicle {};
			class vehicleUnlock {};
			class saveVehicle {};
			class convoyRoute {};
			class attachToVeh {};
			class safeDetach {};
			class emptyGear {};
			class randomPos {};
			class crateLoot {};
		};
		
		class SEM_AIscripts
		{
			file = "sem\scripts\ai";
			class spawnAI {};
			class stripUnit {};
			class removeGear {};
			class findThread {};
			class AIactDeact {};
			class AIsetOwner {};
			class AIdamageEH {};
			class AIkilledEH {};
			class AIfiredEH {};
			class broadcastAI {};
			class AImove {};
			class AIconvoy {};
		};
	};
};