params ["_unit","_time", "_ms"];
_ms = (_unit getVariable "ZSN_Side");
if (!(hasInterface && isPlayer _unit)) then {
	waituntil {sleep _time; _unit call BIS_fnc_enemyDetected;};
	waituntil {sleep _time; ((count zsn_cc < ZSN_Maxinstances) && (!(_unit in zsn_cc)));};
	zsn_cc pushback _unit;
	publicVariable "zsn_cc";
	[count zsn_cc, "alerted units:", zsn_cc] remoteexec ["zsn_fnc_hint"];
	while {alive _unit} do {
		_isSurrendering = _unit getVariable "ZSN_isSurrendering";
		if (fleeing _unit && !_isSurrendering) then {
			[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
		};
		sleep _time;
	};
	zsn_cc = zsn_cc - [_unit];
	publicvariable "zsn_cc";
	[count zsn_cc, "alerted units:", zsn_cc] remoteexec ["zsn_fnc_hint"];
};