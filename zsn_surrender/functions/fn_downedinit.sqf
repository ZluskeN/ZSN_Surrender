if (isServer) then {
	addMissionEventHandler ["GroupCreated", {
		params ["_group"];
		_group addEventHandler ["Fleeing", {
			params ["_group", "_fleeingNow"];
			if (_fleeingNow) then {
				_ms = side _group;
				[_group, "is fleeing!"] remoteexec ["zsn_fnc_hint"];
				{[_x, _ms] call ZSN_fnc_surrenderCycle} forEach units _group;
			};
		}];
	}];
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_unconscious", {
			params ["_unit","_isUnconscious","_ms","_time"];
//			_ms = (_unit getVariable "ZSN_Side");
			_ms = side group _unit;
			_time = random 3;
			if (_isUnconscious && _ms != CIVILIAN) then {
				[_unit, false, _ms] remoteexec ["zsn_fnc_recover", _unit];
			} else {
				[_unit, _ms, _time] remoteexec ["zsn_fnc_surrenderCycle", _unit];
			};
		}] call CBA_fnc_addEventHandler;
	};
};