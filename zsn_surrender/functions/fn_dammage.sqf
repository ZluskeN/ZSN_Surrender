params ["_unit", "_time"];
while {alive _unit} do {
	sleep _time;
	_ms = (_unit getVariable "ZSN_Side");	
	if ((lifestate _unit == "INCAPACITATED") && (isNull objectParent _unit)) then {
		if (!(_unit getVariable "ZSN_isUnconscious")) then {
			_unit setvariable ["ZSN_isUnconscious", true, true];
			[_unit, "Went down", _ms] remoteexec ["zsn_fnc_hint"];	
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