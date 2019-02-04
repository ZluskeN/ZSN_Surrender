if (isserver) then {
	private ["_unit"];
	_unit = _this select 0;
	if (_unit isKindOf "CAManBase") then {
		_unit addItem "ACE_CableTie";
		_unit setUnitPosWeak "UP";
		_unit setCombatMode "WHITE";
		if (isnil "zsn_pa") then {
			zsn_pa = [] call CBA_fnc_players;
			addMissionEventHandler ["PlayerConnected",{
				zsn_pa = [] call CBA_fnc_players;
			}];
			addMissionEventHandler ["PlayerDisconnected",{
				zsn_pa = [] call CBA_fnc_players;
			}];
		};
		_unit addEventHandler["HandleDamage",{
			[_this select 0, _this select 1, _this select 2] spawn {
				private ["_unit","_part","_dmg"];
				_unit=_this select 0;
				_part=_this select 1;
				_dmg=_this select 2;
				//hint format ["%1, %2", _part, _dmg];
				if (random 1 < _dmg) then {
					if (!(_unit in zsn_pa)) then {
						if (isNull objectParent _unit) then {
							_unit spawn {
								private ["_unit","_ms"];
								_unit = _this;
								_ms = side _unit;
								sleep 1;
								if (!(_unit getVariable "ACE_isUnconscious")) then {
									_unit setCaptive true;
									_unit setvariable ["ACE_isUnconscious", true, true];
									_unit setUnconscious true;
									waituntil {sleep 3; (([_unit] call ACE_medical_fnc_isInStableCondition) OR (lifestate _unit != "INCAPACITATED"));};
									_unit setUnconscious false;
									_unit setvariable ["ACE_isUnconscious", false, true];
									if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 1) then {[_unit, true] call ace_captives_fnc_setSurrendered;} else {_unit setCaptive false;};
								};
							};
							if (_part isEqualTo "") then {damage _unit} else {_unit getHit _part};
						};
					};
				};
			};
		}];
		_unit spawn {
			private ["_unit", "_ms"];
			_unit = _this;
			_ms = side _unit;
			waituntil {sleep random 3; _unit call BIS_fnc_enemyDetected;};
			if (isNil "cc") then {cc = 0};
			waituntil {sleep random 3; cc < 32;};
			cc = cc + 1;
			publicVariable "cc";
			//hint format ["%1", cc];
			while {alive _unit} do {
				if (!(_unit in zsn_pa)) then {
					if (fleeing _unit) then {
						if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
							if (!(isNull objectParent _unit)) then {unassignVehicle _unit;};
							[_unit, true] call ace_captives_fnc_setSurrendered;
							waituntil {sleep 3; ((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] > 1) OR (!(alive _unit)));};
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
				if (!(_unit in zsn_pa)) then {
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
};
