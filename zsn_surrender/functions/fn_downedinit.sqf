if (isServer) then {
	zsn_fleeingEH = {
		params ["_group"];
		_group addEventHandler ["Fleeing", {
			params ["_group", "_fleeingNow","_ms"];
			_ms = side _group;
			if (_fleeingNow) then {
				[_group, _ms, "is fleeing!"] remoteexec ["zsn_fnc_hint"];
				{
					[_x, _ms] spawn {
						params ["_unit","_ms","_time"];
						_time = _unit getVariable "ZSN_Time";
						while {(alive _unit && fleeing _unit) && !(_unit getVariable "ZSN_isSurrendering")} do {
							sleep _time;
							[_unit, _ms, _time] call zsn_fnc_surrendercycle;
						};
					};
				} forEach units _group;
			};
		}];
	};
	addMissionEventHandler ["GroupCreated", {
		_group call zsn_fleeingEH;
	}];
	{
		_x call zsn_fleeingEH;
	} foreach allGroups;
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_unconscious", {
			params ["_unit","_isUnconscious","_ms","_time"];
			_grp = group _unit;
			_ms = side _grp;
			if (_ms == CIVILIAN) exitwith {};
			if (_isUnconscious) then {
				_unit setCaptive true;
				if (!(hasinterface && isplayer _unit)) then {[_unit] joinsilent grpNull;};
			} else {
				[_unit, _ms, _time] spawn zsn_fnc_surrendercycle;
			};
		}] call CBA_fnc_addEventHandler;
	};
	if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
		["ace_captiveStatusChanged", {
			params ["_unit", "_state", "_reason", "_caller"];
			_grp = group _unit;
			_ms = side _grp;
			_time = _unit getVariable "ZSN_Time";
			if (_ms == CIVILIAN) exitwith {};
			if (_state) then {
				[_unit, _time, _ms] spawn {
					params ["_unit", "_time", "_ms"];
					_hopeless = [_unit, _ms] call zsn_fnc_findnearestenemy;
					while {_hopeless} do {
						sleep _time;
						_hopeless = [_unit, _ms] call zsn_fnc_findnearestenemy;
					};
					if (!(_unit getVariable ["ace_captives_isHandcuffed", false])) then {
						[_unit, false] call ace_captives_fnc_setSurrendered;
					};
				};
			} else {
				[_unit, _ms, _time] spawn zsn_fnc_surrendercycle;
			};
		}] call CBA_fnc_addEventHandler;
	};
};