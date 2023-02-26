params ["_unit","_pos","_dir","_box","_backpack","_stretcher"]; 

if (groupOwner group _unit != 2) then {group _unit setGroupOwner 2};
_unit setvariable ["ZSN_isRedeemable", true, true];
if (isClass(configFile >> "CfgPatches" >> "Tun_Respawn")) then {
	_unit call zsn_fnc_redeemer;
};
if (ZSN_CreateBox) then {
	_box = createVehicle ["Box_Syndicate_WpsLaunch_F", [random 10, random 10, 0], [], 0, "NONE"];
	clearWeaponCargo _box;
	clearMagazineCargo _box;
	clearItemCargo _box;
	clearBackpackCargo _box;
	{_box addWeaponWithAttachmentsCargoGlobal [_x, 1]; _unit removeWeaponGlobal (_x select 0)} forEach (weaponsItems _unit);
	{_box addMagazineAmmoCargo [_x select 0, 1, _x select 1]; [_unit, _x select 0, _x select 1] call CBA_fnc_removeMagazine;} forEach (magazinesAmmo _unit);
	{_box addItemCargoGlobal [_x, 1]; _unit removeitem _x} forEach (Items _unit);
	{_box addItemCargoGlobal [_x, 1]; _unit unlinkItem _x;} forEach (assignedItems _unit);
	if (Backpack _unit != "") then {_box addBackpackCargo [(Backpack _unit), 1]};
	removebackpack _unit;
	_backpack = firstBackpack _box;
	clearItemCargo _backpack;
	clearWeaponCargo _backpack;
	clearMagazineCargo _backpack;
	_box spawn zsn_fnc_transferloop;
	if (isNull objectParent _unit) then {
		_box setDir (_dir + 90);
		_box setVehiclePosition [_pos, [], 0, "NONE"];
	} else {
		_vehicle = vehicle _unit;
		[_box, _vehicle, true] call ace_cargo_fnc_loadItem;
	};
};
if (ZSN_BodyBags) then {
	_unit addEventHandler ["Killed", {
		params ["_unit", "_killer", "_instigator", "_useEffects"];
		[_unit, _unit] call ace_medical_treatment_fnc_placeInBodyBag;
	}];
};
//if (lifestate _unit == "INCAPACITATED" && ZSN_SpawnStretcher) then {
//	waitUntil {sleep 1; lifestate _unit != "INCAPACITATED"};
//	if (((lifestate _unit != "DEAD") && (isNull objectParent _unit)) && (isClass(configFile >> "CfgPatches" >> "vurtual_seat"))) then {
//		_pos = getPos _unit;
//		_dir = getDir _unit;
//		_stretcher = "vurtual_stretcher" createVehicle [random 10,random 10,0];
//		_unit assignAsCargo _stretcher; 
//		_unit moveincargo _stretcher; 
//		_unit setcaptive true;
//		_stretcher lock true; 
//		_stretcher setDir _dir;
//		_stretcher setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
//		[_stretcher, 2] call ace_cargo_fnc_setSize;
//	};
//};
