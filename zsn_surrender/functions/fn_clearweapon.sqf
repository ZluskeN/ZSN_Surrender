// Remove magazine from gun and add it to inventory
if (currentWeapon player isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {
	player addmagazine currentMagazine player;
	player removePrimaryWeaponItem currentMagazine player;
};