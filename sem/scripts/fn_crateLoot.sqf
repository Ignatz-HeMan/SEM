/*
	Update 27.03.2017
	By [Ignatz] He-Man
*/

/*
	[_box,1] call SEM_fnc_crateLoot;
	_box = crate where the loot should be added
	1 = selected loadout
	leadouts configure at the bottom of this file!
*/

private ["_crate","_loadout"];
_crate = _this select 0;
if (count _this > 1) then {
	_loadout = _this select 1
}
else {
	_loadout = round(random 1)
};


_crate call SEM_fnc_emptyGear;


_Backpacks_Assault = 	[
						"B_AssaultPack_cbr",
						"B_AssaultPack_dgtl",
						"B_AssaultPack_khk",
						"B_AssaultPack_mcamo",
						"B_AssaultPack_ocamo",
						"B_AssaultPack_rgr",
						"B_AssaultPack_sgg"
						];
						
_Backpacks_Carryall = 	[
						"B_Carryall_cbr",
						"B_Carryall_khk",
						"B_Carryall_mcamo",
						"B_Carryall_ocamo",
						"B_Carryall_oli",
						"B_Carryall_oucamo"
						];
						
_Backpacks_Field = 		[
						"B_FieldPack_blk",
						"B_FieldPack_cbr",
						"B_FieldPack_khk",
						"B_FieldPack_ocamo",
						"B_FieldPack_oli",
						"B_FieldPack_oucamo"
						];
						
_Backpacks_Kit = 		[
						"B_Kitbag_cbr",
						"B_Kitbag_mcamo",
						"B_Kitbag_rgr",
						"B_Kitbag_sgg"
						];
						
_Backpacks_Tactical = 	[
						"B_TacticalPack_blk",
						"B_TacticalPack_mcamo",
						"B_TacticalPack_ocamo",
						"B_TacticalPack_oli",
						"B_TacticalPack_rgr"
						];
						
_Backpacks_Small = 		[
						"smallbackpack_red_epoch",
						"smallbackpack_green_epoch",
						"smallbackpack_teal_epoch",
						"smallbackpack_pink_epoch"
						];
						
_Backpacks_Other =		["B_Parachute"];
_Backpacks_All = 		_Backpacks_Carryall +
						_Backpacks_Field +
						_Backpacks_Kit +
						_Backpacks_Tactical +
						_Backpacks_Small +
						_Backpacks_Other;
//////////////////////////////////////////////////////////////////////////////////////////////////////////
_Explosives = 			[
						"DemoCharge_Remote_Mag",
						"SatchelCharge_Remote_Mag",
						"ATMine_Range_Mag",
						"ClaymoreDirectionalMine_Remote_Mag",
						"APERSMine_Range_Mag",
						"APERSBoundingMine_Range_Mag",
						"SLAMDirectionalMine_Wire_Mag",
						"APERSTripMine_Wire_Mag"
						];
						
_Paint = 				[
						"PaintCanBlk",
						"PaintCanBlu",
						"PaintCanBrn",
						"PaintCanGrn",
						"PaintCanOra",
						"PaintCanPur",
						"PaintCanRed",
						"PaintCanTeal",
						"PaintCanYel"
						];
						
/*
_Keys = 				[
						"ItemKey",
						"ItemKeyBlue",
						"ItemKeyGreen",
						"ItemKeyRed",
						"ItemKeyYellow",
						"ItemKeyKit"
						];
*/
						
/*
_Documents = 			[
						"ItemDoc1",
						"ItemDoc2",
						"ItemDoc3",
						"ItemDoc4",
						"ItemDoc5",
						"ItemDoc6",
						"ItemDoc7",
						"ItemDoc8",
						"ItemVehDoc1",
						"ItemVehDoc2",
						"ItemVehDoc3",
						"ItemVehDoc4"
						];
*/
						
_Gems =					[
						"ItemTopaz",
						"ItemOnyx",
						"ItemSapphire",
						"ItemAmethyst",
						"ItemEmerald",
						"ItemCitrine",
						"ItemRuby",
						"ItemQuartz",
						"ItemJade",
						"ItemGarnet"
						];
						
_RareMetal = 			[
						//"ItemBriefcaseGold100oz",
						"ItemAluminumBar",
						"ItemCopperBar",
						"ItemTinBar",
						"PartOreGold",
						"PartOreSilver",
						"ItemGoldBar",
						"ItemSilverBar",
						"ItemGoldBar10oz"
						];
						
_Medical =				[
						"FAK",
						"HeatPack",
						"ColdPack"
						];
						
_Food_Canned = 			[
						"FoodBioMeat",
						"FoodWalkNSons",
						"sardines_epoch",
						"meatballs_epoch",
						"scam_epoch",
						"sweetcorn_epoch"
						];
						
_Food_Other = 			[
						"FoodMeeps",
						"FoodSnooter",
						"honey_epoch"
						];
						
_Food_Cooked = 			[
						"CookedSheep_EPOCH",
						"CookedGoat_EPOCH",
						"SnakeMeat_EPOCH",
						"CookedRabbit_EPOCH",
						"CookedChicken_EPOCH"
						];
						
_Food_Craft = 			[
						"SnakeCarcass_EPOCH",
						"RabbitCarcass_EPOCH",
						"ChickenCarcass_EPOCH",
						"GoatCarcass_EPOCH",
						"SheepCarcass_EPOCH"
						];
						
_Food_Fish = 			[
						"ItemTrout",
						"ItemSeaBass",
						"ItemTuna"
						];
						
_Food_All = 			_Food_Canned +
						_Food_Other +
						_Food_Cooked +
						_Food_Fish +
						_Food_Craft;
						
_Drink = 				[
						"WhiskeyNoodle",
						"ItemSodaOrangeSherbet",
						"ItemSodaPurple",
						"ItemSodaMocha",
						"ItemSodaBurst",
						"ItemSodaRbull"
						];
						
_OtherItems = 			[
//						"ItemBriefcaseE",
						"ItemCoolerE",
						"ItemDocument",
						"lighter_epoch",
						"JackKit"
						];
						
_BuildingKits = 		[
						"ItemLockbox",
						"KitStudWall",
						"KitWoodFloor",
						"KitWoodStairs",
						"KitWoodRamp",
						"KitFirePlace",
						"KitShelf",
						"KitFoundation",
						"KitCinderWall",
						"KitSolarGen",
						"KitWorkbench",
						"KitWoodTower"
						];
						
_BuildingComponents = 	[
//						"PartPlankPack",
//						"WoodLog_EPOCH",
						"CinderBlocks",
						"MortarBucket",
						"ItemScraps",
						"ItemCorrugated",
						"ItemCorrugatedLg"
						];
						
_CraftingTools = 		[
						"ChainSaw",
						"VehicleRepairLg",
						"Hatchet",
						"MultiGun",
						"MeleeSledge"
						];
						
_CraftingComponents = 	[
//						"ItemHotwire",
//						"ItemComboLock",
//						"ItemPipe",
//						"ItemBulb",
//						"ItemBurlap",
						"CircuitParts",
						"VehicleRepair",
						"ItemMixOil",
						"emptyjar_epoch",
						"jerrycan_epoch",
						"ItemBarrelF",
						"ItemBarrelE",
						"EnergyPack",
						"EnergyPackLg",
						"Heal_EPOCH",
						"Defib_EPOCH",
						"Repair_EPOCH",
						"ItemSolar",
						"ItemCables",
						"ItemBattery",
						"ItemPlywoodPack"
						];
 
_Grenades_Hand = 		[
						"HandGrenade",
						"MiniGrenade"
						];
						
_Grenades_Smoke = 		[
						"SmokeShell",
						"SmokeShellYellow",
						"SmokeShellGreen",
						"SmokeShellRed",
						"SmokeShellPurple",
						"SmokeShellOrange",
						"SmokeShellBlue"
						];
						
_Grenades_Light = 		[
						"Chemlight_green",
						"Chemlight_red",
						"Chemlight_yellow",
						"Chemlight_blue"
						];
						
_Grenades_ALL = 		_Grenades_Hand +
						_Grenades_Smoke +
						_Grenades_Light;

_Shell_Smokes = 		[
//						"1Rnd_Smoke_Grenade_shell",
//						"1Rnd_SmokeRed_Grenade_shell",
//						"1Rnd_SmokeGreen_Grenade_shell",
//						"1Rnd_SmokeYellow_Grenade_shell",
//						"1Rnd_SmokePurple_Grenade_shell",
//						"1Rnd_SmokeBlue_Grenade_shell",
//						"1Rnd_SmokeOrange_Grenade_shell",
						"3Rnd_Smoke_Grenade_shell",
						"3Rnd_SmokeRed_Grenade_shell",
						"3Rnd_SmokeGreen_Grenade_shell",
						"3Rnd_SmokeYellow_Grenade_shell",
						"3Rnd_SmokePurple_Grenade_shell",
						"3Rnd_SmokeBlue_Grenade_shell",
						"3Rnd_SmokeOrange_Grenade_shell"
						];
						
_Shell_Flares = 		[
//						"UGL_FlareWhite_F",
//						"UGL_FlareGreen_F",
//						"UGL_FlareRed_F",
//						"UGL_FlareYellow_F",
//						"UGL_FlareCIR_F",
						"3Rnd_UGL_FlareWhite_F",
						"3Rnd_UGL_FlareGreen_F",
						"3Rnd_UGL_FlareRed_F",
						"3Rnd_UGL_FlareYellow_F",
						"3Rnd_UGL_FlareCIR_F"
						];
						
_Shell_Grenade = 		[
						"3Rnd_HE_Grenade_shell",
						"1Rnd_HE_Grenade_shell",
						"1Rnd_HE_Grenade_shell"
						];
						
_Shell_ALL = 			_Shell_Smokes +
						_Shell_Flares +
						_Shell_Grenade;

_Radios = 				[
						"EpochRadio0",
						"EpochRadio1",
						"EpochRadio2",
						"EpochRadio3",
						"EpochRadio4",
						"EpochRadio5",
						"EpochRadio6",
						"EpochRadio7",
						"EpochRadio8",
						"EpochRadio9"
						];

_BeltItems = 			[
						"ItemCompass",
						"ItemGPS",
						"ItemWatch",
						"Binocular",
						"NVG_EPOCH",
						"Rangefinder"
						];
/////////////////////////////////////////////////////////////////////////////////////////////////
_Ammo762 =				[
						"20Rnd_762x51_Mag",
						"10Rnd_762x54_Mag",
						"30Rnd_762x39_Mag",
						"20rnd_762_magazine",
						"150Rnd_762x54_Box",
						"150Rnd_762x54_Box_Tracer"
						];
						
_Ammo127 = 				[
						"5Rnd_127x108_Mag",
						"5Rnd_127x108_APDS_Mag"
						];
						
_Ammo65 = 				[
						"30Rnd_65x39_caseless_green",
						"30Rnd_65x39_caseless_green_mag_Tracer",
						"30Rnd_65x39_caseless_mag",
						"30Rnd_65x39_caseless_mag_Tracer",
						"200Rnd_65x39_cased_Box",
						"100Rnd_65x39_caseless_mag",
						"200Rnd_65x39_cased_Box_Tracer",
						"100Rnd_65x39_caseless_mag_Tracer"
						];
						
_Ammo556 = 				[
						"20Rnd_556x45_UW_mag",
						"30Rnd_556x45_Stanag",
						"30Rnd_556x45_Stanag_Tracer_Red",
						"30Rnd_556x45_Stanag_Tracer_Green",
						"30Rnd_556x45_Stanag_Tracer_Yellow",
						"200Rnd_556x45_M249"
						];
						
_AmmoMarks =			[
						"10Rnd_338_Mag",
						"20Rnd_762x51_Mag",
						"10Rnd_127x54_Mag",
						"10Rnd_93x64_DMR_05_Mag"
						];
_AmmoMarksMMG =			[
						"150Rnd_93x64_Mag",
						"130Rnd_338_Mag"
						];
						
_AmmoOther = 			[
						"7Rnd_408_Mag",
						"spear_magazine",
						"5Rnd_rollins_mag"
						];
						
_AmmoHandGun = 			[
						"30Rnd_45ACP_Mag_SMG_01",
						"30Rnd_45ACP_Mag_SMG_01_Tracer_Green",
						"9Rnd_45ACP_Mag",
						"11Rnd_45ACP_Mag",
						"6Rnd_45ACP_Cylinder",
						"16Rnd_9x21_Mag",
						"30Rnd_9x21_Mag",
						"10rnd_22X44_magazine",
						"9rnd_45X88_magazine",
						"6Rnd_GreenSignal_F",
						"6Rnd_RedSignal_F"
						];
						
_Ammo_ALL = 			_Ammo762 +
						_Ammo127 +
						_Ammo65 +
						_Ammo556 +
						_AmmoMarks +
//						_AmmoMarksMMG +
						_AmmoOther +
						_AmmoHandGun;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

_Pistols = 				[
						["hgun_PDW2000_F",						"30Rnd_9x21_Mag"],
						["hgun_ACPC2_F",						"9Rnd_45ACP_Mag"],
						["hgun_Rook40_F",						"30Rnd_9x21_Mag"],
						["hgun_P07_F",							"30Rnd_9x21_Mag"],
						["hgun_Pistol_heavy_01_F",				"11Rnd_45ACP_Mag"],
						["hgun_Pistol_heavy_02_F",				"6Rnd_45ACP_Cylinder"],
						["ruger_pistol_epoch",					"10rnd_22X44_magazine"],
						["1911_pistol_epoch",					"9rnd_45X88_magazine"],
						["hgun_Pistol_Signal_F",				"6Rnd_RedSignal_F0"]
						];

_RifleSniper762 = 		[
						["srifle_EBR_F",						"20Rnd_762x51_Mag"],
						["srifle_DMR_01_F",						"20Rnd_762x51_Mag"],
						["M14_EPOCH",							"20Rnd_762x51_Mag"],
						["M14Grn_EPOCH",						"20Rnd_762x51_Mag"]
						];
						
_RifleSniper127 = 		[
						["srifle_GM6_F",						"5Rnd_127x108_Mag"],
						["m107Tan_EPOCH",						"5Rnd_127x108_Mag"],
						["m107_EPOCH",							"5Rnd_127x108_Mag"]
						];
						
_RifleSniper408 = 		[
						["srifle_LRR_F",						"7Rnd_408_Mag"]
						];
						
_RifleSniper65 = 		[
						["arifle_MXM_F",						"30Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MXM_Black_F",					"30Rnd_65x39_caseless_mag_Tracer"]
						];

_RifleLMG762 = 			[
						["LMG_Zafir_F",							"150Rnd_762x54_Box_Tracer"]
						];
						
_RifleLMG65 = 			[
						["LMG_Mk200_F",							"200Rnd_65x39_cased_Box_Tracer"],
						["arifle_MX_SW_F",						"100Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MX_SW_Black_F",				"100Rnd_65x39_caseless_mag_Tracer"]
						];
						
_RifleLMG556 = 			[
						["m249_EPOCH",							"200Rnd_556x45_M249"],
						["m249Tan_EPOCH",						"200Rnd_556x45_M249"]
						];					
_RifleMarksMMG = 		[
						["MMG_01_hex_F",						"150Rnd_93x64_Mag"],
						["MMG_01_tan_F",						"150Rnd_93x64_Mag"],
						["MMG_02_camo_F",						"130Rnd_338_Mag"],
						["MMG_02_black_F",						"130Rnd_338_Mag"],
						["MMG_02_sand_F",						"130Rnd_338_Mag"]
						];
_Rifle65Lnchr = 		[
						["arifle_Katiba_GL_F",					"30Rnd_65x39_caseless_green_mag_Tracer"],
						["arifle_MX_GL_F",						"30Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MX_GL_Black_F",				"30Rnd_65x39_caseless_mag_Tracer"]
						];
						
_Rifle556Lnchr = 		[
						["arifle_Mk20_GL_F",					"30Rnd_556x45_Stanag_Tracer_Yellow"],
						["arifle_Mk20_GL_plain_F",				"30Rnd_556x45_Stanag_Tracer_Yellow"],
						["arifle_TRG21_GL_F",					"30Rnd_556x45_Stanag_Tracer_Green"]
						];
						
_RifleAssault762 = 		[
						["AKM_EPOCH",							"30Rnd_762x39_Mag"]
						];
						
_RifleAssault65 = 		[
						["arifle_Katiba_C_F",					"30Rnd_65x39_caseless_green_mag_Tracer"],
						["arifle_Katiba_F",						"30Rnd_65x39_caseless_green_mag_Tracer"],
						["arifle_MXC_F",						"30Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MX_F",							"30Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MX_Black_F",					"30Rnd_65x39_caseless_mag_Tracer"],
						["arifle_MXC_Black_F",					"30Rnd_65x39_caseless_mag_Tracer"]
						];
						
_RifleAssault556 = 		[
						["arifle_TRG21_F",						"30Rnd_556x45_Stanag_Tracer_Green"],
						["arifle_TRG20_F",						"30Rnd_556x45_Stanag_Tracer_Yellow"],
						["arifle_Mk20_plain_F",					"30Rnd_556x45_Stanag_Tracer_Red"],
						["arifle_Mk20C_plain_F",				"30Rnd_556x45_Stanag_Tracer_Red"],
						["arifle_Mk20C_F",						"30Rnd_556x45_Stanag_Tracer_Red"],
						["arifle_Mk20_F",						"30Rnd_556x45_Stanag_Tracer_Green"],
						["m16_EPOCH",							"30Rnd_556x45_Stanag_Tracer_Yellow"],
						["m16Red_EPOCH",						"30Rnd_556x45_Stanag_Tracer_Green"],
						["m4a3_EPOCH",							"30Rnd_556x45_Stanag_Tracer_Red"]
						];
						
_RifleMarks = 			[
						["srifle_DMR_02_F",						"10Rnd_338_Mag"],
						["srifle_DMR_02_camo_F",				"10Rnd_338_Mag"],
						["srifle_DMR_02_sniper_F",				"10Rnd_338_Mag"],
						["srifle_DMR_03_F",						"20Rnd_762x51_Mag"],
						["srifle_DMR_03_khaki_F",				"20Rnd_762x51_Mag"],
						["srifle_DMR_03_tan_F",					"20Rnd_762x51_Mag"],
						["srifle_DMR_03_multicam_F",			"20Rnd_762x51_Mag"],
						["srifle_DMR_03_woodland_F",			"20Rnd_762x51_Mag"],
						["srifle_DMR_06_camo_F",				"20Rnd_762x51_Mag"],
						["srifle_DMR_06_olive_F",				"20Rnd_762x51_Mag"],
						["srifle_DMR_04_Tan_F",					"10Rnd_127x54_Mag"],
						["srifle_DMR_05_blk_F",					"10Rnd_93x64_DMR_05_Mag"],
						["srifle_DMR_05_hex_F",					"10Rnd_93x64_DMR_05_Mag"],
						["srifle_DMR_05_tan_F",					"10Rnd_93x64_DMR_05_Mag"]
						];

_RifleSniper = 			_RifleSniper762 +
						_RifleSniper127 +
						_RifleSniper408 +
						_RifleSniper65 +
						_RifleMarks;
						
_RifleLMG =				_RifleLMG762 +
						_RifleLMG65 +
//						_RifleMarksMMG +
						_RifleLMG556;
						
_RifleLnchr =			_Rifle65Lnchr +
						_Rifle556Lnchr;
						
_RifleAssault =			_RifleAssault762 +
						_RifleAssault65 +
						_RifleAssault556 +
						_RifleLnchr;
	
_Rifle_Mid =			_RifleAssault +
						_RifleLnchr;
						
_Rifle_Heavy =			_RifleSniper +
						_RifleLMG;
						
_Rifle_ALL =			_RifleSniper +
						_RifleLMG +
						_RifleLnchr +
						_RifleAssault;
						
_WeaponAttachments_Optics =[
// 						"optic_Nightstalker",
						"optic_Arco",
						"optic_Hamr",
						"optic_Aco",
						"optic_ACO_grn",
						"optic_Aco_smg",
						"optic_ACO_grn_smg",
						"optic_Holosight",
						"optic_Holosight_smg",
						"optic_SOS",
						"optic_MRCO",
						"optic_DMS",
						"optic_Yorris",
						"optic_MRD",
						"optic_LRPS",
						"optic_NVS",
						"optic_tws",
						"optic_tws_mg"
						];

_WeaponAttachments_Muzzle =[
						"muzzle_snds_H",	// 6.5mm
						"muzzle_snds_L",	// 9mm
						"muzzle_snds_M", 	// 556mm
						"muzzle_snds_B", 	// 7.62mm
						"muzzle_snds_H_MG",	// 6.5 LMG
						"muzzle_snds_acp"	// 45 cal
						];

_WeaponAttachments_Other = [
						"acc_flashlight",
						"acc_pointer_IR"
						];

_out = switch (_loadout) do {
	case 0:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 1:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 2:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 3:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 4:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 5:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 6:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 7:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 8:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 9:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
	case 10:{
		[
			[_Backpacks_All,[2,0]],
			[_Food_All,[2,1]],
			[_Drink,[2,1]],
			[_BeltItems,[0,1]],
			[_OtherItems,[0,1]],
			[_Medical,[0,1]],
			[_Gems,[0,1]],
			[_Explosives,[0,1]],
			[_Grenades_ALL,[0,3]],
			[_Rifle_ALL,[1,3]],
			[_Ammo_ALL,[1,3]],
			[_Shell_ALL,[0,3]],
			[_WeaponAttachments_Optics,[0,2]],
			[_WeaponAttachments_Muzzle,[0,2]],
			[_WeaponAttachments_Other,[0,2]],
			[_BuildingKits,[1,4]],
			[_BuildingComponents,[1,5]],
			[_CraftingTools,[0,2]],
			[_CraftingComponents,[0,1]],
			["FAK",[1,3]]
		];
	};
};

{
	_objArr = _x select 0;
	_countarr = _x select 1;
	_min = _countarr select 0;
	_add = round (random (_countarr select 1));
	if (_objArr isequaltype "") then {
		_crate additemcargoGlobal [_objArr, _min + _add];
	}
	else {
		for "_i" from 1 to (_min + _add) do {
			_item = selectrandom _objArr;
//			_objArr = _objArr - [_item];
			if (_item isequaltype []) then {
				_crate addWeaponCargoGlobal [(_item select 0), 1];
				_crate addMagazineCargoGlobal [(_item select 1), 2];
			}
			else {
				if (_item iskindof "Bag_Base") then {
					_crate addbackpackcargoGlobal [_item,1];
				}
				else {
					_crate additemcargoGlobal [_item, 1];
				};
			};
		};
	};
} foreach _out;
	
