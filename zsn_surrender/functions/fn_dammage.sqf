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
						[_unit, _ms] spawn {
							private ["_unit","_ms","_time","_dmg","_hpa","_grp"];
							_unit = _this select 0;
							_ms = _this select 1;
							_time = random 3;
							_hpa = getAllHitPointsDamage _unit select 2;
							_dmg = selectMax _hpa;
							_grp = group _unit;
							_unit setvariable ["ZSN_Dammage", _dmg, true];
							sleep _time;
							if (alive _unit) then {
								if (!(_unit getVariable "ZSN_isUnconscious")) then {
									[_unit, "Went down"] remoteexec ["zsn_fnc_hint"];
									_unit setCaptive true;
									_unit setvariable ["ZSN_isUnconscious", true, true];
									_unit setUnconscious true;
									[_unit] join grpNull;
									while {(_unit getVariable "ZSN_Dammage" > 0.25) && (lifestate _unit == "INCAPACITATED")} do {
										sleep _time;
										_unit setSuppression 1;
										_hpa = getAllHitPointsDamage _unit select 2;
										_dmg = selectMax _hpa;
										_unit setvariable ["ZSN_Dammage", _dmg, true];
									};
									if (!alive _unit) exitWith {};
									_unit setUnconscious false;
									_unit setvariable ["ZSN_isUnconscious", false, true];
									if (!(_unit getVariable "ZSN_isSurrendering")) then {
										if(_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] < 1) then {
											[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
										} else {
											_unit setCaptive false;
											_unit setSuppression 0;
											[_unit] join _grp;
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
	_unit spawn {
		private ["_unit", "_healQueue","_time","_patient"];
		_unit = _this;
		_healQueue = [];
		_time = random 3;
		while {alive _unit} do {
			sleep _time;
			{if ((lifestate _x == "INCAPACITATED") && !(_x in _healQueue)) then {_healQueue pushback _x};} foreach nearestObjects [_unit, ["CAManBase"], 50];
			if (count _healQueue > 0) then {
				_healQueue = [_healQueue, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
				_patient = _healQueue select 0;
				_unit doMove getpos _patient;
				if (_unit distance _patient < 2) then {
					_unit additem "FirstAidKit";
					_unit action ["HealSoldier", _patient];
					_healQueue deleteAt 0;
				};
				[_unit, _healQueue] remoteexec ["zsn_fnc_hint"];
			};
		};
	};
};