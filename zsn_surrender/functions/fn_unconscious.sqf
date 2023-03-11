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
	[_unit] joinsilent grpNull;
};
