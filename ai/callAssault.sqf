if (!assault_call) then {
	[[[thanatos, "assaultStart"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;

	call noneg_routeCheck;
	assault_call = true;

} else {
	[[[thanatos, "assaultStarted"],"logic\radio.sqf"],"BIS_fnc_execVM",true,false] call BIS_fnc_MP;
};