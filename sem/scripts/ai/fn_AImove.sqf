/* KiloSwiss */
_this call SEM_fnc_findthread;

_this spawn {
	private["_group","_pos","_owner","_firstLoop","_oldPos","_newPos","_dir","_dist","_posX","_posY","_wp"];																							
	_group = _this select 0; 
	_pos = _this select 1;

	{
		if (!isnull _x) then {
			if (_x == leader _group) then {
				_x setUnitRank "CORPORAL";
			}
			else {
				_x setUnitRank "PRIVATE";
			};
		};
	} forEach units _group;
	
	_firstLoop = true;
	_oldPos = [0,0,0];
	_newPos = _pos;
	
	while {
		{
			if (!isnull _x) then {
				alive _x
			};
		} count units _group > 0
	} do {
		while {_oldPos distance _newPos < 30} do {
			uisleep 0.1;
			_dir = random 360;
			_dist = (15+(random 45));
			_posX = (_pos select 0) + sin (_dir) * _dist;
			_posY = (_pos select 1) + cos (_dir) * _dist;
			_newPos = [_posX, _posY, 0];
		};
		_oldPos = _newPos;

		_group move _newPos;
		_group setSpeedMode (["FULL","NORMAL","LIMITED"]call BIS_fnc_selectRandom);
		_group setFormation (["WEDGE","VEE","FILE","DIAMOND"]call BIS_fnc_selectRandom);

		waitUntil {
			uisleep 5;
			{
				if (!isnull _x) then {
					alive _x && vehicle _x == _x && unitReady _x
				};
			} count (units _group) == {alive _x && vehicle _x == _x} count (units _group)
		};
	};
	diag_log format["#SEM: AI moving stopped - Remaining AIs: (%1/%2)", {alive _x}count units _group, count units _group];
};