
params ["_unit","_flags"];
waituntil {
	_flags = [];
	if (!isNil {missionnamespace getvariable "tun_respawn_flag_west_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_west_spawn", west]};
	if (!isNil {missionnamespace getvariable "tun_respawn_flag_east_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_east_spawn", east]};
	if (!isNil {missionnamespace getvariable "tun_respawn_flag_guerrila_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_guerrila_spawn", resistance]};
	if (!isNil {missionnamespace getvariable "tun_respawn_flag_civilian_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_civilian_spawn", civilian]};
	if (!isNil {missionnamespace getvariable "tun_msp_vehicle_west"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_west")) then {_flags pushBack [missionnamespace getvariable "tun_msp_vehicle_west", west]};
	if (!isNil {missionnamespace getvariable "tun_msp_vehicle_east"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_east")) then {_flags pushBack [missionnamespace getvariable "tun_msp_vehicle_west", east]};
	if (!isNil {missionnamespace getvariable "tun_msp_vehicle_guer"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_guer")) then {_flags pushBack [missionnamespace getvariable "tun_msp_vehicle_guer", resistance]};
	if (!isNil {missionnamespace getvariable "tun_msp_vehicle_civ"} && !isnull (missionnamespace getvariable "tun_msp_vehicle_civ")) then {_flags pushBack [missionnamespace getvariable "tun_msp_vehicle_civ", civilian]};
	if (count _flags > 0) then {
		{
			sleep 1;
			_flag = _x select 0;
			if (!alive _unit) exitwith {true};
			[_flag, (_unit distance _flag), _unit] call zsn_fnc_hint;
			_bool = (_unit distance _flag < 10);
			if (_bool) exitWith {
				if (!isnull (_unit getVariable "ace_common_owner")) then {
					_carrier = _unit getVariable "ace_common_owner";
					if (_carrier getVariable "ace_dragging_isDragging") then {[_carrier, _unit] call ace_dragging_fnc_dropObject};
					if (_carrier getVariable "ace_dragging_isCarrying") then {[_carrier, _unit] call ace_dragging_fnc_dropObject_carry};
				};
				if (_unit iskindof "Man" && alive _unit) then {
					[_x select 1, ZSN_RedeemLiving] Call zsn_fnc_addtuntickets;
				} else {
					[_x select 1, ZSN_RedeemDead] Call zsn_fnc_addtuntickets;
				};
				deletevehicle _unit;
				true
			};
			false
		} foreach _flags;
	} else {true};
};