if (isServer) then {
	zsn_fleeingEH = {
		params ["_group"];
		if (side _group == CIVILIAN) exitwith {};
		_group addEventHandler ["Fleeing", {
			params ["_group", "_fleeingNow","_ms"];
			_ms = side _group;
			if (_fleeingNow) then {
				[_group, _ms, "is fleeing!"] remoteexec ["zsn_fnc_hint"];
				{
					[_x, _ms] spawn {
						params ["_unit","_ms"];
						_time = time;
						waituntil {sleep random 4; ((([_unit, _ms] call zsn_fnc_findnearestenemy) || (time - _time > 600)) || ((!alive _unit) || (!fleeing _unit)))};
						if ((alive _unit && fleeing _unit) && [_unit, _ms] call zsn_fnc_findnearestenemy) then {
							[_unit, _ms] remoteexecCall ["zsn_fnc_surrendercycle", _unit];
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
			params ["_unit","_isUnconscious","_grp","_ms","_willdrop"];
			_grp = group _unit;
			_ms = side _grp;
			_willdrop = switch (ZSN_WeaponsDrop) do {
				case "true": {true};
				case "AI": {!(isplayer _unit)};
				case "false": {false};
			};
			if (_ms == CIVILIAN) exitwith {};
			if (_isUnconscious) then {
				_unit setCaptive true;
				if (primaryweapon _unit != "" && _willdrop) then {_unit call ace_hitreactions_fnc_throwWeapon};
				if (isplayer _unit) then {
					_unit remoteexec ["zsn_fnc_unconscious", _unit];
				} else {
					[_unit] joinsilent grpNull;
				};
			} else {
				[_unit, _ms] remoteexecCall ["zsn_fnc_surrendercycle", _unit];
			};
		}] call CBA_fnc_addEventHandler;
	};
	if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
		["ace_captiveStatusChanged", {
			params ["_unit", "_state", "_reason", "_caller"];
			_ms = _unit getVariable "ZSN_Side";
			if (_ms == CIVILIAN) exitwith {};
			if (_state) then {
//				if (_reason == "SetHandcuffed") then {[_unit, "Acts_ExecutionVictim_Loop", 2] call ace_common_fnc_doAnimation}
				[_unit, _ms] spawn {
					params ["_unit", "_ms"];
					waituntil {sleep 1; !([_unit, _ms] call zsn_fnc_findnearestenemy)};
					if (!(_unit getVariable ["ace_captives_isHandcuffed", false])) then {
						[_unit, false] call ace_captives_fnc_setSurrendered;
					};
				};
			} else {
				[_unit, _ms] remoteexecCall ["zsn_fnc_surrendercycle", _unit];
			};
		}] call CBA_fnc_addEventHandler;
	};
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_placedInBodyBag", {
			params ["_target", "_bodyBag"];
			_bodyBag setvariable ["ZSN_isRedeemable", true, true];
			_bodybag call zsn_fnc_redeemer;
		}] call CBA_fnc_addEventHandler;
	};
};