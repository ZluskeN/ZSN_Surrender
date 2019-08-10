params ["_unit","_bool","_time","_wh","_containers","_container","_friendlies","_grp"];
if (!_bool) then {
	[_unit] joinsilent grpNull;
	_weapon = weaponsItems _unit select 0;
	_unit removeWeapon (currentWeapon _unit);
	_wh = "WeaponHolderSimulated" createVehicle [0,0,0];
	_wh addWeaponWithAttachmentsCargoGlobal [_weapon, 1];
	_wh setPos (_unit modelToWorld [0,.2,1.2]);
	_wh disableCollisionWith _unit;
	_wh setVelocity velocity _unit;
	sleep _time;
	_wh setPos [(getPos _wh select 0),(getPos _wh select 1),0.05];
} else {
	_containers = [];
	{if (count (weaponcargo _x) > 0) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
	if (count _containers > 0) then {
		_containers = [_containers, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;
		_container = _containers select 0;
		_unit doMove getpos _container;
		waituntil {sleep _time; (_unit distance _container < 5);};
		_unit action ["TakeWeapon", _container, ((weaponcargo _container) select 0)];
	};
	_friendlies = [];
	{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 50];
	_friendlies = [_friendlies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
	_grp = group (_friendlies select 0);
	[_unit] joinsilent _grp;
	["joined", _grp] remoteexec ["zsn_fnc_hint"];
};
