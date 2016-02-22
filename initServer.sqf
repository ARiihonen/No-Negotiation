/*
This runs on the server machine after objects have initialised in the map. Anything the server needs to set up before the mission is started is set up here.
*/

//set respawn tickets to 0
[missionNamespace, 1] call BIS_fnc_respawnTickets;
[missionNamespace, -1] call BIS_fnc_respawnTickets;

//Task setting: ["TaskName", locality, ["Description", "Title", "Marker"], target, "STATE", priority, showNotification, true] call BIS_fnc_setTask;
if (low_players) then {
	["ClearRoute", true, ["Clear the roadblocks before calling in the assault.", "Clear Roadblocks", ""], nil, "ASSIGNED", 2, false, true] call BIS_fnc_setTask;
} else {
	deleteVehicle trigger_assault;
};

["KillTerrorists", true, ["Show them how we deal with terrorists - neutralise all hostiles.", "Neutralise Terrorists", ""], nil, "CREATED", 1, false, true] call BIS_fnc_setTask;

["RescueHostages", true, ["Rescuing as many hostages as possible would be a nice PR bonus.", "Rescue (OPTIONAL)", ""], nil, "CREATED", 0, false, true] call BIS_fnc_setTask;

//Spawns a thread that will run a loop to keep an eye on mission progress and to end it when appropriate, checking which ending should be displayed.
_progress = [] spawn {
	
	//Init all variables you need in this loop
	_ending = false;
	_players_dead = false;
	_helo_down = false;
	_players_boarded = false;
	
	{
		_x addEventHandler ["Fired", {_this execVM "logic\shot.sqf"} ];
	} forEach playableUnits;
	
	//Event handler for failing roadblock task if assault forces run into a mine
	if (low_players) then {
		{
			_x addEventHandler ["HandleDamage", {_this execVM "logic\assaultDamaged.sqf"} ];
		} forEach [assault1, assault2, assault3];
	} else {
		{ deleteMarker _x; } forEach ["marker_block1", "marker_block2", "marker_block3"];
	};
	
	//Starts a loop to check mission status every second, update tasks, and end mission when appropriate
	while {!_ending} do {
		
		//Mission ending condition check
		if ( _players_dead || _players_boarded || _helo_down ) then {
			_ending = true;
			
			sleep 15;
			
			_endState = "";
			
			if (low_players) then {
				if ( (assault1 getVariable ["didBlowUp", false]) || (assault1 getVariable ["didBlowUp", false]) || (assault1 getVariable ["didBlowUp", false]) ) then {
					["ClearRoute", "FAILED", false] call BIS_fnc_taskSetState;
				} else {
					if (route_cleared) then {
						["ClearRoute", "SUCCEEDED", false] call BIS_fnc_taskSetState;
					} else {
						if (_players_dead) then {
							["ClearRoute", "FAILED", false] call BIS_fnc_taskSetState;
						} else {
							["ClearRoute", "CANCELED", false] call BIS_fnc_taskSetState;
						};
					};
				};
			};
			
			if (area_cleared && canMove helo1 && canMove helo2) then {
				["KillTerrorists", "SUCCEEDED", false] call BIS_fnc_taskSetState;
				
				_endState = "Win";
			} else {
				["KillTerrorists", "FAILED", false] call BIS_fnc_taskSetState;
				
				_endState = "Lose";
			};
			
			_hostageCounter = 0;
			{
				if (alive _x) then {
					_hostageCounter = _hostageCounter + 1;
				};
			} forEach hostages;
			
			if (_hostageCounter > 0) then {
				["RescueHostages", "SUCCEEDED", false] call BIS_fnc_taskSetState;
			} else {
				["RescueHostages", "CANCELED", false] call BIS_fnc_taskSetState;
			};
			
			//Runs end.sqf on everyone. For varying mission end states, calculate the correct one here and send it as an argument for end.sqf
			[[_endState,"end.sqf"], "BIS_fnc_execVM", true, false] spawn BIS_fnc_MP;
		};
		
		//Sets _players_dead as true if nobody is still alive
		_players_dead = true;
		{
			if (alive _x) then {
				_players_dead = false;
			};
		} forEach playableUnits;

		if (!canMove helo1 || !canMove helo2) then {
			_helo_down = true;
		};
		
		//Checks whether all live players are in helicopters and sends the helicopets off if they are
		if (!_players_boarded) then {
			_board_check = true;
			{ if (alive _x && vehicle _x != helo1 && vehicle _x != helo2) then { _board_check = false; } } forEach playableUnits;
		
			if (_board_check) then {
				_players_boarded = true;
				
				{
					while {(count (waypoints _x)) > 1} do {
						deleteWaypoint ((waypoints _x) select 1);
					};
					
					_wp = _x addWaypoint [markerPos "helo_start", 0, 1];
					_wp setWaypointType "MOVE";
					
					_x setCurrentWaypoint [_x, 1];
					
				} forEach [(group helo1d), (group helo2d)];
				
			};
		};
	};
};

//client inits wait for serverInit to be true before starting, to make sure all variables the server sets up are set up before clients try to refer to them (which would cause errors)
serverInit = true;
publicVariable "serverInit";