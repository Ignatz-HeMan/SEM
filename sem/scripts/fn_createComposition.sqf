/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/

_script = _this select 0;
_azi 	= _this select 1;
_pos 	= _this select 2;

_objs = [];
_objs = call (compile (preprocessFileLineNumbers format [SEM_staticMissionsPath + "compositions\%1.sqf",_script]));
private ["_posX", "_posY"];

_anchorBldg = _objs select 0;
_xShift = (_anchorBldg select 1) select 0;
_yShift = (_anchorBldg select 1) select 1;
_zShift = (_anchorBldg select 1) select 2;
{
	(_x select 1) set [0,((_x select 1 select 0) - _xShift)];
	(_x select 1) set [1,((_x select 1 select 1) - _yShift)];                                                                
	(_x select 1) set [2,(_x select 1 select 2)];
} forEach _objs;

_posX = _pos select 0;
_posY = _pos select 1;
_newObjs = [];
private ["_multiplyMatrixFunc"];
_multiplyMatrixFunc =
{
	private ["_array1", "_array2", "_result"];
	_array1 = _this select 0;
	_array2 = _this select 1;
	_result =
	[
	(((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),
	(((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))
	];
	_result
};
for "_i" from 0 to ((count _objs) - 1) do
{
		private ["_obj", "_type", "_relPos", "_azimuth", "_fuel", "_damage", "_newObj"];
		_obj = _objs select _i;
		_type = _obj select 0;
		_relPos = _obj select 1;
		_azimuth = _obj select 2;
						
		private ["_rotMatrix", "_newRelPos", "_newPos"];
		_rotMatrix =[[cos _azi, sin _azi],[-(sin _azi), cos _azi]];
		_newRelPos = [_rotMatrix, _relPos] call _multiplyMatrixFunc;
		private ["_z"];
		if ((count _relPos) > 2) then {
			_z = _relPos select 2
		} 
		else {
			_z = 0
		};
		_newPos = [_posX + (_newRelPos select 0), _posY + (_newRelPos select 1), _z];
		_newObj = createVehicle [_type, _newPos, [], 0, "CAN_COLLIDE"];
		_newObj setDir (_azi + _azimuth);
		if (surfaceiswater _newPos) then {
			_newObj setPosASL _newPos;
		}
		else {
			_newObj setPosATL _newPos;
		};
		_newObj allowdamage false;
		if !(_type in ["Box_NATO_AmmoVeh_F","Land_MetalCase_01_large_F"]) then {
			if !(_newObj iskindof "house" || _newObj iskindof "Landvehicle" || _newObj iskindof "SHIP" || _newObj iskindof "AIR" || _newObj iskindof "TANK" || _newObj iskindof "StaticWeapon") then {
				_newObj enablesimulationglobal false;
			};
		};
		
		if (count _obj > 3) then {
			if (typename (_obj select 3) == "ARRAY") then {
//				_newObj setvectordirandup (_obj select 3);
			};
			if (typename (_obj select 3) == "STRING") then {
				_newObj call compile format ["%1",(_obj select 3)];
			};
			if (typename (_obj select 3) == "SCALAR") then {
				_newObj setFuel (_obj select 3);
			};
		};
		if (count _obj > 4) then {
			if (typename (_obj select 4) == "STRING") then {
				_newObj call compile format ["%1",(_obj select 4)];
			};
			if (typename (_obj select 4) == "SCALAR") then {
				_newObj setDamage (_obj select 4);
			};
		};
		if (count _obj > 5) then {
			if (typename (_obj select 5) == "STRING") then {
				_newObj call compile format ["%1",(_obj select 5)];
			};
		};
		_newObjs pushBack _newObj;	
};

_newObjs
