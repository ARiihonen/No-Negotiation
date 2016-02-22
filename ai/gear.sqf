#include "..\logic\gear.sqf"

//Get _this class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf _this;
_class = toUpper _class;

//Define default gear types. Leave as is if no change from default unit required (or remove both from here and from calls at the end of this file)
_uniform = "";
_vest = "";
_backpack = "";
_headwear = ["",""];

_items = [];
_link_items = [];
_item_weapons = [];

_primary_weapon = "";
_primary_weapon_items = [];
_primary_ammo_array = [];

_secondary_weapon = "";
_secondary_weapon_items = [];
_secondary_ammo_array = [];

_handgun = "";
_handgun_items = [];
_handgun_ammo_array = [];

_civilian_uniforms = [
	"U_C_Poloshirt_blue",
	"U_C_Poloshirt_burgundy",
	"U_C_Poloshirt_redwhite",
	"U_C_Poloshirt_salmon",
	"U_C_Poloshirt_stripped",
	"U_C_Poloshirt_tricolour",
	"U_Competitor",
	"U_BG_Guerilla3_1",
	"U_OrestesBody",
	"U_C_Journalist",
	"U_Marshal"
];

_civilian_headwears = [
	["H_Hat_tan", "H_Hat_grey", "H_Hat_brown", "H_Cap_tan", "H_Cap_surfer", "H_Cap_red", "H_Cap_oli", "H_Cap_grn", "H_Cap_blu", "H_Cap_blk", "H_Bandanna_surfer_grn", "H_Bandanna_surfer_blk", "H_Bandanna_surfer"],
	["G_Spectacles_Tinted", "G_Squares", "G_Squares_Tinted", "G_Spectacles"]
];

_guer_uniforms = [
	"U_BG_Guerrilla_6_1",
	"U_BG_Guerilla1_1",
	"U_BG_Guerilla2_1",
	"U_BG_Guerilla2_3",
	"U_BG_leader",
	"U_I_G_resistanceLeader_F"
];

_guer_vests = [
	"V_BandollierB_blk",
	"V_BandollierB_cbr",
	"V_BandollierB_rgr",
	"V_BandollierB_khk",
	"V_BandollierB_oli",
	"V_TacVest_blk",
	"V_TacVest_brn",
	"V_TacVest_khk",
	"V_TacVest_oli"
];

_guer_headwears = [
	[["H_Shemag_olive", "H_ShemagOpen_tan", "H_ShemagOpen_khk"],[""]],
	[[""],["G_Balaclava_blk", "G_Balaclava_oli" ]],
	[
		["H_Booniehat_tan", "H_Booniehat_oli", "H_Bandanna_sand", "H_Bandanna_gry", "H_Bandanna_blu", "H_Bandanna_cbr", "H_Bandanna_khk", "H_Bandanna_sgg"],
		["G_Sport_Blackred", "G_Sport_Checkered", "G_Sport_BlackWhite", "G_Sport_Blackyellow", "G_Sport_Red", "G_Shades_Red", "G_Shades_Green", "G_Shades_Blue", "G_Shades_Black", "G_Bandanna_blk", "G_Bandanna_khk", "G_Bandanna_oli", "G_Bandanna_tan"]
	]
];

if (side _this == west) then {
	
	_this call caran_clearInventory;
	
	_uniform = _guer_uniforms select floor random count _guer_uniforms;
	_vest = _guer_vests select floor random count _guer_vests;
	
	_headwears = _guer_headwears select floor random count _guer_headwears;
	_headwear = [(_headwears select 0) select floor random count (_headwears select 0), (_headwears select 1) select floor random count (_headwears select 1) ];
	if (random 1 < 0.8) then { _headwear set [0, ""]; };
	if (random 1 < 0.8) then { _headwear set [1, ""]; };
	
	_specialist_backpacks = [
		"B_TacticalPack_blk",
		"B_TacticalPack_rgr",
		"B_TacticalPack_oli"
	];
	
	_items = [ ["FirstAidKit", 2, "Vest"] ];
	_link_items = ["ItemMap", "ItemCompass", "ItemWatch", "ItemRadio"];
	
	_primary_weapon = "arifle_TRG21_F";
	_primary_ammo_array = ["30Rnd_556x45_Stanag", 10, "Vest"];
	
	if ("rhs_" call caran_checkMod) then {
		_primary_weapon = "rhs_weap_akm";
		_primary_ammo_array = ["rhs_30Rnd_762x39mm", 8, "Vest"];
	};
	
	if ("hlcweapons_aks" call caran_checkMod) then {
		_primary_weapon = "hlc_rifle_akm";
		_primary_ammo_array = ["hlc_30Rnd_762x39_b_ak", 6, "Vest"];
	};
	
	
	switch _class do {
		case "B_SOLDIER_AA_F": {
		
			_secondary_weapon = "launch_B_Titan_F";
			_secondary_ammo_array = ["Titan_AA", 2, "Backpack"];
			
			if ("rhs_" call caran_checkMod) then {
				_secondary_weapon = "rhs_weap_igla";
				_secondary_ammo_array = ["rhs_mag_9k38_rocket", 2, "Backpack"];
			};
			
			_backpack = _specialist_backpacks select floor random count _specialist_backpacks;
		};
		
		case "B_G_SOLDIER_LAT_F": {
			_secondary_weapon = "launch_RPG32_F";
			_secondary_ammo_array = ["RPG32_F", 4, "Backpack"];
			
			if ("rhs_" call caran_checkMod) then {
				_secondary_weapon = "rhs_weap_rpg7";
				_secondary_weapon_items = ["rhs_acc_pgo7v"];
				_secondary_ammo_array = ["rhs_rpg7_PG7VL_mag", 8, "Backpack"];
			};
			
			_backpack = _specialist_backpacks select floor random count _specialist_backpacks;
		};
		
		case "B_G_SOLDIER_AR_F": {
			_primary_weapon = "LMG_Mk200_F";
			_primary_weapon_items = ["bipod_01_F_snd"];
			_primary_ammo_array = ["200Rnd_65x39_cased_Box", 4, "Backpack"];
			
			if ("hlcweapons_aks" call caran_checkMod) then {
				_secondary_weapon = "hlc_rifle_rpk";
				_secondary_ammo_array = ["hlc_75Rnd_762x39_m_rpk", 6, "Backpack"];
			};
			
			if ("rhs_" call caran_checkMod) then {
				_secondary_weapon = "rhs_weap_pkp";
				_secondary_ammo_array = ["rhs_100Rnd_762x54mmR", 4, "Backpack"];
			};
			
			_backpack = _specialist_backpacks select floor random count _specialist_backpacks;
		};
		
		case "B_G_SHARPSHOOTER_F": {
			_primary_weapon = "srifle_DMR_06_olive_F";
			_primary_weapon_items = ["optic_DMS"];
			_primary_ammo_array = ["20Rnd_762x51_Mag", 6, "Vest"];
			
			if ("rhs_" call caran_checkMod) then {
				_primary_weapon = "rhs_weap_svdp";
				_primary_weapon_items = ["rhs_acc_pso1m2"];
				_primary_ammo_array = ["rhs_10Rnd_762x54mmR_7N1", 10, "Vest"];
			};
			
			_item_weapons = ["Binocular"];
		};
	};

	
} else {

	if (_class == "I_SOLDIER_UNARMED_F") then {
		_this call caran_clearInventory;
		_uniform = _civilian_uniforms select floor random count _civilian_uniforms;
		_headwear = [ (_civilian_headwears select 0) select floor random count (_civilian_headwears select 0),  (_civilian_headwears select 1) select floor random count (_civilian_headwears select 1) ];
	};
};

//Define and assign non-standard gear here.

//Adding gear. 
[_this, _uniform, _vest, _backpack, _headwear] call caran_addClothing;
[_this, _items] call caran_addInventoryItems;
[_this, _link_items] call caran_addLinkedItems;
[_this, _item_weapons] call caran_addInventoryWeapons;
[_this, _primary_weapon, _primary_weapon_items, _primary_ammo_array] call caran_addPrimaryWeapon;
[_this, _secondary_weapon, _secondary_weapon_items, _secondary_ammo_array] call caran_addSecondaryWeapon;