params ["_unit","_ms","_time","_nearestenemy","_dist"];
if (alive _unit) then {
	if (!(_unit getVariable "ZSN_isSurrendering")) then {
		{_unit reveal [_x, 4]} foreach nearestObjects [_unit, ["AllVehicles"], 100];
		_nearestenemy = _unit findnearestenemy getpos _unit;
		_dist = ((getpos _nearestenemy) distance (getpos _unit));
		if((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], _dist]) < 2) then {
			_unit setvariable ["ZSN_isSurrendering", true, true];
			if (!(isNull objectParent _unit)) then {doGetOut _unit;};
			isNil {[_unit, false, _ms] call zsn_fnc_recover;};
			[_unit, "Surrendered to", _nearestenemy] remoteexec ["zsn_fnc_hint"];
			_unit setCaptive true;
			if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
				isNil {[_unit, true] call ace_captives_fnc_setSurrendered};
				[_unit, _ms, _time] spawn {
					params ["_unit","_ms","_time","_nearestenemy","_dist"];
					_nearestenemy = _unit findnearestenemy getpos _unit;
					_dist = ((getpos _nearestenemy) distance (getpos _unit));
//					while {(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], _dist]) < 2} do {
					waitUntil{
						sleep _time;
						{_unit reveal [_x, 4]} foreach nearestObjects [_unit, ["AllVehicles"], 100];
						_nearestenemy = _unit findnearestenemy getpos _unit;
						_dist = ((getpos _nearestenemy) distance (getpos _unit)); 
						((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], _dist]) > 1)
					};
					_unit setvariable ["ZSN_isSurrendering", false, true];
					isNil {[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;};
				};
			} else {
				_unit action ["Surrender", _unit];
			};
		} else {
			_unit setvariable ["ZSN_isSurrendering", false, true];
			if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
				isNil {[_unit, false] call ace_captives_fnc_setSurrendered;};
			};
			_unit setCaptive false;
			[_unit, true, _ms] spawn zsn_fnc_recover;
			_unit setSuppression 0;
		};
	};
};