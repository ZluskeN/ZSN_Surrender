params ["_unit","_delay","_mytime"];

if (isplayer _unit && hasInterface) then {
	if (ZSN_UnconsciousAction) then {
		_delay = ZSN_UnconsciousTimer;
		_mytime = time + _delay;
		[{time >= (_this select 1)}, {
			params ["_unit"];
			switch (lifestate _unit) do {
				case "INCAPACITATED": {
					if (_unit getVariable "ace_isunconscious") then {
						titleText ["", "BLACK OUT"];
						[_unit, "Respawn", {
							params ["_newObject","_oldObject"];
							deleteVehicle _oldObject;
							titleText ["", "BLACK IN"];
							_newObject removeEventHandler ["Respawn", _thisID];
						}] call CBA_fnc_addBISEventHandler;
						[_unit, lifestate _unit] remoteexeccall ["zsn_fnc_replaceplayer", 2];
					};	
				};
				case "HEALTHY": {
					if (_unit getVariable "ace_captives_isHandcuffed") then {
						titleText ["", "BLACK OUT"];
						[_unit, "Respawn", {
							params ["_newObject","_oldObject"];
							deleteVehicle _oldObject;
							titleText ["", "BLACK IN"];
							_newObject removeEventHandler ["Respawn", _thisID];
						}] call CBA_fnc_addBISEventHandler;
						[_unit, lifestate _unit] remoteexeccall ["zsn_fnc_replaceplayer", 2];
					};
				};
			};
		}, [_unit, _mytime]] call CBA_fnc_waitUntilAndExecute;
	};
} else {
	_grp = group _unit;
	_unit setVariable ["zsn_group", _grp];
	[_unit] joinsilent grpNull;
	if (_unit getVariable "ace_captives_isHandcuffed" && ZSN_CreateBox_AI) then {
		_box = createVehicle ["Box_Syndicate_WpsLaunch_F", [random 10, random 10, 0], [], 0, "NONE"];
		clearWeaponCargoGlobal _box;
		clearMagazineCargoGlobal _box;
		clearItemCargoGlobal _box;
		clearBackpackCargoGlobal _box;
		{_box addWeaponWithAttachmentsCargoGlobal [_x, 1]; _unit removeWeaponGlobal (_x select 0)} forEach (weaponsItems _unit);
		{_box addMagazineAmmoCargo [_x select 0, 1, _x select 1]; [_unit, _x select 0, _x select 1] call CBA_fnc_removeMagazine} forEach (magazinesAmmo _unit);
		{_box addItemCargoGlobal [_x, 1]; _unit removeitem _x} forEach (Items _unit);
		if (ZSN_IncludeLinked) then {{_box addItemCargoGlobal [_x, 1]; _unit unlinkItem _x} forEach (assignedItems _unit)};
		if (Backpack _unit != "") then {_box addBackpackCargoGlobal [(Backpack _unit), 1]};
		removeBackpackGlobal _unit;
		_backpack = firstBackpack _box;
		clearItemCargoGlobal _backpack;
		clearWeaponCargoGlobal _backpack;
		clearMagazineCargoGlobal _backpack;
		_box call zsn_fnc_transferloop;
		_vehicle = vehicle _unit;
		if (_vehicle == _unit) then {
			_box setDir (getDir _unit + 90);
			_box setVehiclePosition [_unit, [], 0, "NONE"];
		} else {
			[_box, _vehicle, true] call ace_cargo_fnc_loadItem;
		};
	};
};
