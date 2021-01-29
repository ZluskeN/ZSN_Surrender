params ["_unit","_time", "_ms"];
_ms = (_unit getVariable "ZSN_Side");
if (!(hasInterface && isPlayer _unit)) then {
	waituntil {sleep _time; _unit call BIS_fnc_enemyDetected;};
	waituntil {sleep _time; ((count cc < 24) && (!(_unit in cc)));};
	cc pushback _unit;
	publicVariable "cc";
	[count cc, "alerted units:", cc] remoteexec ["zsn_fnc_hint"];
	while {alive _unit} do {
		_isSurrendering = _unit getVariable "ZSN_isSurrendering";
		if (fleeing _unit && !_isSurrendering) then {
			[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
		};
		sleep _time;
	};
	cc = cc - [_unit];
	publicvariable "cc";
	[count cc, "alerted units:", cc] remoteexec ["zsn_fnc_hint"];
};