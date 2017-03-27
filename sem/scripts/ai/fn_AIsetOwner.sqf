private["_group","_pos","_units","_checkPos","_serverID","_firstLoop","_loops","_possibleThreads","_z","_newOwner","_ownerLeft","_AIkilled","_changeOwner"];
/*
	Disable AI processing and move it to nearby players via "setOwner"
	Work In Progress!
	
	Update 03.01.2015
	KiloSwiss
	
	[_group, true] call SEM_fnc_AIactDeact;		//Enable AI
	[_group, false] call SEM_fnc_AIactDeact;	//Disable AI

*/
#define getAttacker(WHO) WHO getVariable "gotHitBy"

_group = _this select 0;
_pos = _this select 1;
_checkPos = _pos; _checkPos set [2,2];
_units = units _group;
_serverID = owner (units _group select 0);
//diag_log format["#SEM DEBUG: ServerID: %1", _serverID]; 

_group move _pos;
_group setspeedMode "FULL";
_group setFormation "DIAMOND";
sleep 10;
[_group, false] call SEM_fnc_AIactDeact; //Disable AI

_oldPos = _pos;
_newPos = _pos;
_newOwner = objNull;
_firstLoop = true;
_changeOwner = false;
while {
	{
		if (!isnull _x) then {
			alive _x
		};
	} count units _group > 0
} do {

	if (_firstLoop) then {
		_firstLoop=false;
		_loops = -1;
		diag_log "#SEM: Mission AI waiting for their first encounter"
	}
	else {
		_loops = 0;
		diag_log "#SEM: Mission AI searching for new possible thread(s)"
	};

	waitUntil{
		uisleep 5;
		_possibleThreads = [];	//Check if any thread for the AI has been detected
		//Check if any AI is shot by player
		{
			if (!isnull _x) then {
				if (!isNil {getAttacker(_x)}) then {
					if (isPlayer (getAttacker(_x) select 0) && (getAttacker(_x) select 0) != _newOwner) then {
						if((time - (getAttacker(_x) select 1)) < 150)then {
							_possibleThreads pushBack (getAttacker(_x) select 0)
						}
						else {
							_x setVariable ["gotHitBy", Nil]
						};
					};
				};
			};
		} forEach _units;	//Do NOT replace forEach with count!
		//Check if any players are near
		{
			uisleep 0.1;
			if (!isnull _x) then {
				if (isPlayer _x && alive _x && !(_x in _possibleThreads) && _x != _newOwner) then {
					if (_x isKindOf "Epoch_Man_base_F" || _x isKindOf "Epoch_Female_base_F") then {
						_possibleThreads pushBack _x
					}
					else {
						_z = _x;
						if (count crew _z > 0) then {
							{
								if (isPlayer _x && _x != _newOwner) then {
									_possibleThreads pushBack _x
								}
							} forEach crew _z;
						};
					};
				};
			};
		} forEach (_pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F","Helicopter","Car","Motorcycle"], 500]); //Do NOT replace forEach with count!
		
		if (_loops >= 0) then {
			if(_loops>5)then {
				_loops = -1;
				[_group, false] call SEM_fnc_AIactDeact
			}
			else {
				_loops = _loops + 1
			};
		};
		
	(count _possibleThreads > 0)
	};
		/* Thread has been detected */
	
	[_group, true] call SEM_fnc_AIactDeact;	//Enable AI system
	{_group reveal _x}count _possibleThreads; //Reveal threads
	
	
	//Select the closest alive player to the mission
	diag_log format["#SEM DEBUG: Possible threads: %1", _possibleThreads];
	_newOwner = [_pos, _possibleThreads] call SEM_fnc_selectClosest;
	_newOwnerID = owner _newOwner; //Define the new owners ID
	
	{
		if (!isnull _x) then {
			_x setOwner _newOwnerID;
			diag_log format["#SEM: Setowner: Unit: %1 New Owner: %2", _x, _newOwnerID];
		};
	}forEach units _group; //Set the new owner
	waitUntil {
		{
			if (!isnull _x) then {
				owner _x == _newOwnerID;
			};
		} forEach units _group || !isPlayer _newOwner;
	};
	
if(isPlayer _newOwner)then[{
	diag_log format["#SEM: Mission AI has new Owner: %1 - ID: %2", _newOwner, _newOwnerID];
	
		/* AI transfer completed. */
	
	//Announce transfer of the ownership to the client
	SEM_takeAIownership = [_group, _pos];
	_newOwnerID publicVariableClient "SEM_takeAIownership";
	
	//[_group,_pos,_newOwner] spawn SEM_fnc_AImove; //IMPORTANT: spawn not call!
	
		/* Check some stuff */
	_ownerDistance = _pos distance _newOwner;
	waitUntil{ UIsleep 5;	_ownerLeft = false; _AIkilled = false; _changeOwner = false;
		if (
			{
				if (!isnull _x) then {
				alive _x
			}
			} count units _group < 1
		) then {
			_AIkilled = true
		};
		if (!_aiKilled) then {
			if (!isPlayer _newOwner || local (units _group select 0)) then {
				_ownerLeft = true
			};
			if (!_ownerLeft) then {
				_newDistance = _pos distance _newOwner;
				if (_newDistance > 800 || (_newDistance > _ownerDistance + 50 && _newDistance > 500)) then { //Current owner moved too far away
					{
						uisleep 0.1;	//Check for other possible nearby owner
						if (isPlayer _x && alive _x && !(_x == _newOwner)) then { 
							if (_x distance _pos < _newDistance) exitwith {
								_changeOwner = true
							};
						};
					} forEach (_pos nearEntities [["Epoch_Man_base_F","Epoch_Female_base_F","Helicopter","Car","Motorcycle"], 500]);
				};
			};
		};	
	(_ownerLeft || _AIkilled || _changeOwner)	//All AI units dead or player disconnected or closer player detected
	};
	
},{diag_log format["#SEM: Mission AI new Owner left during processing: %1 - ID: %2", _newOwner, _newOwnerID]}];

}; //End of while loop
