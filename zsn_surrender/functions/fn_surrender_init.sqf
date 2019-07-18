if (isserver) then {
	private ["_unit"];
	_unit = _this select 0;
	if (isnil "zsn_pa") then {
		zsn_pa = [] call CBA_fnc_players;
		addMissionEventHandler ["PlayerConnected",{
			zsn_pa = [] call CBA_fnc_players;
			["Playerlist Updated", zsn_pa] remoteexec ["zsn_fnc_hint"];
		}];
		addMissionEventHandler ["PlayerDisconnected",{
			zsn_pa = [] call CBA_fnc_players;
			["Playerlist Updated", zsn_pa] remoteexec ["zsn_fnc_hint"];
		}];
	};
	if (isNil "cc") then {cc = []};
	publicVariable "cc";
	if (_unit isKindOf "CAManBase") then {
		_unit addItem "ACE_CableTie";
		_unit addEventHandler["HandleDamage",{
			[_this select 0, _this select 1, _this select 2] call {
				private ["_unit","_part","_dmg","_ms"];
				_unit = _this select 0;
				_part = _this select 1;
				_dmg = _this select 2;
				_ms = side _unit;
				if (random 1 < _dmg) then {
					if (!(_unit in zsn_pa)) then {
						if (isNull objectParent _unit) then {
							[_unit, _ms] spawn {
								private ["_unit","_ms","_time"];
								_unit = _this select 0;
								_ms = _this select 1;
								_time = random 3;
								sleep _time;
								if (!(_unit getVariable "ACE_isUnconscious")) then {
									_unit setCaptive true;
									_unit setvariable ["ACE_isUnconscious", true, true];
									_unit setUnconscious true;
									[_unit, "Went down"] remoteexec ["zsn_fnc_hint"];
									waituntil {sleep _time; (([_unit] call ACE_medical_fnc_isInStableCondition) OR (lifestate _unit != "INCAPACITATED"));};
									_unit setvariable ["ACE_isUnconscious", false, true];
									sleep _time;
									_unit setUnconscious false;
									if (_ms != CIVILIAN) then {
										if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 1) then {
											[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
											[_unit, "Surrendered"] remoteexec ["zsn_fnc_hint"];
										} else {
											_unit setCaptive false;
										};
									};
								};
							};
						};
					};
				} else {
					[_part, _dmg] remoteexec ["zsn_fnc_hint"];
				};
				if (_part isEqualTo "") then {damage _unit} else {_unit getHit _part};
			};
		}];
		[{(_this) call BIS_fnc_enemyDetected}, {
			private ["_unit", "_ms"];
			_unit = _this;
			_ms = side _unit;
			[_unit, _ms] spawn {
				private ["_unit", "_ms","_time"];
				_unit = _this select 0;
				_ms = _this select 1;
				_time = random 3;
				waituntil {sleep _time; ((count cc < 32) && (!(_unit in cc)));};
				cc pushback _unit;
				publicVariable "cc";
				[count cc, cc] remoteexec ["zsn_fnc_hint"];
				while {alive _unit} do {
					if (!(_unit in zsn_pa)) then {
						if (fleeing _unit) then {
							if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
								if (!(isNull objectParent _unit)) then {unassignVehicle _unit;};
								[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
								[_unit, "Surrendered"] remoteexec ["zsn_fnc_hint"];
							};
						};
					};
					sleep _time;
				};
				cc = cc - [_unit];
				publicvariable "cc";
				[count cc, cc] remoteexec ["zsn_fnc_hint"];
			};
		}, _unit] call CBA_fnc_waitUntilAndExecute;
		_unit setUnitPosWeak "UP";
		_unit setCombatMode "WHITE";
		if (currentWeapon _unit isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]) then {
			_unit spawn {
				private ["_unit","_time"];
				_unit = _this;
				_time = random 3;
				while {alive _unit} do {
					if (!(_unit in zsn_pa)) then {
						if ((behaviour _unit == "SAFE") OR (behaviour _unit == "CARELESS")) then {
							[_unit] call ace_weaponselect_fnc_putWeaponAway;
							waituntil {sleep _time; ((behaviour _unit != "CARELESS") && (behaviour _unit != "SAFE"));};
							_unit selectWeapon handgunWeapon _unit;
						};
					};
					sleep _time;
				};
			};
		};
	};
};