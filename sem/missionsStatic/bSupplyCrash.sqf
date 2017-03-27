private["_pos","_timeout","_cleanup","_missionID","_missionType","_missionObjects","_group","_box1","_truck","_wreck","_smallWrecks","_truckWrecks","_wreckPos","_hintString","_start","_units","_endCondition"];
/*
	Based Of drsubo Mission Scripts
	File: supplyVanCrash.sqf
	Author: Cammygames, drsubo
	Edited by KiloSwiss
*/

_pos = _this select 0;
_name = _this select 1 select 1;
_timeout = _this select 1 select 2; //Mission timeout
_missionID = _this select 2;
_missionType = _this select 3;
_missionObjects = [];
//--

_smallWrecks = ["Land_Wreck_HMMWV_F","Land_Wreck_Hunter_F","Land_Wreck_Van_F","Land_Wreck_Ural_F"];

_truck = createVehicle ["Land_Wreck_Truck_dropside_F",_pos,[], 0, "NONE"];
_missionObjects pushBack _truck;
_truck setDir (random 360);
_truck setPos _pos;

_wreckPos = (_truck modelToWorld [(2-(random 4)),(if(random 1 > 0.5)then[{12},{-12}]),0]);
_wreckPos set [2,0];
_wreck = _smallWrecks select random(count _smallWrecks -1);
_wreck = createVehicle [_wreck,_wreckPos,[], 0, "NONE"];
_missionObjects pushBack _wreck;
_wreck setDir ((getDir _truck)+(if(random 1 > 0.5)then[{+(random 12)},{-(random 12)}]));
_wreck setPos _wreckPos;

_box1 = createVehicle ["C_supplyCrate_F", _pos, [], 3, "NONE"];
_missionObjects pushBack _box1;
_box1 call SEM_fnc_emptyGear;
_box1 attachTo [_truck,[-1.2345,1.2,.345]];
deTach _box1; /* Let it fall off */

_group = [_pos,(6+(random 2))] call SEM_fnc_spawnAI;
{_missionObjects pushBack _x}forEach units _group;
[_group, _pos] call SEM_fnc_AImove;
//[_group, _pos] spawn SEM_fnc_AIsetOwner;

_hintString = "<t align='center' size='2.0' color='#f29420'>Mission<br/>Supply Van Crash</t><br/>
<t size='1.25' color='#ffff00'>______________<br/><br/>A supply van with base building material has crashed!<br/>
You have our permission to confiscate any property you find as payment for eliminating the threat!";
[0,_hintString] remoteexec ["SEM_Client_GlobalHint",-2];

	/* Mission End Conditions */
	
_start = time;
_units = units _group;
waitUntil{	sleep 5;
	_endCondition = [_pos,_units,_start,_timeout,_missionID,[_box1]]call SEM_fnc_endCondition;
	(_endCondition > 0)
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
