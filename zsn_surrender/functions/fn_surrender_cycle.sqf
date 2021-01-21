params ["_unit","_ms","_time","_nearestenemy","_dist","_isSurrendering","_fewfriends","_enemySides","_list","_nearEnemies","_nearestenemy","_targets"];
_isSurrendering = _unit getVariable "ZSN_isSurrendering";
_fewfriends = false;
if (!(hasinterface && isplayer _unit)) then {
	if (alive _unit && !_isSurrendering) then {
		_enemySides = _ms call BIS_fnc_enemySides;
		_list = getpos _unit nearEntities ["AllVehicles", 100];
		_nearEnemies = [_list, [_unit], {_unit distance _x}, "ASCEND", {side _x in _enemySides}] call BIS_fnc_sortBy;
		if (count _nearEnemies > 0) then {
			_nearestenemy = _nearEnemies select 0;
			_dist = _nearestenemy distance _unit;
			_targets = getpos _unit nearEntities ["AllVehicles", _dist];
			if (_ms countSide _targets < 3) then {_fewfriends = true};
		};
		if (_fewfriends) then {
			_unit setvariable ["ZSN_isSurrendering", true, true];
			if (!(isNull objectParent _unit)) then {
				doGetOut _unit;
				waitUntil {sleep _time; isNull objectParent _unit};
			};
			isNil {[_unit, false, _ms] call zsn_fnc_recover;};
			[_unit, "Surrendered to", _nearestenemy] remoteexec ["zsn_fnc_hint"];
			_unit setCaptive true;
			if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
				[_unit, true] call ace_captives_fnc_setSurrendered;
				[_unit, _ms, _time] spawn {
					params ["_unit","_ms","_time","_list"];
					waitUntil {
						sleep _time;
						_list = getpos _unit nearEntities ["AllVehicles", 100];
						{_unit reveal [_x, 4]} foreach _list;
						isnull (_unit findNearestEnemy _unit)
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
};
