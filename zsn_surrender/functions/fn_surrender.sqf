
_this spawn
{
	private ["_this", "_ms"];
	_this = _this select 0;
	_ms = side _this;
	_this addItem "ACE_CableTie";
	if (_this in playableunits) exitwith {};
	waituntil {sleep 1; _this knowsAbout (_this findNearestEnemy getpos _this) >= 1.5;};
	while {alive _this} do
	{
		if (fleeing _this) then
		{
			if(_ms countSide nearestObjects [getpos _this, ["AllVehicles"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] < 2) then
			{
				if (!(isNull objectParent _this)) then {unassignVehicle _this;};
				[_this, true] call ace_captives_fnc_setSurrendered;
				waituntil {sleep 0.1; _ms countSide nearestObjects [getpos _this, ["AllVehicles"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] >= 2;};
				[_this, false] call ace_captives_fnc_setSurrendered;
			};
		};
	};
};
_this spawn
{
	private ["_this"];
	_this = _this select 0;
	if (_this in playableunits) exitwith {};
	while {currentWeapon _this isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]} do
	{
		if (behaviour _this == "SAFE") then
		{
			[_this] call ace_weaponselect_fnc_putWeaponAway;
			waituntil {sleep 1; (behaviour _this != "SAFE");};
			_this selectWeapon handgunWeapon _this;
		};
		sleep 1;
	};
};