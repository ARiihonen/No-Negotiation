/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/

//set respawn tickets to 0
[missionNamespace, 1] call BIS_fnc_respawnTickets;
[missionNamespace, -1] call BIS_fnc_respawnTickets;

//add tasks
[true, "KillTerrorists", ["Show them how we deal with terrorists - neutralise all hostiles.", "Neutralise Terrorists", ""], nil, "ASSIGNED", 1, false, "kill", false] call BIS_fnc_taskCreate;
[true, "RescueHostages", ["Rescuing as many hostages as possible would be a nice PR bonus.", "Rescue (OPTIONAL)", ""], nil, "CREATED", 0, false, "heal", false] call BIS_fnc_taskCreate;

//handle hostiles reacting when players fire shots
{
	_x addEventHandler ["Fired", {_this execVM "logic\shot.sqf"} ];
} forEach playableUnits;

arty setVehicleAmmo 0;
arty addMagazineTurret ["6Rnd_155mm_Mo_smoke", [0]];

//handle mission ending
missionEnding = {
	_endState = "";
			
	if (trigger_area getVariable ["clear", false] && canMove helo1 && canMove helo2) then {
		["KillTerrorists", "SUCCEEDED", false] call BIS_fnc_taskSetState;
		_endState = "Win";
	} else {
		["KillTerrorists", "FAILED", false] call BIS_fnc_taskSetState;
		_endState = "Lose";
	};
	
	if ( { alive _x } count hostages > 0 ) then {
		["RescueHostages", "SUCCEEDED", false] call BIS_fnc_taskSetState;
	} else {
		["RescueHostages", "CANCELED", false] call BIS_fnc_taskSetState;
	};
	
	//Runs end.sqf on everyone. For varying mission end states, calculate the correct one here and send it as an argument for end.sqf
	[_endState,"end.sqf"] remoteExec ["BIS_fnc_execVM",0,false];
};

//end mission if players dead
trigger_dead = createTrigger ['EmptyDetector', [0,0,0], false];
trigger_dead setTriggerActivation ['NONE', 'PRESENT', false];
trigger_dead setTriggerStatements [
	"count playableUnits == 0",
	"call handleEnding;",
	""
];

playersBoarded = {
	{
		while {(count (waypoints _x)) > 1} do {
			deleteWaypoint ((waypoints _x) select 1);
		};
		
		_wp = _x addWaypoint [markerPos "helo_start", 0, 1];
		_wp setWaypointType "MOVE";
		
		_x setCurrentWaypoint [_x, 1];
		
	} forEach [(group helo1d), (group helo2d)];
	
	sleep 10;
	
	call missionEnding;
};

//end mission and send helicopters off if all players in helicopter
trigger_boarded = createTrigger ["EmptyDetector", [0,0,0], false];
trigger_boarded setTriggerActivation ["NONE", "PRESENT", false];
trigger_boarded setTriggerStatements [
	"{vehicle _x != helo1 && vehicle _x != helo2} count playableUnits == 0",
	"_ending = [] spawn playersBoarded;",
	""
];

//end mission if either helicopter is destroyed
trigger_helodown = createTrigger ["EmptyDetector", [0,0,0], false];
trigger_helodown setTriggerActivation ["None", "PRESENT", false];
trigger_helodown setTriggerTimeout [15,15,15,false];
trigger_helodown setTriggerStatements [
	"!canMove helo1 || !canMove helo2",
	"call missionEnding;",
	""
];

//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";