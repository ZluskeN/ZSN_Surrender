params ["_unit"];
if (_unit getUnitTrait "Medic") then {
	_unit spawn zsn_fnc_medicloop;
};
_unit addEventHandler["HandleDamage",{
	[_this select 0, _this select 1, _this select 2, _this select 4] call {
		private ["_unit","_part","_dmg","_proj","_time","_ms"];
		_unit = _this select 0;
		_part = _this select 1;
		_dmg = _this select 2;
		_proj = _this select 3;
		_time = random 3;
		_ms = (_unit getVariable "ZSN_Side");
		if (lifestate _unit == "INCAPACITATED") then {
//		if (alive _unit) then {
//			if (_dmg > 0.1) then {
//				if (random 1 < _dmg) then {
				if (!(hasInterface && isPlayer _unit)) then {
					if (isNull objectParent _unit) then {
						if (!(_unit getVariable "ZSN_isUnconscious")) then {
							_unit setvariable ["ZSN_isUnconscious", true, true];
							[_unit, "Went down", _dmg] remoteexec ["zsn_fnc_hint"];	
							isNil {[_unit, false, _ms] call zsn_fnc_recover;};
							[_unit, _ms, _time] spawn {
								params ["_unit","_ms","_time"];
								while {(lifestate _unit == "INCAPACITATED")} do {
									sleep _time;
									_unit setSuppression 1;
									_unit setCaptive true;
								};
								if (!alive _unit) exitWith {};
								_unit allowFleeing 1;
								_unit setvariable ["ZSN_isUnconscious", false, true];
								isNil {[_unit, _ms, _time] call zsn_fnc_surrenderCycle;};
							};
						};
					};
				};
//				};
//			};
//		};
		};
		if (_proj isEqualTo "") then {
			if (_part isEqualTo "") then {damage _unit} else {_unit getHit _part};
		} else {_dmg};
	};
}];