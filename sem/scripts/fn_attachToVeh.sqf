	/* KiloSwiss	*/
private ["_obj","_veh","_attachOffset"];

_obj = _this select 0;
_veh = _this select 1;

_attachOffset = switch(typeOf _obj)do{
	case "Box_NATO_Wps_F"	:{	(switch(typeOf _veh)do{
									case "I_G_Van_01_transport_F"	:{[0, -2.8, -.3]};
									case "I_Truck_02_transport_F"	:{[0, -3, -.3]};
									case "I_G_Offroad_01_F"			:{[0, -2.5, -.1]};
								})
							};
							
	case "C_supplyCrate_F"	:{	(switch(typeOf _veh)do{
									case "I_G_Van_01_transport_F"	:{[0, -2.8, .3]};
									case "I_Truck_02_transport_F"	:{[0, -3, .3]};
									case "I_G_Offroad_01_F"			:{[0, -2.4, .3]};
								})
							};							
							
	default{[0,-2.5,0]};
};

_obj attachto [_veh, _attachOffset];