private["_pos","_timeout","_name","_missionID","_missionType","_missionObjects","_group","_box1","_camonet","_wreck","_hintString","_boxPos","_start","_units","_endCondition"];
/*
	Based Of drsubo Mission Scripts
	File: bCamp.sqf
	Author: Cammygames, drsubo
	Edited by KiloSwiss
*/
/*
	Update 29.03.2017
	By [Ignatz] He-Man
*/

// Start additional Settings only for bDevice (Added by [Ignatz] He-Man)
_UseExplodeOnTimeout = false;		// If the AI's are not killed after a defined time, the missions ends with "failed", a big explosion comes up with Earthquake
	_DeviceTimeout = 30;			// 30 mins to kill the AIs
	_alarmtime = 1.5;				// 1.5 mins Alarm bofore Explosion
	_damagenearhouses = true;		// Houeses near the exploding device can be damaged
	_damageRadius = 1000;			// Radius effected by damage (higher the number, higher the risk of lag)
// End additional Settings

_pos = _this select 0;
_name = _this select 1 select 1;
_timeout = _this select 1 select 2; //Mission timeout
_missionID = _this select 2;
_missionType = _this select 3;
_missionObjects = [];
//--

_wreck = createVehicle ["Land_Device_disassembled_F",_pos,[], 0, "NONE"];
_missionObjects pushBack _wreck;
_wreck setDir (random 360);
_wreck setPos _pos;

_camonet = createVehicle ["CamoNet_INDP_open_F",_pos,[], 0, "NO_COLLIDE"];
_missionObjects pushBack _camonet;
_camonet setDir (getDir _wreck);
_camonet setPos _pos;

_boxPos = (_wreck modelToWorld [4,0,0]);
_boxPos set [2,0];
_box1 = createVehicle ["Box_NATO_Wps_F", _boxPos, [], 0, "NO_COLLIDE"];
_missionObjects pushBack _box1;
_box1 call SEM_fnc_emptyGear;
_box1 setDir (getDir _wreck);
_box1 setPos _boxPos;

_group = [_pos,(6+(random 2))] call SEM_fnc_spawnAI;
{_missionObjects pushBack _x}forEach units _group;
[_group, _pos] call SEM_fnc_AImove;
//[_group, _pos] spawn SEM_fnc_AIsetOwner;

_hintString = "<t align='center' size='2.0' color='#f29420'>Mission<br/>Device discovered!</t><br/>
<t size='1.25' color='#ffff00'>______________<br/><br/>A nuclear device has been discovered<br/>
Remove the device and enemies as soon as possible!";
[0,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];

	/* Mission End Conditions */
private ['_endcondition'];
_start = time;
_units = units _group;
_endcondition = 0;
_DeviceTimeout = time + (_DeviceTimeout*60);
waitUntil{	sleep 5;
	_endCondition = [_pos,_units,_start,_timeout,_missionID,[_box1]]call SEM_fnc_endCondition;
	(_endCondition > 0 || if (_UseExplodeOnTimeout) then {time > _DeviceTimeout} else {false})
};
if (_endcondition < 1 && _UseExplodeOnTimeout) then {
	for '_i' from 10 to (_alarmtime*60) step 10 do {
		playSound3D ["a3\sounds_f\sfx\alarm_opfor.wss", objnull, false, ATLtoASL _pos, 15, 1, 3000];
		uisleep 10;
		_endCondition = [_pos,_units,_start,_timeout,_missionID,[_box1]]call SEM_fnc_endCondition;
		if (_endCondition > 0) exitwith {};
	};
	if (_endCondition < 1) then {
		_playersNear = _pos nearEntities[["Epoch_Male_F", "Epoch_Female_F"], _damageRadius];
		{
			[_pos] remoteExec ['EPOCH_client_earthQuake',_x];
		} forEach _playersNear;
		for '_i' from 0 to 10 do {
			_dist = [6,15] call BIS_fnc_randomInt;
			_direction = [0,359] call BIS_fnc_randomInt;
			_randomPos = [_pos,_dist,_direction] call BIS_fnc_relPos;
			_bomb = createVehicle ["SatchelCharge_Remote_Ammo_Scripted",_randomPos,[],0,"CAN_COLLIDE"];
			_bomb setPosATL [_randomPos select 0, _randomPos select 1, 0.1];
			uisleep 0.25;
			_bomb setdamage 1;
			uisleep 0.25;
		};
		if (_damagenearhouses) then {
			_nearhouses = nearestobjects [_pos,['house'],_damageRadius]; 
			{ 
				_x setdamage ((random [0,((_damageRadius-(_pos distance _x))/_damageRadius),2])min 1); 
			} foreach _nearhouses; 
		};
	};
};

SEM_globalMissionMarker = [false,_endCondition,_missionID,_missionType];
SEM_globalMissionMarker call SEM_createMissionMarker;

if(_endCondition == 3)then[{ //Win!
	[_box1,1] call SEM_fnc_crateLoot;
	if(SEM_MissionCleanup > 0)then{[_pos, _missionObjects] call SEM_fnc_missionCleanup};
	_hintString = "<t align='center' size='2.0' color='#6bab3a'>Mission success<br/>
	<t size='1.25' color='#ffff00'>______________<br/><br/>All bandits have been defeated!";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
},{	// 1 or 2 = Fail
	{deleteVehicle _x; sleep .1}forEach _missionObjects;
	_hintString = "<t align='center' size='2.0' color='#ab2121'>Mission FAILED</t>";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
}];

deleteGroup _group;
