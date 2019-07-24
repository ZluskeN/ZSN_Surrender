params ["_unit","_ms","_time","_wh"];
if (_unit getVariable "ZSN_isUnconscious") then {waituntil {sleep _time; !(_unit getVariable "ZSN_isUnconscious");};};
_unit setvariable ["ZSN_isSurrendering", true, true];
[_unit, "Surrendered"] remoteexec ["zsn_fnc_hint"];
_wh = "GroundWeaponHolder_Scripted" createVehicle getpos _unit;
_unit action ["DropWeapon", _wh, currentWeapon _unit];
sleep _time;
[_unit, true] call ace_captives_fnc_setSurrendered;
waituntil {sleep _time; _ms countSide nearestObjects [getpos _unit, ["AllVehicles"], (getpos (_unit findNearestEnemy getpos _unit)) distance (getpos _unit)] > 1;};
[_unit, false] call ace_captives_fnc_setSurrendered;
sleep _time;
private _containers = [];
{if (count (weaponcargo _x) > 0) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
if (count _containers > 0) then {
	_closestcontainers = [_containers, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;
	_unit action ["TakeWeapon", (_closestcontainers select 0), ((weaponcargo (_closestcontainers select 0)) select 0)];
};
_unit setvariable ["ZSN_isSurrendering", false, true];