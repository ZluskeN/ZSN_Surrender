params ["_unit","_bool","_ms","_time","_mg","_friendlies","_grp"];
switch (_bool) do
{
	case false: {
		_unit setCaptive true;
		_unit setvariable ["ZSN_Group", group _unit, true];
		if (isClass(configFile >> "CfgPatches" >> "ace_hitreactions")) then {
			if (count weaponsItems _unit > 0) then {_unit call ace_hitreactions_fnc_throwWeapon};
		} else {
			if (count weaponsItems _unit > 0) then {_unit call zsn_fnc_dropweapon};
		};
		if (!(hasinterface && isplayer _unit)) then {[_unit] joinsilent grpNull;};
	};
	case true: {
		_unit setCaptive false;
		_mg = (_unit getVariable "ZSN_Group");
		_unit spawn {
			params ["_unit","_time","_containers","_container","_boxContents","_weapon"];
			_time = random 3;
			while {primaryweapon _unit == "" && alive _unit} do {
				_containers = [];
				{if ((weaponcargo _x) select 0 isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {_containers pushback _x};} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
				if (count _containers > 0) then {
					_containers = [_containers, [], {_unit distance _x}] call BIS_fnc_sortBy;
					_container = _containers select 0;
					_boxContents = weaponCargo _container;
					_weapon = _boxContents select 0;
					//_unit addweapon _weapon;
					//_container removeweaponcargo _weapon;
					_unit action ["TakeWeapon", _container, _weapon];
					[_unit, "Picked up a weapon", _weapon] remoteexec ["zsn_fnc_hint"];
				};
				sleep _time;
			};
		};
		[_unit] joinsilent _mg;
		if (count units _unit < 2) then {
			_friendlies = [];
			{if (side _x == _ms) then {_friendlies pushback _x;};} foreach nearestObjects [getpos _unit, ["AllVehicles"], 50];
			_friendlies = [_friendlies, [], {_unit distance _x}] call BIS_fnc_sortBy;
			if (count _friendlies > 1) then {
				_grp = group (_friendlies select 1);
				[_unit] joinsilent _grp;
			};
		};
	};
};