private["_mapSize","_mapCenter","_worldData","_locations"];
/*
	_return = [] call SEM_fnc_getWorldData;
	
	Returns the following:
	_return select 0 = World size
	_return select 1 = World center position
	_return select 2 = Locations
	
	
	06.02.2015 by KiloSwiss
*/

_mapSize = getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize");
if(_mapSize > 0)then{
	_worldData = [_mapSize, [(_mapSize/2), (_mapSize/2), 0]];
	if(SEM_debug in ["log","full"])then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from config", _mapSize, str worldName]};
}else{
	if((getMarkerPos "center" select 0) > (getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition") select 0))then[{
		_mapSize = (getMarkerPos "center" select 0) * 2;
		_mapCenter = getMarkerPos "center";
		_worldData = [_mapSize, _mapCenter];
		if(SEM_debug in ["log","full"])then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from center Marker", _mapSize, str worldName]};
	},{
		_mapCenter = getArray(configFile >> "CfgWorlds" >> worldName >> "centerPosition");
		_mapCenter set [2,0];
		_mapSize = (_mapCenter select 0) * 2;
		_worldData =[_mapSize, _mapCenter];
		if(SEM_debug in ["log","full"])then{diag_log format["#SEM DEBUG: WorldData get MapSize (%1) for island %2 from default center position", _worldData select 0, str worldName]};	
	}];
};


_locations = nearestLocations [_worldData select 1, ["NameCityCapital","NameCity","NameVillage","NameLocal","CityCenter","Airport"], ((_worldData select 0)/2)];

//_locations = (configfile >> "CfgWorlds" >> worldName >> "Names") call BIS_fnc_returnChildren;
												
_worldData pushBack _locations;

_worldData

/*	To check size on different islands, use this code:
private["_worldRadius","_worldCenterPos","_marker"];
deleteMarkerLocal "Center";
_worldRadius = (getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize")/2);
_worldCenterPos = [ _worldRadius, _worldRadius, 0];
_marker = createMarkerLocal ["Center", _worldCenterPos];
_marker setMarkerPosLocal _worldCenterPos;
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [_worldRadius, _worldRadius];
_marker setMarkerColorLocal "ColorBlack";
_marker setMarkerAlphaLocal 0.5;
_marker setMarkerBrushLocal "SolidFull";
copytoClipboard format["%1 / %2 / %3", toLower worldName, _worldRadius*2, _worldCenterPos];
hint format["Copy to clipboard\nUse %4 to paste this information:\n\nWorldName: %1\nSize: %2\nCenter: %3", worldName, _worldRadius*2, _worldCenterPos, str (ctrl+v)];
*/

/* To create coloured markers on all found locations use:
_worldRadius = (getNumber(configFile >> "CfgWorlds" >> worldName >> "MapSize")/2);
_worldCenterPos = [ _worldRadius, _worldRadius, 0];
_allLocations = nearestLocations [_centerPos, ["NameCityCapital","NameCity","NameVillage","NameLocal","CityCenter","Airport","NameMarine","Strategic","ViewPoint","RockArea","StrongpointArea","FlatArea","FlatAreaCity","FlatAreaCitySmall"], _worldRadius * 2];
{ private ["_marker","_markerName","_marker2","_markerName2"];
_markerName = format["Marker_%1", _forEachIndex];
deleteMarkerLocal _markerName;
_marker = createMarkerLocal [_markerName, position _x];
_marker setMarkerShapeLocal "ELLIPSE";
_marker setMarkerSizeLocal [size _x select 0, size _x select 1];
_marker setMarkerTextLocal format["%1 %2", _forEachIndex, type _x];

if ((type _x) in ["NameCityCapital","NameCity","NameVillage","NameLocal","CityCenter","Airport"])then{ _marker setMarkerColorLocal "ColorWhite"; };
if ((type _x) in ["NameMarine"])then{ _marker setMarkerColorLocal "ColorBlue"; };
if ((type _x) in ["Strategic","StrongpointArea"])then{ _marker setMarkerColorLocal "ColorOrange"; };
if ((type _x) in ["ViewPoint","RockArea"])then{ _marker setMarkerColorLocal "ColorGreen"; };
if ((type _x) in ["FlatArea"])then{ _marker setMarkerColorLocal "ColorRed"; };
if ((type _x) in ["FlatAreaCity","FlatAreaCitySmall"])then{ _marker setMarkerColorLocal "ColorYellow"; };

_markerName2 = format["#Marker_%1", _forEachIndex];
deleteMarkerLocal _markerName2;
_marker2 = createMarkerLocal [_markerName2, position _x];
_marker2 setMarkerTypeLocal "mil_dot";
_marker2 setMarkerTextLocal format["%1 %2", _forEachIndex, type _x];
_marker2 setMarkerColorLocal "ColorBlack";
}forEach _allLocations;
*/