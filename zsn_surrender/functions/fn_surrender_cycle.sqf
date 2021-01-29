params ["_unit","_ms","_time","_nearestenemy","_isSurrendering","_hopeless"];
_isSurrendering = _unit getVariable "ZSN_isSurrendering";
if (!(hasinterface && isplayer _unit)) then {
	if (alive _unit && !_isSurrendering) then {
		_hopeless = [_unit, _ms] call zsn_fnc_findnearestenemy;
		if (_hopeless) then {
			_unit setvariable ["ZSN_isSurrendering", true, true];
			if (!(isNull objectParent _unit)) then {
				doGetOut _unit;
				waitUntil {sleep _time; isNull objectParent _unit};
			};
			isNil {[_unit, false, _ms] call zsn_fnc_recover};
			_unit setCaptive true;
			if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
				[_unit, true] call ace_captives_fnc_setSurrendered;
				[_unit, _ms, _time] spawn {
					params ["_unit","_ms","_time"];
					waitUntil {
						sleep _time;
						_hopeless = [_unit, _ms] call zsn_fnc_findnearestenemy;
						!_hopeless
					};
					if (!(_unit getVariable ["ace_captives_isHandcuffed", false])) then {
						_unit setvariable ["ZSN_isSurrendering", false, true];
						[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
					};
				};
			} else {
				_unit action ["Surrender", _unit];
			};
		} else {
			_unit setvariable ["ZSN_isSurrendering", false, true];
			if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
				[_unit, false] call ace_captives_fnc_setSurrendered;
			};
			_unit setCaptive false;
			[_unit, true, _ms] spawn zsn_fnc_recover;
			_unit setSuppression 0;
		};
	};
} else {
	_unit setCaptive false;
};