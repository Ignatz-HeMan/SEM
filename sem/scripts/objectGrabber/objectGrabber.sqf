scriptName "DynO\data\scripts\objectGrabber.sqf"; 
/* 
    File: objectGrabber.sqf 
    Author: Joris-Jan van 't Land 

    Description: 
    Converts a set of placed objects to an object array for the DynO mapper. 
    Places this information in the debug output for processing. 

    Parameter(s): 
    _this select 0: position of the anchor point 
    _this select 1: size of the covered area 
     
    Returns: 
    Success flag (Boolean) 
*/ 

//Validate parameter count 
if ((count _this) < 2) exitWith {debugLog "Log: [objectGrabber] Function requires at least 2 parameters!"; false}; 

private ["_anchorPos", "_anchorDim"]; 
_anchorPos = _this select 0; 
_anchorDim = _this select 1; 

//Validate parameters 
if ((typeName _anchorPos) != (typeName [])) exitWith {debugLog "Log: [objectGrabber] Anchor position (0) must be an Array!"; false}; 
if ((typeName _anchorDim) != (typeName 0)) exitWith {debugLog "Log: [objectGrabber] Covered area size (1) must be an Number!"; false}; 

private ["_objs"]; 
_objs = nearestObjects [_anchorPos, ["All"], _anchorDim]; 

for "_i" from 0 to ((count _objs) - 1) do 
{ 
    private ["_obj", "_type"]; 
    _obj = _objs select _i; 

    _type = typeOf _obj; 

    //Exclude human objects. 
    private ["_sim"]; 
    _sim = getText (configFile >> "CfgVehicles" >> _type >> "simulation"); 
    if !(_sim in ["soldier"]) then 
    { 
        private ["_objPos", "_dX", "_dY", "_z", "_azimuth", "_fuel", "_damage"]; 
        _objPos = position _obj; 
        _dX = (_objPos select 0) - (_anchorPos select 0); 
        _dY = (_objPos select 1) - (_anchorPos select 1); 
        _z = _objPos select 2; 
        _azimuth = direction _obj; 
        _fuel = fuel _obj; 
        _damage = damage _obj; 

        diag_log (format ["Log: objectGrabber: %1", [_type, [_dX, _dY, _z], _azimuth, _fuel, _damage]]); 
    }; 
}; 

true