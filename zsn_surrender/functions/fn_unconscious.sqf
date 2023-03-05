params ["_unit","_delay","_mytime"];

if (isplayer _unit && hasInterface) then {
	if (ZSN_UnconsciousAction) then {
		_delay = ZSN_UnconsciousTimer;
		_mytime = time + _delay;
		[{time >= (_this select 1)}, {
			params ["_unit","_mytime"];
			switch (lifestate _unit) do {
				case "INCAPACITATED": {
					if (_unit getVariable "ace_isunconscious") then {
						_oldplayer = _unit;
						titleText ["", "BLACK OUT"];
						_oldplayer allowDamage false;
						_pos = getPos _oldplayer;
						_dir = getDir _oldplayer;
						_loadOut = getUnitLoadout [_oldplayer, true];
						_unconAnim = animationState _oldplayer;
						_medstate = [_oldplayer] call ace_medical_fnc_serializeState;
						_side = side group _oldplayer;
						
						_newgrp = creategroup (_side);
						(typeof _oldplayer) createUnit [[random 10, random 10, 0], _newgrp, "ZSN_newplayer = this"];
						ZSN_newplayer setUnitLoadout [_loadOut, true];
						ZSN_newplayer setvariable ["ZSN_Side", _side, true];
						ZSN_newplayer setFace face _oldplayer;
						ZSN_newplayer setName name _oldplayer;
						ZSN_newplayer setUnitRank rank _oldplayer;
						removeGoggles ZSN_newplayer; ZSN_newplayer addGoggles goggles _oldplayer;
						ZSN_newplayer setUnconscious true;
						[ZSN_newplayer, _medstate] call ace_medical_fnc_deserializeState;
						if (vehicle _oldplayer == _oldplayer) then {
							[ZSN_newplayer, _unconAnim, 2] call ace_common_fnc_doAnimation;
							_oldplayer setPos [random 10, random 10, 0];
							ZSN_newplayer setDir _dir;
							ZSN_newplayer setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
						} else {
							_vehicle = vehicle _oldplayer;
							_crew = fullCrew _vehicle;
							{
								if (_oldplayer in _x) exitWith {
									_oldplayer moveOut _vehicle;
									_oldplayer setPos [random 10, random 10, 0];
									[_vehicle, ZSN_newplayer, [_x select 1, _x select 3]] call BIS_fnc_moveIn;
								};
							} foreach _crew;
						};
						[_oldplayer, "Respawn", {
							params ["_newObject","_oldObject"];
							deleteVehicle _oldObject;
							titleText ["", "BLACK IN"];
							_newObject removeEventHandler ["Respawn", _thisID];
						}] call CBA_fnc_addBISEventHandler;
						_oldplayer setcaptive false;
						_oldplayer allowDamage true;
						_oldplayer setDammage 1;
						[ZSN_newplayer, _pos, _dir] remoteexecCall ["zsn_fnc_spawnstretcher", 2];
					};	
				};
				case "HEALTHY": {
					if (_unit getVariable "ace_captives_isHandcuffed") then {
						_oldplayer = _unit;
						titleText ["", "BLACK OUT"];
						_oldplayer allowDamage false;
						_pos = getPos _oldplayer;
						_dir = getDir _oldplayer;
						_loadOut = getUnitLoadout [_oldplayer, true];
						_unconAnim = animationState _oldplayer;
						_medstate = [_oldplayer] call ace_medical_fnc_serializeState;
						_side = side group _oldplayer;
						
						_newgrp = creategroup (_side);
						(typeof _oldplayer) createUnit [[random 10, random 10, 0], _newgrp, "ZSN_newplayer = this"];
						ZSN_newplayer setUnitLoadout [_loadOut, true];
						ZSN_newplayer setvariable ["ZSN_Side", _side, true];
						ZSN_newplayer setFace face _oldplayer;
						ZSN_newplayer setName name _oldplayer;
						ZSN_newplayer setUnitRank rank _oldplayer;
						removeGoggles ZSN_newplayer; ZSN_newplayer addGoggles goggles _oldplayer;
						[ZSN_newplayer, true, ZSN_newplayer] call ACE_captives_fnc_setHandcuffed;
						[ZSN_newplayer, _medstate] call ace_medical_fnc_deserializeState;
						if (vehicle _oldplayer == _oldplayer) then {
							[ZSN_newplayer, _unconAnim, 2] call ace_common_fnc_doAnimation;
							_oldplayer setPos [random 10, random 10, 0];
							ZSN_newplayer setDir _dir;
							ZSN_newplayer setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
						} else {
							_vehicle = vehicle _oldplayer;
							_crew = fullCrew _vehicle;
							{
								if (_oldplayer in _x) exitWith {
									_oldplayer moveOut _vehicle;
									_oldplayer setPos [random 10, random 10, 0];
									[_vehicle, ZSN_newplayer, [_x select 1, _x select 3]] call BIS_fnc_moveIn;
								};
							} foreach _crew;
						};
						if (isClass(configFile >> "CfgPatches" >> "Tun_Respawn")) then {
							[_side, 1] remoteexecCall ["zsn_fnc_addtuntickets", 2];
						};
						[_oldplayer, "Respawn", {
							params ["_newObject","_oldObject"];
							deleteVehicle _oldObject;
							titleText ["", "BLACK IN"];
							_newObject removeEventHandler ["Respawn", _thisID];
						}] call CBA_fnc_addBISEventHandler;
						_oldplayer setcaptive false;
						_oldplayer allowDamage true;
						_oldplayer setDammage 1;
						[ZSN_newplayer, _pos, _dir] remoteexecCall ["zsn_fnc_spawnstretcher", 2];
					};
				};
			};
		}, [_unit, _mytime]] call CBA_fnc_waitUntilAndExecute;
	};
} else {
	[_unit] joinsilent grpNull;
};

