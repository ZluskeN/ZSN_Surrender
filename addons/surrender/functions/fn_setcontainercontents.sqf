private _fnc_addContainer = {
	params [
		["_obj", objNull, [objNull]],
		["_type", "", [""]]
	];

	private _r = objNull;
	if(!isNull _obj) then {
		private _old = everyContainer _obj;
		
		if(_type isKindOf ["Bag_base", configFile >> "CfgVehicles"]) then {
			_obj addBackpackCargoGlobal [_type, 1];
		} else {
			_obj addItemCargoGlobal [_type, 1];
		};
		
		private _new = (everyContainer _obj) - _old;
		if(count _new == 1) then {
			_r = _new select 0;
		} else {
			["_fnc_addContainer: Failed to add container to object. _this = %1", _this] call BIS_fnc_error;
		};
	} else {
		["_fnc_addContainer: Invalid parameter. _args = %1", _args] call BIS_fnc_error;
	};
	_r
};

params [
	"_obj", 
	"_data"
];

_data params [
	"_items",
	"_magazines",
	"_weapons",
	"_containers"
];

//Parse item cargo
{ _obj addItemCargoGlobal [_x, 1]; } forEach _items;
//Parse magazine cargo
{ _obj addMagazineAmmoCargo [_x select 0, 1, _x select 1]; } forEach _magazines;
//Parse weapons cargo
{ _obj addWeaponWithAttachmentsCargoGlobal [_x, 1]; } forEach _weapons;

//{
//	private _elem = _x;
//	{
//		switch(typeName _x) do {
//			case "STRING": {
//				if(_x != "") then {
//					if(_x isKindOf ["ItemCore", configFile >> "CfgWeapons"]) then {
//						_obj addItemCargoGlobal [_x, 1];								_x;
//					} else {
//						private _baseWeapon = (_x call BIS_fnc_weaponComponents) select 0; 
//						_obj addWeaponCargoGlobal [_baseWeapon, 1];
//					};
//				};
//			};
//			case "ARRAY": {
//				if(count _x > 0) then {
//					_obj addMagazineAmmoCargo [_x select 0, 1, _x select 1];
//				};
//			};
//		};
//	} forEach _elem;
//} forEach _weapons;

//Parse container cargo
{
	_x params [
		"_type",
		"_contents"
	];
	
	private _xOBj = [_obj, _type] call _fnc_addContainer;
	_backpack = _xOBj select 1;
	clearItemCargo _backpack; 
	clearWeaponCargo _backpack; 
	clearMagazineCargo _backpack;
//	["setcontainerdata", [_xObj select 1, _contents]] call SELF;
} forEach _containers;
