params ["_unit","_bool","_time","_ms","_weapons","_wpi","_weapon","_wh","_offset","_vel","_dir","_speed","_containers","_container","_friendlies","_grp"];
if (!_bool) then {
//	[_unit] joinsilent grpNull;
	if (count weaponsItems _unit > 0) then {
		_weapons = weaponsItems _unit;
		_wpi = _weapons findIf {_x select 0 == currentweapon _unit};
		if (_wpi >= 0) then {
			_weapon = _weapons select _wpi;
			_wh = "WeaponHolderSimulated" createVehicle [0,0,0];
			_wh addWeaponWithAttachmentsCargoGlobal [_weapon, 1];
			_offset = _unit selectionPosition "hands";
			_wh setPos (_unit modelToWorld _offset);
			_wh disableCollisionWith _unit;
			_vel = velocity _unit;
			_dir = direction _unit;
			_speed = 2;
			_wh setVelocity [(_vel select 0)+(sin _dir*_speed),(_vel select 1)+(cos _dir*_speed),(_vel select 2)+_speed];
			_unit removeWeapon (_weapon select 0);
			sleep _time;
			if (getpos _wh select 2 < 0) then {_wh setPos [(getPos _wh select 0),(getPos _wh select 1),0.05];};
		};
	};
} else {
//	_friendlies = [];
//	{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 100];
//	_friendlies = [_friendlies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
//	_grp = group (_friendlies select 0);
//	[_unit] joinsilent _grp;
//	["joined", _grp] remoteexec ["zsn_fnc_hint"];
	while {primaryWeapon _unit == ""} do {
		_containers = [];
		{if (count (weaponcargo _x) > 0) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
		if (count _containers > 0) then {
			_containers = [_containers, [], { _unit distance _x }, "ASCEND"] call BIS_fnc_sortBy;
			_container = _containers select 0;
			_unit doMove getpos _container;
			if (_unit distance _container < 5) then {
				_unit action ["TakeWeapon", _container, ((weaponcargo _container) select 0)];
			};
		};
		sleep _time;
	};
};
