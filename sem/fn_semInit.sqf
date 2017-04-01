/*
	SEM - "Simple Epoch Missions" configuration file
	By KiloSwiss
*/
/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/
[] spawn {
	diag_log "#SEM INIT: Waiting for Epoch Server Ready ...";
	waituntil {!isnil "EPOCH_SERVER_READY"};
	diag_log "#SEM INIT: Epoch Server is ready... SEM waiting more 10s to start ...";
	uisleep 10;
	diag_log "#SEM INIT: Initialize Simple Epoch Missions";

	private ["_handle","_end"];
	_handle = execVM "sem\sem_config.sqf";
	waitUntil {isNull _handle};
	diag_log "#SEM: Loaded settings.";

	if ((typeName SEM_debug) isEqualTo "SCALAR") then {
		SEM_debug = (switch(round SEM_debug)do{
			case 0:{"off"};
			case 1:{"log"};
			case 2:{"full"};
			default{"log"};
		});
	};
	if !(SEM_debug in ["off","log","full"]) then {
		SEM_debug = "log"
	};

	if (SEM_debug in ["log","full"]) then{
		SEM_version = getText(configFile >> "CfgPatches" >> "sem" >> "SEM_version");
		diag_log format ["#SEM Version %1 is running on %2 %3 version %4 [%5] %6 branch.",
		SEM_version,
		(productVersion select 1),
		str(if(isDedicated)then[{"dedicated server"},{if(hasInterface)then[{if(isServer)then[{"localhost"},{"client"}]},{"headless client"}]}]),
		str(floor((productVersion select 2)/100)) + "." + str((productVersion select 2)-((floor((productVersion select 2)/100))*100)),
		str(productVersion select 3),
		(productVersion select 4)];
	};

		/* Set up variables */

	SEM_MinPlayerStatic = (if(isMultiPlayer)then[{1 max SEM_MinPlayerStatic},{0}]);
	SEM_MinPlayerDynamic = (if(isMultiPlayer)then[{1 max SEM_MinPlayerDynamic},{0}]);
	SEM_MissionTimerMin = 1 max SEM_MissionTimerMin;
	SEM_MissionTimerMax = 1 max SEM_MissionTimerMax;
	SEM_MissionCleanup = -1 max SEM_MissionCleanup;
	if(SEM_MissionTimerMin > SEM_MissionTimerMax)then{
		private "_tempValueHolder";
		_tempValueHolder = SEM_MissionTimerMax;
		SEM_MissionTimerMax = SEM_MissionTimerMin;
		SEM_MissionTimerMin = _tempValueHolder;
	};

	SEM_Krypto_AIroadkill = 1 max (abs SEM_Krypto_AIroadkill);

	{if !(_x in SEM_removeWeaponsFromDeadAI)then{SEM_removeWeaponsFromDeadAI pushBack _x}}forEach ["launch_RPG32_F","Srifle_GM6_F","Srifle_LRR_F","m107_EPOCH","m107Tan_EPOCH"];
	{if !(_x in SEM_removeMagazinesFromDeadAI)then{SEM_removeMagazinesFromDeadAI pushBack _x}}forEach ["RPG32_F","RPG32_HE_F","5Rnd_127x108_Mag","5Rnd_127x108_APDS_Mag","7Rnd_408_Mag"];
	SEM_AIdropGearChance = 0 max SEM_AIdropGearChance min 100;
	SEM_AIsniperDamageDistance = 300 max SEM_AIsniperDamageDistance min 1000;
	SEM_AIsniperDamageEHunits = [];

	if(SEM_debug isEqualTo "full")then{ /* Load debug settings */
		SEM_MinPlayerStatic = 0;
		SEM_MinPlayerDynamic = 0;
		SEM_MissionCleanup = 2;
		SEM_AIdisableSniperDamage = true; SEM_AIsniperDamageDistance = 100;
		[] spawn {
			SEM_version = SEM_version + " - DEBUG IS ON!";
			while{true}do{publicVariable "SEM_version"; UIsleep 180};
		};
	}else{publicVariable "SEM_version"; UIsleep 30};

	SEM_worldData = call SEM_fnc_getWorldData;
	if(SEM_debug in ["log","full"])then{diag_log format["#SEM DEBUG: World Data received. Counting %1 locations on island %2", count (SEM_worldData select 2), str worldName]};

	publicVariable "SEM_AIsniperDamageDistance";
	SEM_lastMissionPositions = [];
	SEM_MissionID = 0;

	if(hasInterface && isServer)then{waitUntil{isPlayer player}};

	SEM_createMissionMarker = {
		private ["_create","_markerPos","_markerID","_markerA","_markerB","_markerC","_markerD","_markerC_Pos","_markerName","_markerColor"];
		_create = _this select 0;
		
		//Create Marker
		if (_create) then {
			_markerPos = _this select 1;
			_markerID = _this select 2;
			_markerName = _this select 3;
			_markerColor = (	
				switch (_this select 4) do {
					case 0:	{"ColorWhite"};
					case 1:	{"ColorUNKNOWN"};
					case 2:	{"ColorOrange"};
					case 3:	{"ColorEAST"};
					case 4:	{"ColorCIV"};
					case 5:	{"ColorBlack"};
					default	{"Default"};
				}
			);
			_staticMission = (	switch(_this select 5)do{
									case "static":	{true};
									case "dynamic":	{false};
									default	{true};
								});
			
			
			if (_staticMission)then {	//Static Mission
				_markerA = createMarker [format["SEM_MissionMarkerA_%1", _markerID], _markerPos];
				_markerB = createMarker [format["SEM_MissionMarkerB_%1", _markerID], _markerPos];
				_markerC = createMarker [format["SEM_MissionMarkerC_%1", _markerID], _markerPos];
				
				{	
					_x setMarkerShape "ELLIPSE"; 
					_x setMarkerSize [500,500];
					_x setMarkerPos _markerPos
				}forEach [_markerA,_markerB];
				
				_markerA setMarkerBrush "Cross";
				_markerA setMarkerColor _markerColor;
				
				_markerB setMarkerBrush "Border";
				_markerB setMarkerColor "ColorRed";
				
				_markerC_Pos = [(_markerPos select 0) - (count _markerName * 15), (_markerPos select 1) - 530, 0];
				_markerC setMarkerShape "Icon";
				_markerC setMarkerType "HD_Arrow";
				_markerC setMarkerColor _markerColor;
				_markerC setMarkerPos _markerC_Pos;
				_markerC setMarkerText _markerName;
				_markerC setMarkerDir 37;
			}
			else {	//Dynamic Mission
				_markerD = createMarker [format["SEM_MissionMarkerD_%1", _markerID], _markerPos];
				_markerD setMarkerShape "Icon";
				_markerD setMarkerType "mil_circle";	//"HD_Destroy";
				_markerD setMarkerColor _markerColor;
				_markerD setMarkerPos _markerPos;
				_markerD setMarkerText _markerName;
			};
		}
		else {	//else delete marker
			_this spawn { 
				private ["_endCondition","_deleteMarkerID","_endMissionType"];
				_endCondition = _this select 1;
				_deleteMarkerID = _this select 2;
				_endMissionType = _this select 3;
				
				if(_endCondition == 3)then {
					{
						if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "") then {
							format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] setMarkerColor "ColorIndependent";
						};
					} forEach (
						if (_endMissionType == "static") then {
							["A","B","C"]
						}
						else {
							["D"]
						}
					);
					sleep 120;
				}
				else {
					{
						if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "")then{
							format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] setMarkerColor "ColorGrey";
						};
					} forEach (if(_endMissionType == "static")then {
							["A","B","C"]
						}
						else {
							["D"]
						}
					);
					uisleep 30;
				};
				
				{		/* Only delete existing Marker */
					if (getMarkerColor format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID] != "") then {
						deleteMarker format["SEM_MissionMarker%1_%2", _x, _deleteMarkerID];
					}
				} forEach (
					if (_endMissionType == "static") then {
						["A","B","C"]
					}
					else {
						["D"]
					}
				);
			};	
		};
	};

	SEM_client_updateMissionMarkerPos = {
		private["_updateMarkerID","_updateMarkerPos"];
		_updateMarkerID = _this select 0;
		_updateMarkerPos = _this select 1;

		if (getMarkerColor format["SEM_MissionMarkerD_%1", _updateMarkerID] != "")then{
			format["SEM_MissionMarkerD_%1", _updateMarkerID] setMarkerPos _updateMarkerPos;
		};
	};
	
	SEM_Client_VehDamage = compilefinal "
		private ['_vk','_vP','_s'];
		_vk = _this;
		_vP = vehicle player;
		if (!local _vk) exitWith {};
		if (_vk != _vP) exitWith {};
		{
			_vk setHitIndex [_forEachIndex,((_vk getHitIndex _forEachIndex)+(0.15+(random 0.15)))];
		} forEach ((getAllHitPointsDamage _vk) param [0,[]]);
	";
	SEM_Client_GlobalHint = compilefinal "
		_this spawn {
			if (isnil 'SEM_lastEvent') then {
				SEM_lastEvent = 0;
			};
			waitUntil {
				if(time - SEM_lastEvent > 20) exitwith {
					SEM_lastEvent = time;
					true
				};
				false
			};
			_sound = _this select 0;
			switch(_sound)do{
				case 0:{playSound 'UAV_05'};
				case 1:{playSound 'UAV_01'};
				case 2:{playSound 'UAV_04'};
				case 3:{playsound 'UAV_03'};
			};
			hint parseText format['%1', _this select 1];
		};
	";
	publicvariable 'SEM_Client_VehDamage';
	publicvariable 'SEM_Client_GlobalHint';
	
	[
		[SEM_staticMissions, SEM_staticMissionsPath ,"static"],
		[SEM_dynamicMissions, SEM_dynamicMissionsPath ,"dynamic"]
	] call SEM_fnc_missionController;
};