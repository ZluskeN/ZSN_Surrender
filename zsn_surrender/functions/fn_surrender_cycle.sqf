params ["_unit","_ms","_time","_nearestenemy","_dist"];
if (alive _unit) then {
	if (!(_unit getVariable "ZSN_isUnconscious")) then {
		if (!(_unit getVariable "ZSN_isSurrendering")) then {
			{_unit reveal _x} foreach nearestObjects [_unit, ["AllVehicles"], 50];
			_nearestenemy = _unit findnearestenemy getpos _unit;
			_dist = ((getpos _nearestenemy) distance (getpos _unit));
			if((_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], _dist]) < 2) then {
				_unit setvariable ["ZSN_isSurrendering", true, true];
				if (!(isNull objectParent _unit)) then {doGetOut _unit;};
				[_unit, false, _ms] call zsn_fnc_recover;
				[_unit, "Surrendered to", _nearestenemy] remoteexec ["zsn_fnc_hint"];
				if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
					[_unit, true] call ace_captives_fnc_setSurrendered;
					waituntil {sleep _time; (_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], _dist]) > 1};
					_unit setvariable ["ZSN_isSurrendering", false, true];
					[_unit, false] call ace_captives_fnc_setSurrendered;
					_unit setCaptive false;
					[_unit, true, _ms] call zsn_fnc_recover;
					_unit setSuppression 0;
				} else {
					_unit setCaptive true;
					_unit action ["Surrender", _unit];
				};
			};
		} else {
			[_unit, false] call ace_captives_fnc_setSurrendered;
			_unit setCaptive false;
			[_unit, true, _ms] call zsn_fnc_recover;
			_unit setSuppression 0;
		};
	};
};