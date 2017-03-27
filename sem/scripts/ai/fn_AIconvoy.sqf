	/* KiloSwiss */
private["_group","_endPos","_missionID","_mainVehicle","_convoyVehicles","_enterableVehicles","_convoyGrps","_ranks","_side","_vehiclePos","_vehFrontPos","_veh1","_veh2","_veh3","_start"];

_group = _this select 0;
_endPos = _this select 1;
_missionID = _this select 2;
_mainVehicle = _this select 3;
_convoyVehicles = _this select 4;
_enterableVehicles = _this select 5;

	/* Marker position update */
_this spawn {	private["_endPos","_missionID","_mainVehicle","_oldPos","_newPos"];
	_endPos = _this select 1;
	_missionID = _this select 2;
	_mainVehicle = _this select 3;
	_oldPos = position _mainVehicle;
	
	while{alive _mainVehicle && _mainVehicle distance _endPos > 50}do{
		UIsleep 10;
		_newPos = position _mainVehicle;
		if(_oldPos distance _newPos > 10)then{
			_oldPos = _newPos;
			SEM_updateMissionMarkerPos = [_missionID, _newPos];
			SEM_updateMissionMarkerPos call SEM_client_updateMissionMarkerPos;
		};
	};
};

_units = (units _group);
_side = side (_units select 0);
_startPos = getPos _mainVehicle;

_vehFront = (if(count _convoyVehicles == 1)then[{_mainVehicle},{{if(_x != _mainVehicle)exitWith{_x}; (_convoyVehicles select 0)}count _convoyVehicles}]);

{
	_x setVariable ["AIskill",(skill _x)]
} count _units;

_ranks = ["COLONEL","MAJOR","CAPTAIN","LIEUTENANT","SERGEANT","CORPORAL","PRIVATE"];
{
	_x setFuel 1;
	_x setDamage 0;
	_group addVehicle _x;
	if (_x in _enterableVehicles) then {
		_x lock 0
	}
	else {
		_x lock 3
	};
	_x setVariable ["AIrank", (_ranks select (_forEachIndex min (count _ranks -1)))];

	_x addEventHandler ["getIn",{
		(_this select 2) setUnitRank ((_this select 0) getVariable ["AIrank","PRIVATE"]);
		if((_this select 1) == "driver")then{
			(_this select 2) setSkill 1;
		};
	}];

	_x addEventHandler ["getOut",{
		(_this select 2) setSkill ((_this select 2) getVariable ["AIskill",0.7]);
	}];

	_x addeventHandler ["handleDamage",{
		if(isNull (_this select 3))then{false};
	}];

		// Fill driver seats first
	(_units select _forEachIndex) assignAsDriver _x;

	if(_x emptyPositions "GUNNER" > 0)then{	// Assign a gunner
		_x allowCrewInImmobile true; //allow gunner to stay in immobilized vehicle
		(_units select (_forEachIndex + (count _convoyVehicles))) assignAsGunner _x;
	};

}forEach _convoyVehicles; 

//Order all Units to get in
_units allowGetIn true;
_units orderGetIn true;

//Wait until every unit has boarded a vehicle
_start = time;
waitUntil {
	uisleep 1;
	{
		(alive _x && vehicle _x == _x)
	} count _units == 0 || time - _start >= 30
};

if({alive _x && vehicle _x == _x}count _units > 0)then{
	{	/* Move stuck AI into vehicles */
	if(vehicle _x == _x)then{
		_y = _x;
		{	/* Fill driver/gunner seats first */
		if(_x emptyPositions "DRIVER" > 0)exitWith{_y moveInDriver _x; _y setSkill 1};
		if(_x emptyPositions "GUNNER" > 0)exitWith{_y moveInGunner _x};
		}forEach _convoyVehicles;
		{	/* Fill cargo seats */
		if(_x emptyPositions "CARGO" > 0)exitWith{_y moveInCargo _x};
		}forEach (_convoyVehicles - [_mainVehicle]);
	};
	_x  setUnitRank ((vehicle _x) getVariable ["AIrank","PRIVATE"]);
	}forEach _units;
};

//-- Get lowest TopSpeed from all vehicles
_topSpeeds = [];
{
	_maxSpd = getNumber (configFile >> "cfgVehicles" >> typeOf _x >> "maxSpeed");
	if(!isNil "_maxSpd")then{_topSpeeds pushBack _maxSpd};
}forEach _convoyVehicles;

_select = 0;
_maxSpd = _topSpeeds select _select;
while{{_maxSpd > _x}count _topSpeeds != 0}do{
	_select = _select + 1;
	_maxSpd = _topSpeeds select _select;
};
{_x forceSpeed (_maxSpd*0.8)*0.2777778}forEach _convoyVehicles; // m/s
//DEBUG
if(SEM_debug in ["log","full"])then{diag_log format["SEM DEBUG: Convoy Vehicles TopSpeeds: %1 - Selected lowest: %2", _topSpeeds, _maxSpd]};

//_group move _endPos;
{driver _x move _endPos}count _convoyVehicles;
_group setSpeedMode "FULL";//"FULL";
_group setBehaviour "SAFE"; //"CARELESS";
_group setCombatMode "GREEN";
_group setFormation "COLUMN";

uisleep 30;

	/* temporary definition of 3 vehicles */	
_veh1 = _convoyVehicles select 0;
_veh2 = _convoyVehicles select 1;
_veh3 = _convoyVehicles select 2;

_lastMoveCheck = time;
_oldPos = getPos _mainVehicle;

	/* Convoy loop */
_stayToDefend = true;
while{{_x distance _endPos < 20}count _convoyVehicles < 1}do{	//CONVOY LOOP

_vehiclePos = getPos _mainVehicle;
_vehFrontPos = getPos _vehFront;

if({!canMove _x}count _convoyVehicles > 0 && _stayToDefend)then{
		{if(canMove _x)then{(driver _x) doMove _vehiclePos}}forEach _convoyVehicles;
		sleep 5;
		{
		if(_x distance _vehiclePos < 50)then[{
			if(_x != gunner (vehicle _x))then{
				_x action ["GetOut", (vehicle _x)];
				sleep 0.5;
				[_x] orderGetIn false;
				[_x] allowGetIn false;
				_x doMove _vehiclePos;
			};
		},{
			_x doMove _vehiclePos;
		}];
		}forEach units _group;
		_group move _vehiclePos;
		_group setSpeedMode "FULL";
		
		if({_x distance _veh2 < 50}count units _group == count units _group)then{
			_endPos = _vehiclePos;
		};
}
else{
	//-- Work In Progress!

	if({alive _x && !(vehicle _x in _convoyVehicles)}count units _group > 0)then{ //AI has left the vehicle
		_group setBehaviour "CARELESS";
		_group setCombatMode "GREEN";
		{
		if(!(vehicle _x in _convoyVehicles))then{
			[_x] allowGetIn true;
			[_x] orderGetIn true;
		};
		}forEach units _group;
		uisleep 10;	//Brake the loop for 10 seconds
		_group move _endPos;
		
	}
	else{ //Do vehicle speed management and continue travel to destination

	_group setBehaviour "SAFE";
	_group setCombatMode "GREEN";
	_group setSpeedMode "FULL";
	
	if(time - _lastMoveCheck > 60)then{
		_group move _endPos;
		_lastMoveCheck = time;
		if(_vehiclePos distance _oldPos < 30)then {
			//FAILSAFE IF CONVOY IS STUCK
			{
				driver _x doMove _endPos
			} count _convoyVehicles;
			sleep 20;
			if(_vehiclePos distance _oldPos < 10)then{
				_endPos = _vehiclePos;
			};
		}
		else {
			_group move _endPos
		};
		_oldPos = getPos _mainVehicle;
		_group move _endPos;
	};

	//Speed Management for Vehicle 1
	if(_veh1 distance _veh2 > 80 || _veh1 distance _veh3 > 120)then{
		if(_veh1 distance _veh2 > 90 || _veh1 distance _veh3 > 130)then{
			_veh1 limitSpeed 0;
		}else{
			if(speed _veh3 < 10)then{
				_veh1 limitSpeed (1 max (speed _veh3));
			}else{
				_veh1 limitSpeed (_maxSpd*0.4);
			};
		};
	}else{
		if(speed _veh3 < 10)then{
			_veh1 limitSpeed (_maxSpd*0.1);
		}else{
			_veh1 limitSpeed (_maxSpd*0.8);
		};
	};
	
	//Speed Management for Vehicle 2
	if(_veh2 distance _veh1 > 80)then{
		if(_veh2 distance _veh3 < _veh2 distance _veh1)then{
			_veh2 limitSpeed (_maxSpd*0.8);
		}
		else{
			_veh2 limitSpeed _maxSpd;
		};
	}else{
		if(_veh2 distance _veh1 < 50)then{
			_veh2 limitSpeed (1 max (speed _veh1));
		}
		else{
			if(_veh2 distance _veh3 > _veh2 distance _veh1)then{
				_veh2 limitSpeed (_maxSpd*0.5);
			}
			else{
				_veh2 limitSpeed (_maxSpd*0.8);
			};
		};
	};

	//Speed Management for Vehicle 3
	if(_veh3 distance _veh2 > 80 || _veh3 distance _veh1 > 150)then{
		if(_veh3 distance _veh2 < 40)then{
			_veh3 limitSpeed (1 max (speed _veh2));
		}else{
			_veh3 limitSpeed _maxSpd;
		};
	}else{
		if(_veh3 distance _veh2 < 40)then{
			_veh3 limitSpeed (1 max (speed _veh2));
		}
		else{
				_veh3 limitSpeed (_maxSpd*0.8);
		};
	};
	};
};

//code to end the while
_unitsAlive = ({alive _x}count units _group);
if(_unitsAlive < 1) then {
	_endPos = _vehiclePos;
};
if (damage _mainVehicle == 1) then {
	_endPos = _vehiclePos;
};

if({isPlayer _x && alive _x}count crew _mainVehicle > 0)then{
	doStop (units _group);
	{
	_x spawn{
		_this action ["engineOff", (vehicle _this)];
		sleep 0.5;
		deleteVehicle _this;
	};
	}foreach units _group;
	_endPos = _vehiclePos;
};

uisleep 1;
}; 
//END OF LOOP


if ({alive _x}count units _group > 0 && damage _mainVehicle < 1) then {
	_group move _vehiclePos;
	uisleep 10;
	{
		if(_x != gunner (vehicle _x))then{
			[_x,_vehiclePos] spawn{
				private "_unit";
				_unit = _this select 0;
				doStop _unit;
				uisleep 1;
				_unit action ["engineOff", (vehicle _unit)];
				_unit action ["GetOut", (vehicle _unit)];
				unassignVehicle _unit;
				sleep 0.1;
				[_unit] orderGetIn false;
				[_unit] allowGetIn false;
			};
		};
	} forEach (units _group);

	_group move _vehiclePos;
	_group setBehaviour "AWARE";
	_group setFormation "FILE";
	_group setCombatMode "YELLOW";
	[_group, _vehiclePos] call SEM_fnc_AImove;
};
