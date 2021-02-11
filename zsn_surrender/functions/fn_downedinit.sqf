if (isServer) then {
	zsn_cc = [];
	publicVariable "zsn_cc";
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_unconscious", {
			params ["_unit","_isUnconscious","_ms","_time"];
			_ms = (_unit getVariable "ZSN_Side");
			_time = random 3;
			if (_isUnconscious && _ms != CIVILIAN) then {
				[_unit, false, _ms] remoteexec ["zsn_fnc_recover", _unit];
			} else {
				[_unit, _ms, _time] remoteexec ["zsn_fnc_surrenderCycle", _unit];
			};
		}] call CBA_fnc_addEventHandler;
	};
};