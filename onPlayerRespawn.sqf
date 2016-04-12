//This runs on every respawning player AND players spawning in for the first time EVEN IF description.ext has set respawnOnStart to 0. Yeah, I don't get it either.
#include "logic\activeMods.sqf";

_gear = player execVM "player\gear.sqf"; //running the gear script

if ( "task_force_radio" call caran_checkMod || "acre_" call caran_checkMod ) then {
	call caran_playerRadioSetup;
};

//disable TI if player assembles machinegun
player addEventHandler [
	"WeaponAssembled",
	{ (_this select 1) disableTIEquipment true; hint "assembled"; }
];