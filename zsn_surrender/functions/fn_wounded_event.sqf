params ["_unit"];
_unit addEventHandler["HandleDamage",{
	[_this select 0, _this select 1, _this select 2] call {
		private ["_unit","_part","_dmg","_ms"];
		_unit = _this select 0;
		_part = _this select 1;
		_dmg = _this select 2;
		_ms = side _unit;
		if (_dmg > 0.1) then {
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
		};
		if (_part isEqualTo "") then {damage _unit} else {_unit getHit _part};
	};
}];