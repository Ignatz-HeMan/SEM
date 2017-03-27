private["_pos","_timeout","_cleanup","_missionID","_missionType","_missionObjects","_group","_composition","_compositions","_compositionObjects","_hintString","_start","_units","_endCondition"];
/*
	Based Of drsubo Mission Scripts
	File: bCamp.sqf
	Author: Cammygames, drsubo
	Edited by KiloSwiss
*/
/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/


_pos = _this select 0;
_name = _this select 1 select 1;
_timeout = _this select 1 select 2; //Mission timeout
_missionID = _this select 2;
_missionType = _this select 3;
_missionObjects = [];
//--

_compositions =["camp1","camp2","camp3"];
_composition = _compositions select random (count _compositions -1);
_compositionObjects = [_composition, (random 359), _pos] call SEM_fnc_createComposition;
{
	_missionObjects pushBack _x
} forEach _compositionObjects;

_group1 = [_pos,(4+(random 1))] call SEM_fnc_spawnAI;
_group2 = [_pos,(4+(random 1))] call SEM_fnc_spawnAI;
_units = units _group1 + units _group2;
{
	_missionObjects pushBack _x
} forEach _units;

[_group1, _pos] call SEM_fnc_AImove;
[_group2, _pos] call SEM_fnc_AImove;

_hintString = "<t align='center' size='2.0' color='#f29420'>Mission<br/>Bandit Base Camp</t><br/>
<t size='1.25' color='#ffff00'>______________<br/><br/>A bandit camp has been discovered!<br/>
You have our permission to confiscate any property you find as payment for eliminating the threat!";
[0,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];

	/* Mission End Conditions */
_start = time;
waitUntil{	uisleep 5;
	_endCondition = [_pos,_units,_start,_timeout,_missionID]call SEM_fnc_endCondition;
	(_endCondition > 0)
};

SEM_globalMissionMarker = [false,_endCondition,_missionID,_missionType];
SEM_globalMissionMarker call SEM_createMissionMarker;

if (_endCondition == 3) then { //Win!
	if (SEM_MissionCleanup > 0) then {
		[_pos, _missionObjects] call SEM_fnc_missionCleanup
	};
	_hintString = "<t align='center' size='2.0' color='#6bab3a'>Mission success<br/>
	<t size='1.25' color='#ffff00'>______________<br/><br/>All bandits have been defeated!";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
}
else {	// 1 or 2 = Fail
	{
		deleteVehicle _x;
		uisleep 0.1
	} forEach _missionObjects;
	_hintString = "<t align='center' size='2.0' color='#ab2121'>Mission FAILED</t>";
	[_endCondition,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];
};

deleteGroup _group1;
deleteGroup _group2;
