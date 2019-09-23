private ["_unit", "_healQueue","_healQueueTemp","_time","_patient","_ms"];
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
					_ms = _patient getVariable "ZSN_Side";
					_patient reveal _unit;
					[_patient, _ms, _time] remoteExec ["zsn_fnc_surrenderCycle", _patient];
				};
			};
		};
	};
};