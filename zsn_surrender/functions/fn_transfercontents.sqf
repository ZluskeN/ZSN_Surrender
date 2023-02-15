//fn_transferContents.sqf
/*
	Params: 
	Required
	0 - From 		- Object			- Source object
	1 - To 			- Object			- Target object
	Optional
	2 - Types 		- String or Array of strings	- Allowed strings: "items", "magazines", "weapons", "containers". If empty all contents will be transfered.
	3 - Clear From 	- Bool 				- Should From be emptied after transfer? Default: True
	4 - Clear To 	- Bool				- Should To be emptied before transfer? Default: True
*/

params [
	["_from", objNull, [objNull]],
	["_to", objNull, [objNull]],
	["_types", [], [[], ""]],
	["_clearFrom", true, [true]],
	["_clearTo", true, [true]]
];

if(_types isEqualType "") then { _types = [_types]; };

private _transferItems 		= "items" 		in _types;
private _transferMags 		= "magazines" 	in _types;
private _transferWeapons 	= "weapons" 	in _types;
private _transferContainers	= "containers" 	in _types;

if(count _types == 0) then {
	_transferItems 		= true;
	_transferMags 		= true;
	_transferWeapons 	= true;
	_transferContainers	= true;
};

if(isNull _from || isNull _to) then {
	["A null parameter was provided. _this = %1", _this] call BIS_fnc_error;
} else {
	private _items = [];
	private _mags = [];
	private _weapons = [];
	private _containers = [];
	
	if(_transferItems) then {
		{
			private _isVest = (_x isKindOf ["Vest_Camo_Base", configFile >> "CfgWeapons"]) || (_x isKindOf ["Vest_NoCamo_Base", configFile >> "CfgWeapons"]);
			private _isUniform = _x isKindOf ["Uniform_base", configFile >> "CfgWeapons"];
			if !(_isVest || _isUniform) then {
				_items pushBack _x;
			};
		} forEach itemCargo _from;
	};
	if(_transferMags) then {
		_mags = magazinesAmmoCargo _from;
	};
	
	if(_transferWeapons) then {
		_weapons = weaponsItemsCargo _from;
	};
	
	if(_transferContainers) then {
		_containers = _from call zsn_fnc_getContainerContents;
	};
	
	if(_clearFrom) then {
		clearItemCargoGlobal _from;
		clearMagazineCargoGlobal _from;
		clearWeaponCargoGlobal _from;
		clearBackpackCargoGlobal _from;
	};
	
	if(_clearTo) then {
		clearItemCargoGlobal _to;
		clearMagazineCargoGlobal _to;
		clearWeaponCargoGlobal _to;
		clearBackpackCargoGlobal _to;
	};
	
	[_to, [_items, _mags, _weapons, _containers]] call zsn_fnc_setContainerContents;	
};