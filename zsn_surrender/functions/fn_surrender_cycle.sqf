params ["_unit","_ms","_time"];
if (_unit getVariable "ZSN_isUnconscious") then {waituntil {sleep _time; !(_unit getVariable "ZSN_isUnconscious");};};
_unit setvariable ["ZSN_isSurrendering", true, true];
[_unit, false, _time] spawn zsn_fnc_recover;
_unit setCaptive true;
[_unit, "Surrendered"] remoteexec ["zsn_fnc_hint"];
if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
	[_unit, true] call ace_captives_fnc_setSurrendered;
	waituntil {_ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] > 1; sleep _time;};
	[_unit, false] call ace_captives_fnc_setSurrendered;
	sleep _time;
	_unit setCaptive false;
	[_unit, true, _time] spawn zsn_fnc_recover;
	_unit setvariable ["ZSN_isSurrendering", false, true];
} else {
	_unit action ["Surrender", _unit];
};