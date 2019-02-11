	/* KiloSwiss */
private["_veh","_pos","_fuel","_damage","_direction","_searchRadius","_spawnPos"];

_veh = _this select 0;
_pos = _this select 1; _pos set[2, 0];
_fuel = if(count _this > 2)then[{_this select 2},{0.15 max (random .35)}];
_damage = if(count _this > 3)then[{_this select 3},{0.35 max (random .75)}];
_direction = if(count _this > 4)then[{_this select 4},{random 360}];

_searchRadius = 0;
waitUntil{
	_spawnPos = _pos findEmptyPosition [0,_searchRadius,_veh];
	_searchRadius = _searchRadius + 10;
	(count _spawnPos > 0)
};
_veh = createVehicle[_veh, _spawnPos, [], 0, "NONE"];
_veh setVariable ["BIS_enableRandomization", false];
_veh allowDamage false;
_veh setDir _direction;
_veh setVectorUp (surfaceNormal (getPos _veh));

_veh call SEM_fnc_emptyGear;
_veh call EPOCH_server_setVToken;
_veh call EPOCH_server_vehicleInit;
_veh setVariable ["SEM_vehicle", true];

_veh disableTIEquipment true;
_veh lock 2;

_veh setFuel _fuel;
_veh setDamage _damage;
_veh allowDamage true;

_veh

/*
_config=(configFile >> "CfgVehicles" >> _vehClass >> "availableColors");
if(isArray(_config))then{_textureSelectionIndex=configFile >> "CfgVehicles" >> _vehClass >> "textureSelectionIndex";
_selections=if(isArray(_textureSelectionIndex))then{getArray(_textureSelectionIndex)}else{[0]};
_colors=getArray(_config);
_textures=_colors select 0;
_color=floor(random(count _textures));
_count=(count _colors)-1;
{if(_count >=_forEachIndex)then{_textures=_colors select _forEachIndex;
};
_veh setObjectTextureGlobal[_x,(_textures select _color)];
}forEach _selections;
_veh setVariable["VEHICLE_TEXTURE",_color];
};
*/
