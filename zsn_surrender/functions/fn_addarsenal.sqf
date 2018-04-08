params [
	["_box",""],
	["_fact",faction player],
	["_ea",[]]
];
["AmmoboxInit",[_box,false]] spawn BIS_fnc_arsenal;
_ua = [];
	{
	if ((configName _x) isKindoF "CAManBase") then {
		_ua pushback (configName _x);
	};
} forEach ("getText (_x >> 'faction') == _fact" configClasses (configfile >> "CfgVehicles"));
_ra = _ua arrayintersect _ea;
if ((count _ra) > 0) then {_ua = _ua - _ra} else {_ua append _ea};
{
	private _lo = getUnitLoadout (configFile >> "CfgVehicles" >> _x);
	[_box,[_lo select 0 select 0],true] call BIS_fnc_addVirtualWeaponCargo;
	[_box,[_lo select 1 select 0],true] call BIS_fnc_addVirtualWeaponCargo;
	[_box,[_lo select 2 select 0],true] call BIS_fnc_addVirtualWeaponCargo;
	[_box,[_lo select 3 select 0],true] call BIS_fnc_addVirtualItemCargo;
	if (str [_lo select 3] != "[[]]") then {
		if (str [_lo select 3 select 1] != "[[]]") then {
			{
				{
					if (typename (_x select 0) == "ARRAY") then {
						[_box,_x select 0 select 0,true] call BIS_fnc_addVirtualWeaponCargo
					} else {
						if ((_x select 0) isKindOf ["CA_Magazine", configFile >> "CfgMagazines"]) then {
							[_box,_x select 0,true] call BIS_fnc_addVirtualMagazineCargo
						} else {
							[_box,_x select 0,true] call BIS_fnc_addVirtualItemCargo
						};
					};
				} foreach _x
			} foreach [_lo select 3 select 1]
		};
	};
	[_box,[_lo select 4 select 0],true] call BIS_fnc_addVirtualItemCargo;
	if (str [_lo select 4] != "[[]]") then {
		if (str [_lo select 4 select 1] != "[[]]") then {
			{
				{
					if (typename (_x select 0) == "ARRAY") then {
						[_box,_x select 0 select 0,true] call BIS_fnc_addVirtualWeaponCargo
					} else {
						if ((_x select 0) isKindOf ["CA_Magazine", configFile >> "CfgMagazines"]) then {
							[_box,_x select 0,true] call BIS_fnc_addVirtualMagazineCargo
						} else {
							[_box,_x select 0,true] call BIS_fnc_addVirtualItemCargo
						};
					};
				} foreach _x
			} foreach [_lo select 4 select 1]
		};
	};
	[_box,[_lo select 5 select 0],true] call BIS_fnc_addVirtualbackpackCargo;
	if (str [_lo select 5] != "[[]]") then {
		if (str [_lo select 5 select 1] != "[[]]") then {
			{
				{
					if (typename (_x select 0) == "ARRAY") then {
						[_box,_x select 0 select 0,true] call BIS_fnc_addVirtualWeaponCargo
					} else {
						if ((_x select 0) isKindOf ["CA_Magazine", configFile >> "CfgMagazines"]) then {
							[_box,_x select 0,true] call BIS_fnc_addVirtualMagazineCargo
						} else {
							[_box,_x select 0,true] call BIS_fnc_addVirtualItemCargo
						};
					};
				} foreach _x
			} foreach [_lo select 5 select 1]
		};
	};
	[_box,[_lo select 6],true] call BIS_fnc_addVirtualItemCargo;
	[_box,[_lo select 7],true] call BIS_fnc_addVirtualItemCargo;
	[_box,[_lo select 8 select 0],true] call BIS_fnc_addVirtualItemCargo;
	{[_box,_x,true] call BIS_fnc_addVirtualItemCargo} foreach [_lo select 9];
} foreach _ua;
