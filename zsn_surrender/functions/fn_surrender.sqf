if (isserver) then {
	private ["_unit"];
	_unit = _this select 0;
	_unit addItem "ACE_CableTie";
	_unit setUnitPosWeak "UP";
	_unit setCombatMode "WHITE";
	_unit addEventHandler["HandleDamage",{
		[_this select 0, _this select 1, _this select 2] spawn {
			private ["_unit","_part","_dmg"];
			_unit=_this select 0;
			_part=_this select 1;
			_dmg=_this select 2;
			//hint format ["%1, %2", _part, _dmg];
			if (random 1 < _dmg) then {
				if (!(_unit in ([] call CBA_fnc_players))) then {
					if (isNull objectParent _unit) then {
						if (!(_unit getVariable "ACE_isUnconscious")) then {
							_unit spawn {
								private ["_unit","_ms"];
								_unit = _this;
								_ms = side _unit;
								sleep random 3;
								_unit setCaptive true;
								_unit setvariable ["ACE_isUnconscious", true, true];
								_unit setUnconscious true;
								waituntil {sleep random 3; (([_unit] call ACE_medical_fnc_isInStableCondition) OR (lifestate _unit != "INCAPACITATED"));};
								_unit setUnconscious false;
								[_unit, false] call ace_medical_fnc_setUnconscious;
								if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 1) then {[_unit, true] call ace_captives_fnc_setSurrendered;} else {_unit setCaptive false;};
							};
							0
						};
					};
				};
			};
		};
	}];
	_unit spawn {
		private ["_unit", "_ms"];
		_unit = _this;
		_ms = side _unit;
		waituntil {sleep random 3; _unit knowsAbout (_unit findNearestEnemy getpos _unit) == 4;};
		if (isNil "cc") then {cc = 0};
		waituntil {sleep random 3; cc < 32;};
		cc = cc + 1;
		publicVariable "cc";
		//hint format ["%1", cc];
		while {alive _unit} do {
			if (fleeing _unit) then {
				if (!(_unit in ([] call CBA_fnc_players))) then {
					if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
						if (!(isNull objectParent _unit)) then {unassignVehicle _unit;};
						[_unit, true] call ace_captives_fnc_setSurrendered;
						waituntil {sleep random 3; ((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] > 1) OR (!(alive _unit)));};
						[_unit, false] call ace_captives_fnc_setSurrendered;
					};
				};
			};
			sleep random 3;
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
						waituntil {sleep random 3; (behaviour _unit != "CARELESS") && (behaviour _unit != "SAFE")};
						_unit selectWeapon handgunWeapon _unit;
					};
				};
			};
			sleep random 3;
		};
	};
};