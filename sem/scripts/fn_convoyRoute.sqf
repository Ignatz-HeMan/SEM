/* KiloSwiss */
private["_startPos","_endPos","_defaultCenterPos","_worldSize","_locations","_worldRadius","_searchRadius","_blockRadius","_blockPos","_found"];

_defaultCenterPos = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");

_worldSize = SEM_worldData select 0;
_worldCenterPos = SEM_worldData select 1;
_locations = SEM_worldData select 2;;

_worldRadius = (1500 max (_worldSize/2));
_searchRadius = (150 max (_worldRadius/5) min 300);
_blockRadius = (500 max (_worldRadius/3) min 3000);

_blockPos = [];
{_blockPos pushBack _x}forEach SEM_lastMissionPositions;
{_blockPos pushBack (getMarkerPos _x)}forEach SEM_blockMarker;

	/* Convoy start position */
waitUntil{ private["_dir","_searchDist","_posX","_posY","_checkPos","_roads"]; sleep .1; _found = false;
		/* Randomize the search area */
	_dir = random 360;
	_searchDist = (_worldRadius/2 max random(_worldRadius - _searchRadius));
	_posX = (_worldCenterPos select 0) + sin(_dir) * _searchDist;
	_posY = (_worldCenterPos select 1) + cos(_dir) * _searchDist;
	_checkPos = [_posX, _posY, 0];
	
	_roads = _checkPos nearRoads _searchRadius;
	if(count _roads > 0)then{
		{	private "_checkPos";
			_checkPos = getPos (_roads select _forEachIndex);
			_startPos = _checkPos findEmptyPosition [0,0,"ProtectionZone_F"];
			if(count _startPos > 0)exitWith{_found = true};
		}forEach _roads;
	};
	if(_found)then{
		{if(_x distance _startPos < _blockRadius)exitWith{_found = false}}forEach _blockPos;
	
		if(_found)then{
			{if(isPlayer _x)then[{if(_x distance _startPos < _blockRadius)exitWith{_found = false}},{UIsleep .05}]}forEach (if(isMultiplayer)then[{allplayers},{allUnits}]);
		};
	};
	
	(_found)
};

	/* Convoy destination */
_found = false;
while{!_found}do{ UIsleep .1; private["_randomLocation","_locationPos","_locationSize"];

		/* Select a random location */
	_randomLocation = _locations select random(count _locations -1);
	_locationPos = locationPosition _randomLocation;

		/* Let's suppose this position is a valid convoy destination */
	_found = true;

		/* Now check this position */
	if(_locationPos distance _startPos < (_worldRadius))then{_found = false};
	
	if(_found)then{	/* Check it again */
		_locationSize = (if(size _randomLocation select 0 > size _randomLocation select 1)then[{size _randomLocation select 0},{size _randomLocation select 1}]);
		_endPos = _locationPos findEmptyPosition [0,_locationSize,"ProtectionZone_F"];
		if(count _endPos == 0)then{_found = false};
		//_endPos = [_locationPos,0,(50 max _locationSize*1.5 min 200),30,0,0.7,0] call BIS_fnc_findSafePos;
		//if(_endPos isEqualTo _defaultCenterPos)then{_found = false};	
	};
};
_endPos set [2,0];
_convoyRoute = [_startPos, _endPos];

_convoyRoute
