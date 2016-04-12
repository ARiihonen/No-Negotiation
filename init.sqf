//Runs on both server and clients after initServer.sqf is finished
waitUntil {!isNil "serverInit"};
waitUntil {serverInit};

#include "logic\activeMods.sqf"

//initialise mods if active
if ( "task_force_radio" call caran_checkMod ) then {
	_load = [] execVM "mods\tfar.sqf";
};

if ("acre_" call caran_checkMod ) then {
	_load = [] execVM "mods\acre.sqf";
};

if ( "ace_" call caran_checkMod ) then {
	_load = [] execVM "mods\ace.sqf";
};

//Player init: this will only run on players. Use it to add the briefing and any player-specific stuff like action-menu items.
if (!isServer || (isServer && !isDedicated) ) then {
	//put in briefings
	briefing = [] execVM "briefing\briefing.sqf";
	
	//make player able to call in the support smoke artillery if he is the leader of his group
	trigger_dead = createTrigger ['EmptyDetector', [0,0,0], false];
	trigger_dead setTriggerActivation ['NONE', 'PRESENT', false];
	trigger_dead setTriggerStatements [
		"player == leader group player",
		"arty_module synchronizeObjectsAdd [player];",
		""
	];
};

execVM "logic\hcHandle.sqf";