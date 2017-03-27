	/* KiloSwiss */
private["_veh","_saveEH"];

_veh = _this;

if(SEM_permanentVehicles)then[{
	
	if({isPlayer _x}count (crew _veh) > 0)exitWith{
		_veh setVariable ["saveEH",-1];
		_veh call SEM_fnc_saveVehicle;
	};

	_saveEH = _veh addEventHandler ["getIn", {
		if(isPlayer (_this select 2))then{
			(_this select 0) removeEventHandler ["getIn", ((_this select 0) getVariable ["saveEH",0])];
			(_this select 0) setVariable ["saveEH",-1];
			(_this select 0) call SEM_fnc_saveVehicle;
		};
	}];
	_veh setVariable ["saveEH",_saveEH];
	_veh lock 0;

	_veh spawn{ private ["_start","_vehicle"];
		_vehicle = _this;
		_start = time;
		waitUntil{ sleep 30;
			((time - _start > 1800) || (_vehicle getVariable ["saveEH",0] < 0))
		};
		if((_vehicle getVariable ["saveEH",0]) >= 0)then{_vehicle setDamage 1};
	};
},{
	_veh lock 0;
}];

true
