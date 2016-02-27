if (!clear_call) then {
	[[[thanatos, "heloClear"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
	
	if (!helos_called_back) then {
		
		{
			_veh = call compile format ["helo%1", _x];
			_grp = call compile format ["group helo%1d", _x];
			
			_wpStart = markerPos "helo_start";
			_wpApproach = markerPos "helo_approach";
			_wpCommit = call compile format ["markerPos 'helo%1_commit'", _x];
			_wpFuck = call compile format ["markerPos 'helo%1_fuck'", _x];
			_wpLand = call compile format ["getPos helo_lz%1", _x];
			
			while {(count (waypoints _grp)) > 1} do {
				deleteWaypoint ((waypoints _grp) select 1);
			};
			
			_wp = _grp addWaypoint [_wpStart, 0, 1];
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointSpeed "NORMAL";
			_wp setWaypointCombatMode "GREEN";
			_wp setWaypointStatements ["true", "(vehicle _this) limitSpeed 100; (vehicle _this) flyInHeight 20;"];
			
			_wp = _grp addWaypoint [_wpApproach, 0, 2];
			_wp setWaypointStatements ["true", "(vehicle _this) limitSpeed 60; (vehicle _this) flyInHeight 20;"];
		
			_wp = _grp addWaypoint [_wpCommit, 0, 3];
			_wp setWaypointStatements ["true", "if (isServer) then { call noneg_clearCheck; helos_committed = true; };"];
			
			_wp = _grp addWaypoint [_wpFuck, 0, 4];
			
			_wp = _grp addWaypoint [_wpLand, 0, 5];
			_wp setWaypointType "TR UNLOAD";
			
			_grp setCurrentWaypoint ((waypoints _grp) select 1);
			
		} forEach ["1", "2"];
	
	} else {
	
		{
			_veh = call compile format ["helo%1", _x];
			_grp = call compile format ["group helo%1d", _x];

			_wpCommit = call compile format ["markerPos 'helo%1_commit'", _x];
			_wpFuck = call compile format ["markerPos 'helo%1_fuck'", _x];
			_wpLand = call compile format ["getPos helo_lz%1", _x];
			
			while {(count (waypoints _grp)) > 1} do {
				deleteWaypoint ((waypoints _grp) select 1);
			};

			_wp = _grp addWaypoint [_wpCommit, 0, 3];
			_wp setWaypointType "MOVE";
			_wp setWaypointBehaviour "SAFE";
			_wp setWaypointSpeed "NORMAL";
			_wp setWaypointCombatMode "GREEN";
			_wp setWaypointStatements ["true", "(vehicle _this) limitSpeed 100; (vehicle _this) flyInHeight 20; if (isServer) then { call noneg_clearCheck; helos_committed = true; };"];
			
			_wp = _grp addWaypoint [_wpFuck, 0, 4];
			
			_wp = _grp addWaypoint [_wpLand, 0, 5];
			_wp setWaypointType "TR UNLOAD";
			
			_grp setCurrentWaypoint ((waypoints _grp) select 1);
			
		} forEach ["1", "2"];
		
	};
	
	clear_call = true;
	publicVariable "clear_call";
} else {
	[[[thanatos, "heloComing"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
};