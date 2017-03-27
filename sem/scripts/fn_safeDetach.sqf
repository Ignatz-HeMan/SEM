	/* KiloSwiss */
_this spawn {	private ["_obj","_radius","_safePos","_smoke"];
	_obj = _this;

	_radius = 10;
	waitUntil{ sleep .1;
		_safePos = (getPos _obj) findEmptyPosition [0,_radius,(typeOf _obj)];
		_radius = _radius + 5;
		(count _safePos > 0)
	};
	detach _obj;
	_safePos set [2,0];
	_obj setPos _safePos;

	if(sunOrMoon < 0.1)then[{ //Dark
		for "_i" from 120 to 360 step 120 do{ private ["_posX","_posY","_dist"];
			_dist = (3+(random 5));
			_posX = (_safePos select 0) + sin (_i) * _dist;
			_posY = (_safePos select 1) + cos (_i) * _dist;
			"Chemlight_blue" createVehicle [_posX, _posY, 0];
		};
	},{	//Bright
		_smoke = "SmokeShellBlue" createVehicle _safePos;
		_smoke setPos _safePos;
	}];
};