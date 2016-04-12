#include "..\logic\activeMods.sqf"

//Get player class and make sure it's all uppercase since BI classnames are super inconsistent
_class = typeOf player;
_class = toUpper _class;

//Medical. ACE if active, vanilla if not
if ( "ace_" call caran_checkMod ) then {
	{
		for "_i" from 1 to 4 do {
			player addItemToUniform _x;
		};
	} forEach ["ACE_morphine", "ACE_epinephrine"];
	{
		for "_i" from 1 to 8 do {
			player addItemToUniform _x;
		};
	} forEach ["ACE_elasticBandage", "ACE_packingBandage"];
} else {
	for "_i" from 1 to 2 do {
		player addItemToUniform "FirstAidKit";
	};
};

//ACRE Radio if active, otherwise normal radio
if ( "acre_" call caran_checkMod ) then {
	player addItemToUniform "ACRE_PRC343";

	if (player == leader group player) then {
		player addItemToUniform "ACRE_PRC152";
	};
} else {
	player linkItem "ItemRadio";
};

//GPS. ACE microDAGR if active, vanilla GPS if not, also add maptools
if ( (player == leader group player) || (_class != "I_SNIPER_F") || (_class != "I_SPOTTER_F") ) then {
	if ( "ace_" call caran_checkMod ) then {
		player addItemToUniform "ACE_microDAGR";
		player addItemToUniform "ACE_MapTools";
	} else {
		player linkItem "ItemGPS";
	};
};

//Defining and assigning non-standard gear
switch _class do {
	
	//Medic extra gear
	case "I_MEDIC_F": {
		if ( "ace_" call caran_checkMod ) then {
			player addItemToBackpack "ACE_personalAidKit";
			for "_i" from 1 to 2 do { player addItemToBackpack "ACE_bloodIV"; };
			for "_i" from 1 to 4 do { player addItemToBackpack "ACE_BloodIV_500"; };
			for "_i" from 1 to 5 do { player addItemToBackpack "ACE_tourniquet"; };
			{ for "_i" from 1 to 10 do { player addItemToBackpack _x; }; } forEach ["ACE_morphine", "ACE_epinephrine", "ACE_atropine"];
			{ for "_i" from 1 to 25 do { player addItemToBackpack _x; }; } forEach ["ACE_packingBandage", "ACE_elasticBandage"];
		} else {
			player addItemToBackpack "Medikit";
			for "_i" from 1 to 10 do { player addItemToBackpack "FirstAidKit"; };
		};
	};
	
	//Sniper gear
	case "I_SNIPER_F": {
		
		//Give AWM if active
		if ( "hlcweapons_fhawcovert" call caran_checkMod ) then {
			player removeWeapon "srifle_GM6_LRPS_F";
			player removeMagazines "5Rnd_127x108_Mag";
			
			for "_i" from 1 to 6 do { player addItemToVest "hlc_5rnd_300WM_BTSP_AWM"; };
			player addWeapon "hlc_rifle_awmagnum";
		};
		
		//Give special scope if active, make sure that regular scope is added if not
		if ( "rhsusf" call caran_checkMod ) then {
			player addPrimaryWeaponItem "rhsusf_acc_LEUPOLDMK4";
		} else {
			if (!("optic_LRPS" in (primaryWeaponItems player) ) ) then {
				player addPrimaryWeaponItem "optic_LRPS";
			};
		};
		
		//Give ACE sniper peripherals (wind meter, range card, DAGR) if active, rangefinder if not
		if ( "ace_" call caran_checkMod ) then {
			{ player addItemToUniform _x; } forEach ["ACE_Kestrel4500", "ACE_RangeCard", "ACE_DAGR", "ACE_MapTools"];
			player addWeapon "ACE_Vector";
		} else {
			player addWeapon "Rangefinder";
		};

	};
	
	//Spotter gear
	case "I_SPOTTER_F": {
		//Give ACE sniper peripherals (wind meter, range card, DAGR) if active, rangefinder if not
		if ( "ace_" call caran_checkMod ) then {
			{ player addItemToUniform _x; } forEach ["ACE_Kestrel4500", "ACE_RangeCard", "ACE_DAGR", "ACE_MapTools"];
			player addWeapon "ACE_Vector";
		} else {
			player addWeapon "Rangefinder";
		};
	};
	
	//HMG Gunner
	case "I_SUPPORT_MG_F": {
		if ("rhsusf_" call caran_checkMod) then {
			removeBackpack player;
			player addBackpack "RHS_M2_Gun_Bag";
		};
	};
	
	//HMG Assistant
	case "I_SUPPORT_AMG_F": {
		if ("rhsusf_" call caran_checkMod) then {
			removeBackpack player;
			player addBackpack "RHS_M2_Tripod_Bag";
		};
	};
	
	//AT Rifleman
	case "I_SOLDIER_LAT_F": {
		if ("rhsusf_" call caran_checkMod) then {
			player addWeapon "rhs_weap_M136_hedp";
		} else {
			player addBackpack "B_AssaultPack_rgr";
			player addItemToBackpack "NLAW_F";
			player addWeapon "launch_NLAW_F";
			removeBackpack player;
		};
	};
};