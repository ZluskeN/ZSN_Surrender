private _obj = _this;
private _r = [];
private _self = call compile _fnc_scriptName;

{
	_x params [
		"_xType",
		"_xObj"
	];
	
	private _items = [];
	{
		private _isVest = (_x isKindOf ["Vest_Camo_Base", configFile >> "CfgWeapons"]) || (_x isKindOf ["Vest_NoCamo_Base", configFile >> "CfgWeapons"]);
		private _isUniform = _x isKindOf ["Uniform_base", configFile >> "CfgWeapons"];
		if !(_isVest || _isUniform) then {
			_items pushBack _x;
		};
	} forEach itemCargo _xObj;
	_items sort true;
	
	private _mags = magazinesAmmoCargo _xObj;
	_mags sort true;
	
	private _weapons = weaponsItemsCargo _xObj;
	_weapons sort true;
	
	private _containers = _xObj call _self;
	_containers sort true;
	
	_r pushback [_xType, [_items, _mags, _weapons, _containers]];
} forEach everyContainer _obj;

_r