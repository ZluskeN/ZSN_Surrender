params ["_unit"];
_unit addEventHandler["HandleDamage",{
	[_this select 0, _this select 1, _this select 2] call {
		private ["_unit","_part","_dmg","_ms"];
		_unit = _this select 0;
		_part = _this select 1;
		_dmg = _this select 2;
		_ms = side _unit;
		if (_dmg > 0.05) then {
			if (random 1 < _dmg) then {
				if (!(_unit in zsn_pa)) then {
					if (isNull objectParent _unit) then {
						if (!(_unit getVariable "ZSN_isUnconscious")) then {
							if (alive _unit) then {
								_unit setvariable ["ZSN_isUnconscious", true, true];
								[_unit, _ms] spawn {
									private ["_unit","_ms","_time","_dmg","_hpa","_grp"];
									_unit = _this select 0;
									_ms = _this select 1;
									_time = random 3;
									_hpa = getAllHitPointsDamage _unit select 2;
									_dmg = selectMax _hpa;
									_grp = group _unit;
									_unit setvariable ["ZSN_Dammage", _dmg, true];
									_unit setSuppression 1;
									_unit setCaptive true;
									_unit setUnconscious true;
									[_unit, "Went down"] remoteexec ["zsn_fnc_hint"];
									while {(_unit getVariable "ZSN_Dammage" > 0.25) && (lifestate _unit == "INCAPACITATED")} do {
										[_unit] joinsilent grpNull;
										_unit setSuppression 1;
										_hpa = getAllHitPointsDamage _unit select 2;
										_dmg = selectMax _hpa;
										_unit setvariable ["ZSN_Dammage", _dmg, true];
										sleep _time;
									};
									if (!alive _unit) exitWith {};
									sleep _time;
									_unit setUnconscious false;
									_unit setvariable ["ZSN_isUnconscious", false, true];
									if (!(_unit getVariable "ZSN_isSurrendering")) then {
										if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 2) then {
											[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
										} else {
											sleep _time;
											_unit setSuppression 0;
											private _friendlies = [];
											{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 50];
											_friendlies = [_friendlies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
											_grp = group (_friendlies select 0);
											[_unit] joinsilent _grp;
											["joined", _grp] remoteexec ["zsn_fnc_hint"];
											_unit setCaptive false;
										};
									};
								};
							};
						};
					};
				};
			} else {
				[_part, _dmg] remoteexec ["zsn_fnc_hint"];
			};
		};
		if (_part isEqualTo "") then {damage _unit} else {_unit getHit _part};
	};
}];
if (_unit getUnitTrait "Medic") then {
	if (!(_unit in zsn_pa)) then {
		_unit spawn {
			private ["_unit", "_healQueue","_healQueueTemp","_time","_patient"];
			_unit = _this;
			_time = random 3;
			_healQueue = [];
			while {alive _unit} do {
				sleep _time;
				_healQueueTemp = [];
				{if (lifestate _x == "INCAPACITATED") then {_healQueueTemp pushback _x;};} foreach nearestObjects [_unit, ["CAManBase"], 100];
				_healQueueTemp = [_healQueueTemp, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
				if (count _healQueueTemp > 0) then {
					_patient = _healQueueTemp select 0;
					if (!(_healQueueTemp  isEqualTo _healQueue)) then {
						_healQueue = _HealQueueTemp;
						_unit doMove getpos _patient;
						[_unit, _healQueue] remoteexec ["zsn_fnc_hint"];
					} else {
						if (_unit distance _patient < 5) then {
							_unit additem "FirstAidKit";
							_unit action ["HealSoldier", _patient];
							_healQueue deleteAt 0;
						};
					};
				};
			};
		};
	};
};