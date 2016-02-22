_sniper = _this;

_patrols_distance = [patrol_groups, [_sniper], {(leader _x) distance2D _input0}, "DESCEND"] call BIS_fnc_sortBy;

if (count _patrols_distance > 0) then {
	_closest = _patrols_distance select 0;
	
	while {(count (waypoints _closest)) > 1} do {
		deleteWaypoint ((waypoints _closest) select 1);
	};
	
	_wp = _closest addWaypoint [getPos _sniper, 0, 1];
	_wp setWaypointType "SAD";
	_wp setWaypointBehaviour "AWARE";
	_wp setWaypointSpeed "NORMAL";
	_wp setWaypointCombatMode "RED";
	
	_closest setCurrentWaypoint _wp;
};