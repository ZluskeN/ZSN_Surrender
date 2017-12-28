if (isserver) then {
	private ["_this", "_ms"];
	_this = _this select 0;
	_ms = side _this;
	_this setUnitPosWeak "UP";
	_this seCombatMode "WHITE";
	_this addItem "ACE_CableTie";
	if (_this in playableunits) exitwith {};
	_this spawn {
		waituntil {sleep random 1; _this knowsAbout (_this findNearestEnemy getpos _this) == 4;};
		if (isNil "cc") then {cc = 0};
		waituntil {sleep random 1; cc < 36;};
		cc = cc + 1;
		publicVariable "cc";
		//hint format ["%1", cc];
		while {alive _this} do {
			if (fleeing _this) then {
				if(_ms countSide nearestObjects [getpos _this, ["AllVehicles"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] < 2) then {
					if (!(isNull objectParent _this)) then {unassignVehicle _this;};
					[_this, true] call ace_captives_fnc_setSurrendered;
					waituntil {sleep random 1; ((_ms countSide nearestObjects [getpos _this, ["AllVehicles"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] >= 2) OR (!(alive _this)));};
					[_this, false] call ace_captives_fnc_setSurrendered;
				};
			};
			sleep random 1;
		};
		cc = cc - 1;
		publicvariable "cc";
		//hint format ["%1", cc];
	};
	_this spawn {
		while {alive _this} do {
			if (currentWeapon _this isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]) then {
				if ((behaviour _this == "SAFE") OR (behaviour _this == "CARELESS")) then {
					[_this] call ace_weaponselect_fnc_putWeaponAway;
					waituntil {sleep random 1; (behaviour _this != "CARELESS") && (behaviour _this != "SAFE")};
					_this selectWeapon handgunWeapon _this;
				};
			};
			sleep random 1;
		};
	};
};