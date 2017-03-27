	/* KiloSwiss */
private["_startPos","_endPos","_timeout","_name","_missionID","_missionType","_dir","_missionObjects","_convoyVehicles","_group","_box1","_hintString","_convoy","_start","_units","_endCondition","_enterableVehicles"];

_startPos = _this select 0 select 0;
_endPos = _this select 0 select 1;
_name = _this select 1 select 1;
_timeOut = _this select 1 select 2; //Mission timeout
_missionID = _this select 2;
_missionType = _this select 3;
_dir = (_this select 0) call BIS_fnc_dirTo;
_missionObjects = [];
_convoyVehicles = [];
_enterableVehicles = [];
//--

_convoyVeh1 =	["I_G_Offroad_01_armed_F",_startPos,1,0,_dir] call SEM_fnc_spawnVehicle;
_mainVehicle =	["I_MRAP_03_F",_startPos,1,0,_dir] call SEM_fnc_spawnVehicle;
_convoyVeh2 =	["I_G_Offroad_01_armed_F",_startPos,1,0,_dir] call SEM_fnc_spawnVehicle;
{
	_convoyVehicles pushBack _x
} forEach [_convoyVeh1, _mainVehicle, _convoyVeh2];

_enterableVehicles pushBack _mainVehicle;

//--
_group = [_startPos,(5+(random 2))] call SEM_fnc_spawnAI;
{
	_missionObjects pushBack _x
} forEach units _group;

_convoy = [_group, _endPos, _missionID, _mainVehicle, _convoyVehicles, _enterableVehicles] spawn SEM_fnc_AIconvoy;

_hintString = format["<t align='center' size='2.0' color='#f29420'>Mission<br/>%1</t><br/>
<t size='1.25' color='#ffff00'>______________<br/><br/>Blablablablabla!", _name];
[0,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];

	/* Mission End Conditions */
waitUntil{sleep 1; scriptDone _convoy};
_start = time;
_units = units _group;
waitUntil{	sleep 5;
	_endCondition = [(getPos _mainVehicle),_units,_start,_timeout,_missionID,[_mainVehicle]]call SEM_fnc_endCondition;
	(_endCondition > 0)
};

SEM_globalMissionMarker = [false,_endCondition,_missionID,_missionType];
SEM_globalMissionMarker call SEM_createMissionMarker;

if (_endCondition == 3) then { //Win!
	{
		_x call SEM_fnc_vehicleUnlock
	} count _enterableVehicles;
	{
		_x setVehicleAmmo 0
	} count _convoyVehicles;
	_hintString = "<t align='center' size='2.0' color='#6bab3a'>Mission success<br/>
	<t size='1.25' color='#ffff00'>______________<br/><br/>All bandits have been defeated!";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
}
else {	// 1 or 2 = Fail
	{
		deleteVehicle _x;
		uisleep 0.1
	} forEach _missionObjects;
	_convoyVehicles spawn{{_x setDamage 1} count _this; sleep 300; {deleteVehicle _x}count _this};
	_hintString = "<t align='center' size='2.0' color='#ab2121'>Mission FAILED</t>";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
};

deleteGroup _group;
