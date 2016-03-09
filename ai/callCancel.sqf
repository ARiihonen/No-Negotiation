if (clear_call) then {
	if (!helos_committed) then {
		[[[thanatos, "heloHolding"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
		
		{
			_grp = group (driver _x);
			_veh = _x;
			
			while {(count (waypoints _grp)) > 1} do {
				deleteWaypoint ((waypoints _grp) select 1);
			};
			
			_wp = _grp addWaypoint [markerPos "helo_loiter", 0, 1];
			_wp setWaypointType "LOITER";
			
			_grp setCurrentWaypoint [_grp, 1];
			
			_veh limitSpeed 200;
			
		} forEach [(helo1), (helo2)];
		
		clear_call = false;
		helos_called_back = true;
		publicVariable "clear_call";
		
	} else {
		[[[thanatos, "heloLanding"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
	};
	
	missionNamespace setVariable ["nagging_asshole", 0];
	
} else {

	_called_number = missionNamespace getVariable ["nagging_asshole", 0];
	
	if (_called_number > 2) then {
		if (_called_number == 3) then {
			[[[thanatos, "fuckOff"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
		};
	} else {
		[[[thanatos, "heloHolding"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
	};
	
	missionNamespace setVariable ["nagging_asshole", _called_number + 1];
};