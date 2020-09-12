private ["_unit", "_healQueue","_healQueueTemp","_time","_patient","_ms","_es","_eny"];
_unit = _this;
_time = random 3;
if (!(hasInterface && isPlayer _unit)) then {
	_healQueue = [];
	while {alive _unit} do {
		sleep _time+3;
		_healQueueTemp = [];
		{if ((lifestate _x == "INCAPACITATED") && (_x != _unit)) then {_healQueueTemp pushback _x;};} foreach nearestObjects [_unit, ["CAManBase"], 50];
		if (count _healQueueTemp > 0) then {
			_healQueueTemp = [_healQueueTemp, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
			_patient = _healQueueTemp select 0;
			_unit doMove getpos _patient;
			if (!(_healQueueTemp  isEqualTo _healQueue)) then {
				_healQueue = _HealQueueTemp;
				[_unit, "is healing", _healQueue] remoteexec ["zsn_fnc_hint"];
			} else {
				if (_unit distance _patient < 5) then {
					_unit additem "FirstAidKit";
					_unit action ["HealSoldier", _patient];
					_healQueue deleteAt 0;
					_ms = side _unit;
					_es = _patient getVariable "ZSN_Side";
					_eny = [_es, _ms] call BIS_fnc_sideIsEnemy;
					if (_eny) then {
						[_unit, "is healing an enemy:", _patient] remoteexec ["zsn_fnc_hint"];
						waituntil {(lifestate _patient != "INCAPACITATED")};
						sleep _time+3;
						_patient reveal _unit;
						_patient allowFleeing 1;
						_patient setSuppression 1;
						isNil {[_patient, false, _es] call zsn_fnc_recover;};
						if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
							isNil {
								[_patient, false] call ace_captives_fnc_setSurrendered;
								[_patient, true] call ace_captives_fnc_setHandcuffed;
							};
						} else {
							_unit action ["Surrender", _patient];
						};
					};
				};
			};
		};
	};
};