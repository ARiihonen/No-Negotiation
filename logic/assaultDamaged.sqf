_unit = _this select 0;
_source = _this select 3;
dmg = _this select 2;

if (isNull _source) then {
	_unit setDamage 1;
	
	_unit removeEventHandler["HandleDamage", 0];
};

dmg