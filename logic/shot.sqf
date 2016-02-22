_unit = _this select 0;
_weapon = _this select 1;
_magazine = _this select 5;

_snipers = ["srifle_LRR_F", "hlc_rifle_awmagnum"];

if (_weapon != "Put") then {
	if (!shit_meet_fan) then {
		[[[],"ai\shitFan.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_MP;
	};
	
	if (_weapon in _snipers) then {
		[[_unit, "ai\sniperHunt.sqf"],"BIS_fnc_execVM",false,false] call BIS_fnc_MP;
	};
};