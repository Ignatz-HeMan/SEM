	/* KiloSwiss */
_this spawn { 
	private ["_pos","_objs","_sGren"];
	_pos = _this select 0;
	_objs = _this select 1;

	uisleep (SEM_MissionCleanup *60);
	
	for "_i" from 30 to 360 step 30 do {
		private ["_dist","_posX","_posY","_sGren"];
		_dist = (10+(random 15));
		_posX = (_pos select 0) + sin (_i) * _dist;
		_posY = (_pos select 1) + cos (_i) * _dist;
		_sGren = createVehicle["SmokeShellOrange", [_posX,_posY,-.1], [], 0, "CAN_COLLIDE"];
		_objs pushBack _sGren;
	};
	sleep 30;
	{
		if (!isnull _x) then {
			if (_x isKindOf "Man") then {
				removeFromRemainsCollector [_x];
				deletevehicle _x;
			}
			else {
				if (_x distance _pos < 250) then {
					deleteVehicle _x
				};
			};
			uisleep 0.1;
		};
	} forEach _objs;
};