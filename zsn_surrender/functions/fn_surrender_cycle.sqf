params ["_unit","_ms","_time","_wh","_grp"];
if (_unit getVariable "ZSN_isUnconscious") then {waituntil {sleep _time; !(_unit getVariable "ZSN_isUnconscious");};};
_unit setvariable ["ZSN_isSurrendering", true, true];
_unit setCaptive true;
[_unit, "Surrendered"] remoteexec ["zsn_fnc_hint"];
[_unit] joinsilent grpNull;
_wh = "GroundWeaponHolder_Scripted" createVehicle getpos _unit;
sleep _time;
_unit action ["DropWeapon", _wh, currentWeapon _unit];
if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
	[_unit, true] call ace_captives_fnc_setSurrendered;
	waituntil {sleep _time; _ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] > 1;};
	[_unit, false] call ace_captives_fnc_setSurrendered;
	sleep _time;
	private _containers = [];
	{if (count (weaponcargo _x) > 0) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
	if (count _containers > 0) then {
		private _closestcontainers = [_containers, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;
		_unit action ["TakeWeapon", (_closestcontainers select 0), ((weaponcargo (_closestcontainers select 0)) select 0)];
	};
	_unit setCaptive false;
	_unit setvariable ["ZSN_isSurrendering", false, true];
	private _friendlies = [];
	{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 50];
	_friendlies = [_friendlies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
	_grp = group (_friendlies select 0);
	[_unit] joinsilent _grp;
	["joined", _grp] remoteexec ["zsn_fnc_hint"];
} else {
	_unit action ["Surrender", _unit];
};