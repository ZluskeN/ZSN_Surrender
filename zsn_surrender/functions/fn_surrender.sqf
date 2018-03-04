if (isserver) then {
	private ["_unit"];
	_unit = _this select 0;
	_unit addItem "ACE_CableTie";
	_unit setUnitPosWeak "UP";
	_unit setCombatMode "WHITE";
	_unit spawn {
		private ["_unit", "_ms"];
		_unit = _this;
		_ms = side _unit;
		waituntil {sleep random 1; _unit knowsAbout (_unit findNearestEnemy getpos _unit) == 4;};
		if (isNil "cc") then {cc = 0};
		waituntil {sleep random 1; cc < 36;};
		cc = cc + 1;
		publicVariable "cc";
		//hint format ["%1", cc];
		while {alive _unit} do {
			if (fleeing _unit) then {
				if (!(_unit in ([] call CBA_fnc_players))) then {
					if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
						if (!(isNull objectParent _unit)) then {unassignVehicle _unit;};
						[_unit, true] call ace_captives_fnc_setSurrendered;
						waituntil {sleep random 1; ((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] >= 2) OR (!(alive _unit)));};
						[_unit, false] call ace_captives_fnc_setSurrendered;
					};
				};
			};
			sleep random 1;
		};
		cc = cc - 1;
		publicvariable "cc";
		//hint format ["%1", cc];
	};
	_unit spawn {
		private ["_unit"];
		_unit = _this;
		while {alive _unit} do {
			if (!(_unit in ([] call CBA_fnc_players))) then {
				if (currentWeapon _unit isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]) then {
					if ((behaviour _unit == "SAFE") OR (behaviour _unit == "CARELESS")) then {
						[_unit] call ace_weaponselect_fnc_putWeaponAway;
						waituntil {sleep random 1; (behaviour _unit != "CARELESS") && (behaviour _unit != "SAFE")};
						_unit selectWeapon handgunWeapon _unit;
					};
				};
			};
			sleep random 1;
		};
	};
};