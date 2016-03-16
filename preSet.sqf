/*
This script is defined as a pre-init function in description.ext, meaning it runs before the map initialises.
*/
#include "logic\preInit.sqf"
#include "logic\activeMods.sqf"

if (isServer) then {
	//Randomizing unit presence variables using caran_randInt and caran_presenceArray
	_players = playersNumber resistance;
	low_players = if (_players <= 12) then { true; } else { false; }; //define the cutoff for AI reinforcements
	publicVariable "low_players";
	
	//define minimum and maximum standard enemy team members based on player amounts
	_minTeam = 4;
	_maxTeam = if (low_players) then { 4; } else { 6; };
	
	//same for hostage guard teams
	_minGuardTeam = 3;
	_maxGuardTeam = 4;
	
	hostages_big_upper = if (random 1 > 0.5) then { true; } else { false; };
	
	_mg_groups = [4, 3, 4] call caran_presenceArray;
	mg_1 = if (1 in _mg_groups) then { floor(random 9)+1; } else { 0; };
	mg_2 = if (2 in _mg_groups) then { floor(random 9)+1; } else { 0; };
	mg_3 = if (3 in _mg_groups) then { floor(random 9)+1; } else { 0; };
	mg_4 = if (4 in _mg_groups) then { floor(random 9)+1; } else { 0; };
	
	_sr_units = [4,0,3] call caran_presenceArray;
	sr_1 = if (1 in _sr_units) then { floor(random 5)+1; } else { 0; };
	sr_2 = if (2 in _sr_units) then { floor(random 6)+1; } else { 0; };
	sr_3 = if (3 in _sr_units) then { floor(random 9)+1; } else { 0; };
	
	aa_teams = [6,3,3] call caran_presenceArray;
	
	floor_1 = [7, _minTeam, _maxTeam] call caran_presenceArray;
	floor_2 = [15, _minTeam, _maxTeam] call caran_presenceArray;
	floor_3 = [17, _minTeam, _maxTeam] call caran_presenceArray;
	atc = [11, _minTeam, _maxTeam] call caran_presenceArray;
	
	guards_atc = [12, _minGuardTeam, _maxGuardTeam] call caran_presenceArray;
	guards_shack = [10, _minGuardTeam, _maxGuardTeam] call caran_presenceArray;
	guards_big = [10, _minGuardTeam, _maxGuardTeam] call caran_presenceArray;

	patrols = [10, 3, 4] call caran_presenceArray;
	
	//randomising hostage positions
	hostages_atc = [7, 1, 2] call caran_presenceArray;
	hostages_shack = [9, 3, 5] call caran_presenceArray;
	hostages_big = [9, 3, 5] call caran_presenceArray;

	//randomising prop positions
	room_door = [2,0] call caran_randInt;
	low_door = [1,0] call caran_randInt;;
	cargo_boxes = [1,0] call caran_randInt;;
	atc_table = [1,0] call caran_randInt;;
	atc_fridge = [1,0] call caran_randInt;;
	floor1_door1 = [2,0] call caran_randInt;;
	floor1_door2 = [2,0] call caran_randInt;;
	floor1_window = [1,0] call caran_randInt;;
	floor2_door = [2,0] call caran_randInt;;
	floor2_window = [1,0] call caran_randInt;;
	room_tables = [1,0] call caran_randInt;;
	
	//setting up lists for post-init unit scripts
	hostages = [];
	patrol_groups = [];
	
	//initialising mission-wide variables
	shit_meet_fan = false;
	
	assault_call = false;
	clear_call = false;
	helos_called_back = false;
	helos_committed = false;

	publicVariable "assault_call";
	publicVariable "clear_call";
	
	area_cleared = false;
	
	//Define strings to search for in active addons
	_checkList = [
		"ace_common",
		"asr_ai3_main",
		"task_force_radio",
		"hlcweapons_fhawcovert",
		"hlcweapons_aks",
		"acre_",
		"rhs_",
		"rhsusf_"
	];
	
	//Check mod checklist against active addons
	_checkList call caran_initModList;
};