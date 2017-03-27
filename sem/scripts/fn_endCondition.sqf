/*
	EMS Mission end condition
	
	_return = [_pos,_units,_start,_timeout,[_obj1,_obj2,_obj3]]call SEM_fnc_endCondition;
	
	Returns:
	 0 = false (default when no condition is met)
	 1 = time is up and no player is nearby
	 2 = All objects (vehicles) are destroyed
	 3 = AI is dead
	
*/
private["_pos","_units","_start","_timeOut","_missionID","_objects","_return","_playerPresent"];

_pos = _this select 0;
_units = _this select 1;
_start = _this select 2;
_timeOut = _this select 3;
_missionID = _this select 4;
if (count _this > 5) then {
	_objects = _this select 5
}
else {
	_objects = []
};


_return = 0;
_playerPresent = false;

if (_timeOut > 0) then { //Mission time out possible
	if (time - _start > _timeOut) then { //Time is up
		/* Check for players in the area */
		{ 
			uisleep 0.1;
			if(isPlayer _x && _x distance _pos < (500 max SEM_AIsniperDamageDistance)) exitwith {
				_playerPresent = true
			};
		} forEach (if(isMultiplayer)then[{allplayers},{allUnits}]);
		if (!_playerPresent) then {_return = 1};
	};
};

if (_return < 1 && count _objects > 0) then {
	if ({alive _x}count _objects == 0) then {
		_return = 2
	};
};
	
if (_return < 2) then {
	if({alive _x} count _units < 1)then{
		_return = 3
	};
};

if (_return < 3) then{
	{
		if(_x isKindOf "Car" || _x isKindOf "tank")then{
			_y = _x;
			{
				if(isPlayer _x && alive _x) exitWith {
					_return = 3
				}
			} count crew _y;
		};
	}forEach _objects;
};

_return
