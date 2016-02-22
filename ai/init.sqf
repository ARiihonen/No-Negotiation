//this bit is for all AI scripts you want to run at mission start. Maybe you want to spawn in dudes or something.
{
	if (!isPlayer _x) then {
		_x execVM "ai\gear.sqf";
	};
} forEach allUnits;

{
	_prisoner = _x;
	_prisoner setCaptive true;
	{ _prisoner disableAI _x; } forEach ["MOVE", "AUTOTARGET"];
} forEach hostages;

_vehicles = [helo1, helo2];

if (low_players) then {
	_vehicles = _vehicles + [assault1, assault2, assault3];
	assault1 disableTIEquipment true;
};

{
	_grp = group driver _x;
	_units = [driver _x];
	
	{
		_unit = _x;
		_unit allowFleeing 0;
		
		{
			_unit disableAI _x;
		} forEach [
			"TARGET",
			"AUTOTARGET",
			"SUPPRESSION",
			"CHECKVISIBLE",
			"COVER",
			"AUTOCOMBAT"
		];
		
	} forEach _units;
} forEach _vehicles;

//Define mission-specific AI handling functions
noneg_routeCheck = {
	if (trigger_block1 getVariable ["clear", false] && trigger_block2 getVariable ["clear", false] && trigger_block3 getVariable ["clear", false]) then {
		route_cleared = true;
	} else {
		route_cleared = false;
	};
	
	if (!isServer) then {
		publicVariableServer "route_cleared";
	};
};

noneg_clearCheck = {
	if (trigger_area getVariable ["clear", false]) then {
		area_cleared = true;
	} else {
		area_cleared = false;
	};
	
	if (!isServer) then {
		publicVariableServer "route_cleared";
	};
};