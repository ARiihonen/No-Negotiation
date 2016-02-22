#include "..\logic\gear.sqf"

//Get player class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf player;
_class = toUpper _class;

//Remove all gear. Remove if only adding items or swapping non-containers
player call caran_clearInventory;

//Define default gear types. Leave as is if no change from default unit required (or remove both from here and from calls at the end of this file)
_uniform = "U_I_CombatUniform";
_vest = "V_PlateCarrierIA2_dgtl";
_backpack = "";
_headwear = ["H_HelmetSpecB", "G_Bandanna_blk"];

_items = [ ["SmokeShell", 2, "Vest"], ["HandGrenade", 1, "Vest"] ];
_link_items = ["ItemMap", "ItemCompass", "ItemWatch"];
_item_weapons = [];

//Medical. ACE if active, vanilla if not
if ( "ace_" call caran_checkMod ) then {
	{ _items set [count _items, [_x, 4, "Uniform"]]; } forEach ["ACE_morphine", "ACE_epinephrine"];
	{ _items set [count _items, [_x, 8, "Uniform"]]; } forEach ["ACE_fieldDressing", "ACE_packingBandage"];
	_items set [count _items, ["ACE_tourniquet", 1, "Uniform"]];
} else {
	_items set [count _items, ["FirstAidKit", 2, "Uniform"]];
};

//ACRE Radio if active

if ( "acre_" call caran_checkMod ) then {
	_items set [count _items, ["ACRE_PRC343", 1, "Vest"]];
	
	if (player == leader group player) then {
		_items set [count _items, ["ACRE_PRC152", 1, "Vest"]];
	};
} else {
	_link_items set [count _link_items, "ItemRadio"];
};


//GPS. ACE microDAGR if active, vanilla GPS if not
if ( (player == leader group player) && (_class != "I_SNIPER_F") && (_class != "I_SPOTTER_F") ) then {
	if ( "ace_" call caran_checkMod ) then {
		_items set [count _items, ["ACE_microDAGR", 1, "Uniform"]];
	} else {
		_link_items set [count _link_items, "ItemGPS"];
	};
};

//Defusal kits for everyone if low players and ACE active
if (low_players && ( "ace_" call caran_checkMod ) ) then {
	_items set [count _items, ["ACE_DefusalKit", 1, "Uniform"]];
};

//Primary weapon
_primary_weapon = "arifle_MX_Black_F";
_primary_weapon_items = ["acc_pointer_IR", "optic_Aco"];
_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 8, "Vest"];

//Sidearm
_handgun = "hgun_ACPC2_F";
_handgun_items = [];
_handgun_ammo_array = ["9Rnd_45ACP_Mag", 3, "Vest"];

//Defining and assigning non-standard gear
switch _class do {
	
	//Platoon leader, squad leaders and team leaders get binoculars
	case "I_OFFICER_F": {
		_item_weapons set [count _item_weapons, "Binocular"];
	};
	
	case "I_SOLDIER_SL_F": { 
		_item_weapons set [count _item_weapons, "Binocular"];
	};
	
	case "I_SOLDIER_TL_F": { 
		_item_weapons set [count _item_weapons, "Binocular"];
	};
	
	//UAV Controller gets an UAV
	case "I_SOLDIER_UAV_F": {
		_link_items set [count _link_items, "I_UavTerminal"];
		_backpack = "I_UAV_01_backpack_F";
	};
	
	//Medic gets a backpack and medical supplies (ACE if active, vanilla if not)
	case "I_MEDIC_F": {
		_backpack = "B_AssaultPack_dgtl";
		
		if ( "ace_" call caran_checkMod ) then {
			_items set [ count _items, ["ACE_bloodIV", 5, "Backpack"]];
			{ _items set [count _items, [_x, 10, "Backpack"]]; } forEach ["ACE_morphine", "ACE_epinephrine", "ACE_tourniquet"];
			{ _items set [count _items, [_x, 20, "Backpack"]]; } forEach ["ACE_packingBandage", "ACE_fieldDressing"];
		} else {
			_items set [ count _items, ["Medikit", 1, "Backpack"]];
			_items set [ count _items, ["FirstAidKit", 10, "Backpack"]];
		};
	};
	
	//Sniper gear
	case "I_SNIPER_F": { 
		_headwear = ["H_Watchcap_camo", "G_Bandanna_blk"];
		
		//Give AWM if active
		if ( "hlcweapons_fhawcovert" call caran_checkMod ) then {
			_primary_weapon = "hlc_rifle_awmagnum";
			_primary_weapon_items = ["optic_LRPS"];
			_primary_ammo_array = ["hlc_5rnd_300WM_FMJ_AWM", 6, "Vest"];
		} else {
			_primary_weapon = "srifle_LRR_F";
			_primary_weapon_items = ["optic_LRPS"];
			_primary_ammo_array = ["7Rnd_408_Mag", 6, "Vest"];
		};
		
		//Give special scope if active
		if ( "rhsusf" call caran_checkMod ) then {
			_primary_weapon_items = ["rhsusf_acc_LEUPOLDMK4"];
		};
		
		//Give ACE sniper peripherals (wind meter, range card, DAGR) if active, rangefinder if not
		if ( "ace_" call caran_checkMod ) then {
			{ _items set [count _items, [_x, 1, "Uniform"]]; } forEach ["ACE_Kestrel4500", "ACE_RangeCard", "ACE_DAGR"];
			_item_weapons set [count _item_weapons, "ACE_Vector"];
		} else {
			_item_weapons set [count _item_weapons, "Rangefinder"];
		};

	};
	
	//Spotter gear
	case "I_SPOTTER_F": {
		_headwear = ["H_Watchcap_camo", "G_Bandanna_blk"];
		
		_primary_weapon = "arifle_MXM_Black_F";
		_primary_weapon_items = ["acc_pointer_IR", "optic_DMS", "bipod_03_F_blk"];
		_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 8, "Vest"];
		
		//Give ACE sniper peripherals (wind meter, range card, DAGR) if active, rangefinder if not
		if ( "ace_" call caran_checkMod ) then {
			{ _items set [count _items, [_x, 1, "Uniform"]]; } forEach ["ACE_Kestrel4500", "ACE_RangeCard", "ACE_DAGR"];
			_item_weapons set [count _item_weapons, "ACE_Vector"];
		} else {
			_item_weapons set [count _item_weapons, "Rangefinder"];
		};
	};
	
	//Marksman gear
	case "I_SOLDIER_M_F": {
		_primary_weapon = "arifle_MXM_Black_F";
		_primary_weapon_items = ["acc_pointer_IR", "optic_DMS", "bipod_03_F_blk"];
		_primary_ammo_array = ["30Rnd_65x39_caseless_mag", 8, "Vest"];
	};
	
	//Assaultrifleman gets LMG
	case "I_SOLDIER_AR_F": {
		_primary_weapon = "LMG_Zafir_F";
		_primary_weapon_items = ["acc_pointer_IR", "optic_Aco"];
		_primary_ammo_array = ["150Rnd_762x54_Box", 3, "Backpack"];
		
		_backpack = "B_assaultPack_dgtl";
	};
	
	//Explosive specialist
	case "I_SOLDIER_EXP_F": {
		if (low_players && !("ace_" call caran_checkMod) ) then {
			_backpack = "B_AssaultPack_dgtl";
			
			_items set [count _items, ["ToolKit", 1, "Backpack"]];
			_items set [count _items, ["MineDetector", 1, "Backpack"]];
		};
	};
};

//Adding gear. 
[player, _uniform, _vest, _backpack, _headwear] call caran_addClothing;
[player, _items] call caran_addInventoryItems;
[player, _link_items] call caran_addLinkedItems;
[player, _item_weapons] call caran_addInventoryWeapons;
[player, _primary_weapon, _primary_weapon_items, _primary_ammo_array] call caran_addPrimaryWeapon;
[player, _handgun, _handgun_items, _handgun_ammo_array] call caran_addHandgun;