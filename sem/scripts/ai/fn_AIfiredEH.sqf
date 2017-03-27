
call compile format["
	_this addEventHandler ['Fired',{
		if(_this select 2 in %1)then{
			_this select 0 addMagazines [_this select 5, 1];
		};
	}];
", ["launch_RPG32_F","launch_NLAW_F","launch_Titan_short_F","launch_Titan_F"]];