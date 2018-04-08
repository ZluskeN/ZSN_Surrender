params ["_zsn_unit", "_zsn_class"];

private _zsn_vehicleConfig = configfile >> "CfgVehicles" >> _zsn_class;
private _zsn_missionConfig = missionConfigfile >> "CfgRespawnInventory" >> _zsn_class;

if (isClass (_zsn_vehicleConfig)) then {[_zsn_unit, _zsn_vehicleConfig] call BIS_fnc_loadInventory;};
if (isClass (_zsn_missionConfig)) then {[_zsn_unit, _zsn_missionConfig] call BIS_fnc_loadInventory;};