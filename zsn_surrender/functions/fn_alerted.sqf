private ["_unit", "_ms","_time","_nearestenemy"];
_unit = _this;
_ms = (_unit getVariable "ZSN_Side");
_time = random 3;
if (!(hasInterface && isPlayer _unit)) then {
	waituntil {sleep _time; _unit call BIS_fnc_enemyDetected;};
	waituntil {sleep _time; ((count cc < 32) && (!(_unit in cc)));};
	cc pushback _unit;
	publicVariable "cc";
	[count cc, cc] remoteexec ["zsn_fnc_hint"];
	while {alive _unit} do {
		if (fleeing _unit) then {
			[_unit, _ms, _time] call ZSN_fnc_surrenderCycle;
		};
		sleep _time;
	};
	cc = cc - [_unit];
	publicvariable "cc";
	[count cc, cc] remoteexec ["zsn_fnc_hint"];
};