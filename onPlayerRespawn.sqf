//This runs on every respawning player AND players spawning in for the first time EVEN IF description.ext has set respawnOnStart to 0. Yeah, I don't get it either.
#include "logic\activeMods.sqf";

_gear = player execVM "player\gear.sqf"; //running the gear script

if ( "task_force_radio" call caran_checkMod || "acre_" call caran_checkMod ) then {
	call caran_playerRadioSetup;
};

if (low_players) then {
	player addAction [
		"<t color='#0000FF'>Roadblocks Cleared</t>", 
		{
			[[[],"ai\callAssault.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_MP;
		}, 
		nil, 
		4, 
		false
	];
};

player addAction [
	"<t color='#00FF00'>Area Clear</t>", 
	{
		[[[],"ai\callClear.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_MP;
	}, 
	nil, 
	4, 
	false
];

player addAction [
	"<t color='#FF0000'>Cancel All Clear</t>", 
	{
		[[[],"ai\callCancel.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_MP;
	}, 
	nil, 
	4, 
	false
];