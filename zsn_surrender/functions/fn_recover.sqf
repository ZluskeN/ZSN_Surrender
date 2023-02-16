params ["_unit","_ms","_mg","_friendlies","_grp","_containers","_container","_boxContents","_weapon"];
if (!(hasinterface && isplayer _unit)) then {
	_unit setCaptive false;
	if (primaryweapon _unit == "" && alive _unit) then {
		_containers = [];
		{if ((weaponcargo _x) select 0 isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
		if (count _containers > 0) then {
			_containers = [_containers, [], {_unit distance _x}] call BIS_fnc_sortBy;
			_container = _containers select 0;
			_boxContents = weaponCargo _container;
			_weapon = _boxContents select 0;
			_unit action ["TakeWeapon", _container, _weapon];
			[_unit, "Picked up a weapon", _weapon] remoteexec ["zsn_fnc_hint"];
		};
	};
	_friendlies = [];
	{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 500];
	_friendlies = [_friendlies, [], {_unit distance _x}] call BIS_fnc_sortBy;
	if (count _friendlies > 1) then {
		_grp = group (_friendlies select 1);
		[_unit] joinsilent _grp;
	};
};