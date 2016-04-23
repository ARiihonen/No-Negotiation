//this bit is for all AI scripts you want to run at mission start. Maybe you want to spawn in dudes or something.
{
	_x execVM "ai\gear.sqf";
} forEach ( allUnits select { !isPlayer _x } );

{
	_x forceSpeed 0;
} forEach ( allUnits select { (side _x == west) && ([trigger_sieged, _x] call BIS_fnc_inTrigger) });

//set ai skills
_thing = execVM "ai\skills.sqf";

waitUntil { scriptDone _thing };
[(allUnits - playableUnits)] call ai_setSkills;

{
	_prisoner = _x;
	_prisoner setCaptive true;
	{ _prisoner disableAI _x; } forEach ["MOVE", "AUTOTARGET"];
} forEach hostages;

_vehicles = [helo1, helo2];

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