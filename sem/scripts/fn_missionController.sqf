private["_this","_x","_forEachIndex"];


{
	[_x,_forEachIndex] spawn { 
		private["_missionsArr","_missionPath","_missionType","_lastMission","_playerOnline","_minPlayers","_randomMission","_runningMission","_runningMissionID","_missionStart","_missionTime","_missionPos","_markerPos"];
		_missionsArr = _this select 0 select 0;
		_missionPath = _this select 0 select 1;
		_missionType = _this select 0 select 2;
		_minPlayers = (	switch(_missionType)do{
							case "static":	{SEM_MinPlayerStatic};
							case "dynamic":	{SEM_MinPlayerDynamic};
							default	{1};
						});

						
		for "_i" from 0 to (count _missionsArr -1) step 1 do{	// Remove inactive missions
			if((_missionsArr select _i) select 3 < 1)then[{_missionsArr set [_i, "delete"]},{
				if(((_missionsArr select _i) select 2) > 0)then{
					(_missionsArr select _i) set [2, (((_missionsArr select _i) select 2) * 60)];
				};
			(_missionsArr select _i) set [3, 1 max ((_missionsArr select _i) select 3) min 100];
			}];
		};	_missionsArr = _missionsArr - ["delete"];				
		
		if(SEM_debug isEqualTo "full")then{
			{
				_x set [2, (10*60)]
			}forEach _missionsArr
		};	// Set mission time out to 10
		
		_lastMission = "";
		while {true} do {
			_playerOnline = playersNumber civilian;
			if (SEM_debug in ["log","full"]) then {
				diag_log format["#SEM DEBUG: Online players: %1", playersNumber civilian]
			};
			if (_playerOnline < _minPlayers || _playerOnline > SEM_MaxPlayers) then {
				diag_log format ["#SEM: Waiting for players (%1/%2) to start %3 Missions", _playerOnline, _minPlayers, _missionType];
				waitUntil {
					uisleep 5; 
					if(playersNumber civilian != _playerOnline) then {
						_playerOnline = playersNumber civilian;
						diag_log format ["#SEM: Waiting for players (%1/%2) to start %3 Missions", _playerOnline, _minPlayers, _missionType];
					};
					(_playerOnline >= _minPlayers && _playerOnline <= SEM_MaxPlayers)
				};
			diag_log format ["#SEM: Online players: (%1/%2) - Starting next %3 Mission", _playerOnline, _minPlayers, _missionType];
			};

			_start = time;
			if (SEM_debug isEqualTo "full") then {
				uisleep 10
			}
			else {
				if (!isnil "SEM_TimerStart") then {
					_wait = SEM_TimerStart*60;
					waitUntil {uisleep 1; (time - _start) >= _wait};
					SEM_TimerStart = nil;
				}
				else {
					_wait = SEM_MissionTimerMin*60 + random(SEM_MissionTimerMax*60-SEM_MissionTimerMin*60);
					waitUntil {uisleep 1; (time - _start) >= _wait};
				}
			};

			_randomMission = [_missionsArr, _lastMission] call SEM_fnc_selectMission;
			_lastMission = _randomMission select 0;
			
			if (_missionType == "static")then{
				_missionPos = [] call SEM_fnc_findMissionPos;
				SEM_lastMissionPositions pushBack _missionPos
			};
			if (_missionType == "dynamic") then {
				_missionPos = [] call SEM_fnc_convoyRoute;
				{
					SEM_lastMissionPositions pushBack _x
				} forEach _missionPos
			};
			
			SEM_MissionID = SEM_MissionID + 1;
			_runningMissionID = SEM_MissionID;
			_runningMission = [_missionPos, _randomMission, _runningMissionID, _missionType] execVM format["%1%2.sqf", _missionPath, _randomMission select 0];
			_missionStart = time;
			
			diag_log format ["#SEM: Start %1 mission %2: %3 %4.", _missionType, _runningMissionID, str(_randomMission select 1), 
				if (_missionType == "static") then {
					"at position " + str(_missionPos)
				}
				else {
					"from position " + str(_missionPos select 0) + " to " + str(_missionPos select 1)
				}
			];

			if (_missionType == "static") then {
				_markerPos = _missionPos call SEM_fnc_randomPos
			}
			else {
				_markerPos = _missionPos select 0
			};
			SEM_globalMissionMarker = [true,_markerPos,_runningMissionID,_randomMission select 1, _randomMission select 4, _missionType];
			SEM_globalMissionMarker call SEM_createMissionMarker;
			
			waitUntil {uisleep 1; scriptDone _runningMission};
			_missionTime = (time - _missionStart);
			diag_log format["#SEM: Finished %1 mission %2: %3 after %4.", _missionType, _runningMissionID, str(_randomMission select 1), str(floor (_missionTime/60)) + "m " + str(_missionTime-(floor(_missionTime/60)*60)) + "s"];
		};
	};
	if (SEM_debug isEqualTo "full") then {
		uisleep 10
	}
	else {
		uisleep 180
	};
}forEach _this;