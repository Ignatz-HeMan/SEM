	/* KiloSwiss */
private["_veh","_pos","_fuel","_damage","_direction","_searchRadius","_spawnPos"];

_veh = _this;

if !(_veh getVariable ["SEM_vehicle",false])exitWith{{_x setDamage 1}count (crew _veh + [_veh])};
if (_veh getVariable ["saveEH",0] >= 0)exitWith{};
if (!SEM_permanentVehicles)exitWith{};
/*
EPOCH_VehicleSlotsLimit = EPOCH_VehicleSlotsLimit + 1;
EPOCH_VehicleSlots pushBack str(EPOCH_VehicleSlotsLimit);
EPOCH_VehicleSlots=EPOCH_VehicleSlots - [(EPOCH_VehicleSlots select 0)];
EPOCH_VehicleSlotCount = count EPOCH_VehicleSlots;
publicVariable "EPOCH_VehicleSlotCount";
_veh setVariable ["VEHICLE_SLOT", (EPOCH_VehicleSlots select 0), true];
*/
	/* Save Vehicle */
_veh call EPOCH_server_save_vehicle;