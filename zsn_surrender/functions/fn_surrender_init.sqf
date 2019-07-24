if (isServer) then {
	params ["_unit"];
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
		_unit setvariable ["ZSN_Dammage", 0, true];
		_unit setvariable ["ZSN_isUnconscious", false, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		[{(_this) call BIS_fnc_enemyDetected}, {
			private ["_unit", "_ms"];
			_unit = _this;
			_ms = side _unit;
			if (!(_unit in zsn_pa)) then {
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
						if (!(_unit getVariable "ZSN_isSurrendering")) then {
							if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
								if (fleeing _unit) then {
									if (!(isNull objectParent _unit)) then {unassignVehicle _unit;};
									[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
								};
							};
						};
						sleep _time;
					};
					cc = cc - [_unit];
					publicvariable "cc";
					[count cc, cc] remoteexec ["zsn_fnc_hint"];
				};
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
		_unit call ZSN_fnc_Dammage;
	};
};