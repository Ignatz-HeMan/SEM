private["_enable","_group","_pos"];

_group = _this select 0;
_enable = _this select 1;

if (_enable )then { //Enable AI
	
	{
		if (!isnull _x) then {
			_x enableAI "AUTOTARGET";
			//_x enableAI "TARGET";
			_x enableAI "MOVE";
			_x enableAI "ANIM";
			_x enableAI "FSM";
			_x stop false;
			_x spawn {
				_this setUnitPos "Middle";
				uisleep 30;
				_this setUnitPos "AUTO"
			};
			[_x, false] call SEM_fnc_AIdamageEH;
		};
	} count units _group;
	_group setCombatMode "YELLOW";
	_group setBehaviour "COMBAT"; //"AWARE";
	
	diag_log "#SEM: Mission AI enabled";
	
}
else {	//Disable AI
	{
		if (!isnull _x) then {
			_x disableAI "AUTOTARGET";
			_x disableAI "TARGET";
			_x disableAI "MOVE";
			_x disableAI "FSM";
			_x stop true;
			_x spawn {_this setUnitPos "DOWN"; sleep 5; _this disableAI "ANIM"};
			[_x, true] call SEM_fnc_AIdamageEH;
		};
	} count units _group;
	_group setBehaviour "SAFE";
	_group setCombatMode "BLUE";
	
	diag_log "#SEM: Mission AI disabled";	
};