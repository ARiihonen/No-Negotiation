if (!shit_meet_fan) then {

	shit_meet_fan = true;
	
	sleep 60;

	if (random 1 < 0.2) then {
		_gunMan = hostages select floor random count hostages;
		_gunMan addMagazines ["6Rnd_45ACP_Cylinder", 2]; 
		_gunMan addWeapon "hgun_Pistol_heavy_02_F";
	};

	{
		_x setCaptive false;
		_x enableAI "move";
		_x enableAI "autotarget";
	} forEach hostages;
};