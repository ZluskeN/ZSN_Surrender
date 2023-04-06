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
				if (primaryweapon _unit != "" && _willdrop) then {_unit remoteexecCall ["ace_hitreactions_fnc_throwWeapon", _unit]};
				_unit remoteexecCall ["zsn_fnc_unconscious", _unit];
			} else {
				_vehicle = vehicle _unit;
				if (_vehicle != _unit) then {
					_unit leaveVehicle _vehicle;
				};
				[_unit, _ms] spawn {
					params ["_unit", "_ms"];
					waituntil {sleep 1; vehicle _unit == _unit};
			//		if (isClass(configFile >> "CfgPatches" >> "vurtual_seat") && ZSN_SpawnStretcher) then {
			//			_pos = getPos _unit;
			//			_dir = getDir _unit;
			//			_stretcher = "vurtual_stretcher" createVehicle [random 10,random 10,0];
			//			_unit assignAsCargo _stretcher; 
			//			_unit moveincargo _stretcher; 
			//			_unit setcaptive true;
			//			_stretcher lock true; 
			//			_stretcher setDir _dir;
			//			_stretcher setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
			//		} else {
						[_unit, _ms] remoteexecCall ["zsn_fnc_surrendercycle", _unit];
			//		};
				};
			};
		}] call CBA_fnc_addEventHandler;
	};
	if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
		["ace_captiveStatusChanged", {
			params ["_unit", "_state", "_reason", "_caller"];
			_ms = _unit getVariable "ZSN_Side";
			if (_ms == CIVILIAN) exitwith {};
			if (_state) then {
				if (_reason == "SetHandcuffed") then {
					_unit setCaptive true;
					_unit remoteexecCall ["zsn_fnc_unconscious", _unit];
				} else {
					[_unit, _ms] spawn {
						params ["_unit", "_ms"];
						waituntil {sleep 1; !([_unit, _ms] call zsn_fnc_findnearestenemy)};
						if (!(_unit getVariable ["ace_captives_isHandcuffed", false])) then {
							[_unit, false] call ace_captives_fnc_setSurrendered;
						};
					};
				};
			} else {
				_vehicle = vehicle _unit;
				if (_vehicle != _unit) then {
					_unit leaveVehicle _vehicle;
				};
				[_unit, _ms] spawn {
					params ["_unit", "_ms"];
					waituntil {sleep 1; vehicle _unit == _unit};
					[_unit, _ms] remoteexecCall ["zsn_fnc_surrendercycle", _unit];
				};
			};
		}] call CBA_fnc_addEventHandler;
	};
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_placedInBodyBag", {
			params ["_target", "_bodyBag"];
			if (_target getVariable ["ZSN_isRedeemable", false]) then {
				_bodyBag setvariable ["ZSN_isRedeemable", true, true];
				if (isClass(configFile >> "CfgPatches" >> "Tun_Respawn")) then {
					_bodybag spawn zsn_fnc_redeemer;
				};
			};
			_objs = nearestObjects [getpos _bodyBag, ["Allvehicles"], 10];
			{if ([_bodyBag, _x, true] call ace_cargo_fnc_canLoadItemIn) exitWith {[_bodybag, _x, true] call ace_cargo_fnc_loadItem}} foreach _objs;
		}] call CBA_fnc_addEventHandler;
	};
};