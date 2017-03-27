/*
	Detect Threads in form of players.
	
	Update 03.01.2015
	KiloSwiss
*/
/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/

_this spawn {
	diag_log format["#SEM DEBUG: 1st Find Thread"];
	private["_group","_pos","_units","_checkPos","_possibleThreads","_z"];
	_group = _this select 0;
	_pos = _this select 1;
	_checkPos = _pos; _checkPos set [2,2];
	_units = units _group;
	{
		[_x, true] call SEM_fnc_AIdamageEH
	} count _units;
	{
		_group reveal [_x,4];
	} foreach (nearestobjects [_pos,[],50]);

	while {{alive _x}count units _group > 0} do {
		waitUntil {
			uisleep 5;
			_possibleThreads = [];	//Check if any thread for the AI has been detected
			//Check if any AI is shot by player
			{
				if (!isnull _x) then {
					_attackervar = _x getVariable ["gotHitBy", Nil];
					if (!isNil "_attackervar") then {
						_attacker = _attackervar select 0;
						_attacktime = _attackervar select 1;
						if (isPlayer _attacker && !(_attacker in _possibleThreads)) then {
							if ((time - _attacktime) < 150) then {
								_possibleThreads pushBack _attacker;
								diag_log format["#SEM DEBUG: Attacker: %1",_attacker];
							}
							else {
								_x setVariable ["gotHitBy", Nil]
							};
						};
					};
				};
			} forEach _units;	//Do NOT replace forEach with count!
			//Check if any players are near
			{
				uisleep 0.1;
				if (isPlayer _x && alive _x && !(_x in _possibleThreads)) then {
					if (_x isKindOf "Epoch_Man_base_F" || _x isKindOf "Epoch_Female_base_F") then {
						_possibleThreads pushBack _x
					}
					else {
						_z = _x;
						if (count crew _z > 0) then {
							{
								if (isPlayer _x) then {
									_possibleThreads pushBack _x
								};
							} forEach crew _z;
						};
					};
				};
			} forEach (_pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F","Helicopter","Car","Motorcycle"], 500]); //Do NOT replace forEach with count!
			
			(count _possibleThreads > 0)
		};
			/* Thread has been detected */
		if(SEM_debug in ["log","full"])then{
			diag_log format["#SEM DEBUG: Possible threads: %1", _possibleThreads]
		};
			
			/* AI react immediately */
		{
			_group reveal [_x,2]
		} count _possibleThreads; //Reveal threads
	}; //End of while loop
};