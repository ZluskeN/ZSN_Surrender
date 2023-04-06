params ["_unit","_ms","_mg","_friendlies","_grp","_containers","_container","_boxContents","_weapon"];
if (!(hasinterface && isplayer _unit)) then {
	_unit setCaptive false;
	_unit setSuppression 0;
	if (_unit getvariable ["ZSN_isRedeemable",false] && isClass(configFile >> "CfgPatches" >> "Tun_Respawn")) then {
		_unit allowFleeing 1;
		_cp = [];
		switch (tolower str _ms) do {
			case "west": {
				if (!isNil {missionnamespace getvariable "tun_respawn_flag_west_spawn"}) then {_cp pushBack (missionnamespace getvariable "tun_respawn_flag_west_spawn")};
				if (!isNil {missionnamespace getvariable "tun_msp_vehicle_west"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_west")) then {_cp pushBack (missionnamespace getvariable "tun_msp_vehicle_west")};
			};
			case "east": {
				if (!isNil {missionnamespace getvariable "tun_respawn_flag_east_spawn"}) then {_cp pushBack (missionnamespace getvariable "tun_respawn_flag_east_spawn")};
				if (!isNil {missionnamespace getvariable "tun_msp_vehicle_east"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_east")) then {_cp pushBack (missionnamespace getvariable "tun_msp_vehicle_east")};
			};
			case "resistance": {
				if (!isNil {missionnamespace getvariable "tun_respawn_flag_guerrila_spawn"}) then {_cp pushBack (missionnamespace getvariable "tun_respawn_flag_guerrila_spawn")};
				if (!isNil {missionnamespace getvariable "tun_msp_vehicle_guer"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_guer")) then {_cp pushBack (missionnamespace getvariable "tun_msp_vehicle_guer")};
			};
			case "civilian": {
				if (!isNil {missionnamespace getvariable "tun_respawn_flag_civilian_spawn"}) then {_cp pushBack (missionnamespace getvariable "tun_respawn_flag_civilian_spawn")};
				if (!isNil {missionnamespace getvariable "tun_msp_vehicle_civ"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_civ")) then {_cp pushBack (missionnamespace getvariable "tun_msp_vehicle_civ")};
			};
		};
		_cpsorted = [_cp, [], {_unit distance _x}, "ASCEND"] call BIS_fnc_sortBy;
		_cpclosest = _cpsorted select 0;
		if (_cpclosest iskindof "FlagCarrier") then { 
			_unit move getpos _cpclosest; 
		} else { 
			_unit assignAsCargo _cpclosest;
			[_unit] orderGetIn true;
		};
	} else {
		if (primaryweapon _unit == "" && alive _unit) then {
			_containers = [];
			{if ((weaponcargo _x) select 0 isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {_containers pushback _x}} forEach nearestObjects [_unit, ["ReammoBox", "ThingX"], 50];
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
		{if (side _x == _ms) then {_friendlies pushback _x}} foreach nearestObjects [getpos _unit, ["AllVehicles"], 500];
		_friendlies = [_friendlies, [], {_unit distance _x}] call BIS_fnc_sortBy;
		if (count _friendlies > 1) then {
			_grp = group (_friendlies select 1);
			[_unit] joinsilent _grp;
		};
	};
};