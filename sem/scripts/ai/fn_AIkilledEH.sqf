/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/

/* Remove Weapons when killed */
call compile format["
	_this addEventHandler ['Killed',{ 
		private['_unit','_z','_ran'];
		_unit = _this select 0;
		_killer = _this select 1;
		{_unit removeWeaponGlobal _x}count (%1 + ['EpochRadio0','ItemMap','ItemRadio','ItemWatch','ItemCompass','ItemGPS']);
		{if(_x in (magazines _unit))then{_unit removeMagazines _x}}count %2;
		if (SEM_AIdropGearChance < ceil(random 100)) then {
			_unit call SEM_fnc_removeGear;
			{deleteVehicle _x} forEach nearestObjects [(getPosATL _unit), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 1];
		};
		_unit spawn{
			sleep .1;
			{_z = _x;
			if(_x in (getweaponcargo _z))exitWith{deleteVehicle _z}count %1;
			if(_x in (getmagazinecargo _z))exitWith{deleteVehicle _z}count %2;
			}forEach nearestObjects [(getPosATL _this), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
		};
	}];
", SEM_removeWeaponsFromDeadAI, SEM_removeMagazinesFromDeadAI];

/* AI run over by vehicle */
if(SEM_punish_AIroadkill || SEM_reward_AIkill)then{
	_this addEventHandler ["killed",{
		private["_u","_k","_vk"];
		_u = _this select 0;
		_k = _this select 1;
		_vk = vehicle _k;
		if (SEM_punish_AIroadkill) then {
			if (_vk isKindOf "Car") then {
				if (abs speed _vk > 0) then {
					if (_vk distance _u < 10) then {
						if (isEngineOn _vk || !isNull (driver _vk)) then {
							if (SEM_damage_AIroadkill) then {
								if (!local _vk) then {
									_vk remoteexec ["SEM_Client_VehDamage",_vk];
								};
							};
							if(SEM_Krypto_AIroadkill > 0)then{
								[_k,SEM_Krypto_AIroadkill*-1] call EPOCH_server_effectCrypto;
							};
							{
								deleteVehicle _x
							} forEach nearestObjects [(getPosATL _u), ['GroundWeaponHolder','WeaponHolderSimulated','WeaponHolder'], 3];
							_u call SEM_fnc_removeGear;
							if ({alive _x}count units group _u < 1) then {
								_u spawn {
									uisleep 5;
									createMine ["APERSTripMine", (position _this),[],0]
								};
							};
						}
					}
				}
			}
			else {
				if(SEM_reward_AIkill)then{
					[_k,(ceil(random 15))] call EPOCH_server_effectCrypto;
				};
			};
		}
		else {
			if (SEM_reward_AIkill) then {
				[_k,(ceil(random 15))] call EPOCH_server_effectCrypto;
			};
		};
	}];
};