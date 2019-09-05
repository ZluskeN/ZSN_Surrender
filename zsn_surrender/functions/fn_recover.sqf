params ["_unit","_bool","_time","_ms","_mg","_containers","_container","_friendlies","_grp"];
switch (_bool) do
{
	case false: {
		_unit setvariable ["ZSN_Group", group _unit, true];
		if (count weaponsItems _unit > 0) then {_unit spawn zsn_fnc_dropweapon};
		[_unit] joinsilent grpNull;
	};
	case true: {
		_mg = (_unit getVariable "ZSN_Group");
		while {primaryWeapon _unit == ""} do {
			_containers = [];
			{if ((weaponcargo _x) select 0 isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 100];
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
		[_unit] joinsilent _mg;
		if (count units _unit < 2) then {
			_friendlies = [];
			{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 100];
			_friendlies = [_friendlies, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
			_grp = group (_friendlies select 1);
			[_unit] joinsilent _grp;
		};
	};
};
