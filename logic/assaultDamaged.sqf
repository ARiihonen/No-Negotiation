_unit = _this select 0;
_source = _this select 3;

if (isNull _source && !(_unit getVariable ["didBlowUp", false]) ) then {
	diag_log "";
	diag_log format ["UNIT %1 DAMAGED BY MINE OMG %2", _unit, _source];
	_unit setVariable ["didBlowUp", true, false];
	
	//"Bo_GBU12_LGB" createVehicle (getPos _unit);
	_unit setDamage 1;
};