	/* KiloSwiss */
private "_units";

if (isNil "SEM_AI_Units") then {
	SEM_AI_Units = []
};

_units = SEM_AI_Units;

	/* Remove old/dead units */
//{if(isNull _x || !alive _x)then{_units deleteAt _forEachIndex}}forEach _units;
{
	if (isNull _x || !alive _x) then {
		_units set [_forEachIndex, "delete"]
	}
}forEach _units;
_units = _units - ["delete"];

	/* Add new units */
{
	_units pushBack _x
} forEach _this;

	/* Broadcast to clients */
SEM_AI_Units = _units;
publicVariable "SEM_AI_Units";

if (SEM_debug in ["log","full"]) then {
	diag_log format["#SEM DEBUG: Broadcasted %1 AI units to clients", count SEM_AI_Units]
};