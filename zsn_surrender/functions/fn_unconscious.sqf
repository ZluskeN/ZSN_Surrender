params ["_unit","_delay","_mytime"];

if (hasInterface) then {
	_delay = ZSN_UnconsciousTimer;
	_mytime = time + _delay;
	if (_delay > 0) then {
		waituntil {sleep 1; lifestate _unit != "INCAPACITATED" OR time >= _mytime};
		if (lifestate _unit == "INCAPACITATED") then {
			switch (ZSN_UnconsciousAction) do
			{
				case "Nothing": {};
				case "Spectator": {
					titleText ["", "BLACK OUT"];
					["Initialize",[_unit, [playerside], false, false, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;
					titleText ["", "BLACK IN"];
					waituntil {sleep 1; lifestate _unit != "INCAPACITATED"};
					titleText ["", "BLACK OUT"];
					["Terminate"] call BIS_fnc_EGSpectator;
					titleText ["", "BLACK IN"];
				};
				case "Respawn": {
					_oldplayer = _unit;
					_pos = getPos _oldplayer;
					_dir = getDir _oldplayer;
					ZSN_Loadout = getUnitLoadout [_oldplayer, true];
					_unconAnim = animationState _oldplayer;
					_medstate = [_oldplayer] call ace_medical_fnc_serializeState;
					_oldgrp = group _oldplayer;
					
					_newgrp = creategroup (side _oldgrp);
					(typeof _oldplayer) createUnit [[random 10, random 10, 0], _newgrp, "ZSN_newplayer = this; this setUnitLoadout [ZSN_Loadout, true]"];
					ZSN_newplayer setvariable ["ZSN_Group", _oldgrp, true];
					ZSN_newplayer setFace face _oldplayer;
					ZSN_newplayer setName name _oldplayer;
					ZSN_newplayer setUnitRank rank _oldplayer;
					removeGoggles ZSN_newplayer; ZSN_newplayer addGoggles goggles _oldplayer;
					
					ZSN_newplayer setUnconscious true;
					[ZSN_newplayer, _medstate] call ace_medical_fnc_deserializeState;
					[ZSN_newplayer, _unconAnim, 2] call ace_common_fnc_doAnimation;
					_oldplayer setPos [random 10, random 10, 0];
					[_unit, "Respawn", {
						params ["_newObject","_oldObject"];
						deleteVehicle _oldObject;
						_newObject removeEventHandler ["Respawn", _thisID];
					}] call CBA_fnc_addBISEventHandler;
					_oldplayer allowDamage true;
					_oldplayer setDammage 1;
					ZSN_newplayer setDir _dir;
					ZSN_newplayer setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
					[ZSN_newplayer, _pos, _dir] remoteexec ["zsn_fnc_spawnstretcher", 2];
				};
			};	
		};
	};
};