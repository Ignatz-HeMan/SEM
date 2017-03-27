	/* KiloSwiss */
private["_group","_endPos","_missionID","_mainVehicle","_convoyVehicles","","","","",""];

_group = _this select 0;
_endPos = _this select 1;
_missionID = _this select 2;
_mainVehicle = _this select 3;
_convoyVehicles = _this select 4;

	/* Marker position update */
_this spawn {	private["_endPos","_missionID","_mainVehicle","_oldPos","_newPos"];
	_endPos = _this select 1;
	_missionID = _this select 2;
	_mainVehicle = _this select 3;
	_oldPos = position _mainVehicle;
	
	while{alive _mainVehicle && _mainVehicle distance _endPos > 20}do{
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
_startPos = getPos _mainVehicle;
{_group addVehicle _x; _x lock 3}forEach _convoyVehicles;

_vehFront = (if(count _convoyVehicles == 1)then[{_mainVehicle},{{if(_x != _mainVehicle)exitWith{_x}; (_convoyVehicles select 0)}count _convoyVehicles}];
_ranks = ["COLONEL","MAJOR","CAPTAIN","LIEUTENANT","SERGEANT","CORPORAL","PRIVATE"];
_convoyGrps = [];
{	
	_x setVariable ["AIrank", (_ranks select (_forEachIndex min (count _ranks -1)))];
	_x addEventHandler ["getIn",{ private "_unit";
		_unit = _this select 2;
		_unit setUnitRank (_this select 0 getVariable ["AIrank","PRIVATE"]);
		_unit joinSilent (format ["_convoy%1Grp%2", _missionID, _forEachIndex]);
	}];
	call compile format["
		_convoy%1Grp%2 = createGroup (side %3);
		_convoyGrps pushBack _convoy%1Grp%2;
	", _missionID, _forEachIndex, _group];
	
	//assign at least one driver per vehicle
	(_units select _forEachIndex) assignAsDriver _x;
	(_units select _forEachIndex) moveInDriver _x;

}forEach [_vehFront, _mainVehicle] + [(_convoyVehicles - [_vehFront,_mainVehicle])];

//Order all Units to get in
_units allowGetIn true;
_units orderGetIn true;

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
{_x forceSpeed (_maxSpd*0.7)*0.2777778}forEach _convoyVehicles; // m/s
//DEBUG
if(SEM_debug in ["log","full"])then{diag_log format["SEM DEBUG: Convoy Vehicles TopSpeeds: %1 - Selected lowest: %2", _topSpeeds, _maxSpd]};


//Wait until every unit has boarded a vehicle
waitUntil{sleep 1; {vehicle _x in _convoyVehicles}count (units _group) == 0};



/*
_unit1 = units _group select (count units _group -1); 
_unit1 assignAsDriver _veh;
[_unit1] orderGetIn true;
*/

_group move _endPos;
_group setSpeedMode "NORMAL";//"FULL";
_group setBehaviour "SAFE"; //"CARELESS";
_group setCombatMode "GREEN";
_group setFormation "FILE";





_lastMoveCheck = time;
_oldPos = getPos _vehFront;


	/* Convoy loop */
_stayToDefend = true;
while {_mainVehicle distance _endPos >= _distance} do {	//CONVOY LOOP

_vehiclePos = getPos _mainVehicle;
_vehFrontPos = getPos _vehFront;

if({!canMove _x}count _convoyVehicles > 0 && _stayToDefend)then{
		{if(canMove _x)then{(driver _x) doMove _vehiclePos;};}forEach _convoyVehicles;
		sleep 5;
		{
		if(_x distance _vehiclePos < 50)then{
			if(_x != gunner (vehicle _x))then{
				_x action ["GetOut", (vehicle _x)];
				sleep 0.5;
				[_x] orderGetIn false;
				[_x] allowGetIn false;
				_x doMove _vehiclePos;
			};
		}else{
			_x doMove _vehiclePos;
		};
		}forEach units _group;
		_group move _vehiclePos;
		_group setSpeedMode "FULL";
		
		if({_x distance _veh2 < 50}count units _group == count units _group)then{
			_endPos = _vehiclePos;
		};
}else{
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
		sleep 10;	//Brake the loop for 10 seconds
		_group move _endPos;
		_group setSpeedMode "NORMAL";
		
	}else{ //Do vehicle speed management and continue travel to destination

	_group setBehaviour "SAFE";
	_group setCombatMode "GREEN";
	_group setFormation "COLUMN";
	
	if(time - _lastMoveCheck > 30)then{
		_lastMoveCheck = time;
		if(_vehFrontPos distance _oldPos < 10)then{
			//FAILSAFE IF CONVOY IS STUCK
			_group move _endPos;
			_group setSpeedMode "FULL";
			sleep 10; //Brake the loop for 10 seconds
			_group setSpeedMode "NORMAL";
		};
		_oldPos = getPos _vehFront;
	};

	//-- Distance Checks
	// forceSpeed = m/s
	// limitSpeed = km/h
	// 1 km/h == ~0.2777778 m/s

	//Check Formation
	_distanceA = _veh1 distance _veh2;
	_distanceB = _veh1 distance _veh3;
	if(_distanceA > _distanceB)then{
		_3inFrontOf2 = [_veh2, _veh3, 0] call BIS_fnc_isInFrontOf;
		if(_3inFrontOf2 || abs(_distanceA - _distanceB) > 10)then{//Swap Vehicles position in convoy (2 <-> 3)
			//diag_log format["A: Distance 1-2: %1 - Distance 1-3: %2", round (_veh1 distance _veh2), round (_veh1 distance _veh3)];
			_vehinMiddle = _veh3;
			_veh3 = _veh2;
			_veh2 = _vehinMiddle;
			//diag_log format["B: Distance 1-2: %1 - Distance 1-3: %2", round (_veh1 distance _veh2), round (_veh1 distance _veh3)];
		};
	};
	
	//Speed Management for Vehicle 1
	if(_veh1 distance _veh2 > 50 || _veh1 distance _veh3 > 80)then{
		if(_veh1 distance _veh2 > 80 || _veh1 distance _veh3 > 120)then{
			_veh1 forceSpeed (_maxSpd*0.1)*0.2777778;
			_veh1 limitSpeed (_maxSpd*0.1);
		}else{
			if(speed _veh3 < 10)then{
				_veh1 forceSpeed (speed _veh3)*0.2777778;
				_veh1 limitSpeed (speed _veh3);
			}else{
				_veh1 forceSpeed (_maxSpd*0.4)*0.2777778;
				_veh1 limitSpeed (_maxSpd*0.4);
			};
		};
	}else{
		if(speed _veh3 < 10 && _veh1 distance _veh3 > 30)then{
			_veh1 forceSpeed (_maxSpd*0.1)*0.2777778;
			_veh1 limitSpeed (_maxSpd*0.1);
		}else{
			_veh1 forceSpeed (_maxSpd*0.7)*0.2777778; //-- m/s
			_veh1 limitSpeed (_maxSpd*0.7);
		};
	};
	
	//Speed Management for Vehicle 2
	if(_veh2 distance _veh1 > 40)then{
		if(_veh2 distance _veh3 > _veh2 distance _veh1)then{ //let Vehicle3 catch up
			_veh2 forceSpeed (_maxSpd*0.4)*0.2777778;
			_veh2 limitSpeed (_maxSpd*0.4);
		}else{
			if(speed _veh1 < 10)then{ //FAILSAFE IF CONVOY IS STUCK
				(driver _veh2) doMove (getPos _veh1);
				_veh2 forceSpeed (_maxSpd*0.7)*0.2777778;
				_veh2 limitSpeed (_maxSpd*0.7);
			}else{
				//Move faster to catch up with Vehicle1
				_veh2 forceSpeed _maxSpd*0.2777778;
				_veh2 limitSpeed _maxSpd;
			};
		};
	}else{
		if(_veh2 distance _veh1 < 20)then{
			_veh2 forceSpeed (speed _veh1)*0.2777778;
			_veh2 limitSpeed (speed _veh1);
		}else{
			_veh2 forceSpeed (_maxSpd*0.7)*0.2777778;
			_veh2 limitSpeed (_maxSpd*0.7);
		};
	};

	//Speed Management for Vehicle 3
	if(_veh3 distance _veh2 > 30 || _veh3 distance _veh1 > 60)then{ //catch up
		_veh3 forceSpeed _maxSpd*0.2777778;
		_veh3 limitSpeed _maxSpd;
	}else{
		if(_veh3 distance _veh2 < 15 && speed _veh2 > 5)then{
			_veh3 forceSpeed (speed _veh2)*0.2777778;
			_veh3 limitSpeed (speed _veh2);
		}else{
			if(speed _veh1 < 10)then{ //FAILSAFE IF CONVOY IS STUCK
				(driver _veh3) doMove (getPos _veh1);
				_veh3 forceSpeed (_maxSpd*0.7)*0.2777778;
				_veh3 limitSpeed (_maxSpd*0.7);
			}else{
				_veh3 forceSpeed (_maxSpd*0.7)*0.2777778;
				_veh3 limitSpeed (_maxSpd*0.7);
			};
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

sleep 1;
}; //END OF LOOP

diag_log "Dynamic Mission Status: Convoy Ended";

if({alive _x}count units _group > 0 && damage _mainVehicle < 1)then{
	{if(canMove _x)then{(driver _x) doMove _vehiclePos;};}forEach _convoyVehicles;
	sleep 10;
	{
	if(_x != gunner (vehicle _x))then{
		_x spawn{
			doStop _this;
			sleep 1;
			_this action ["engineOff", (vehicle _this)];
			_this action ["GetOut", (vehicle _this)];
			sleep 0.1;
			[_this] orderGetIn false;
			[_this] allowGetIn false;
			_this doMove _vehiclePos;
		};
	};
	}forEach units _group;
	_group move _vehiclePos;
	_group setBehaviour "AWARE";
	_group setFormation "FILE";
	_group setCombatMode "YELLOW";
};



