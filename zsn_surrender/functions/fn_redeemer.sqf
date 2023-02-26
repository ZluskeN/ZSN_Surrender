// To add your own unit or object as a ticket collector add (missionNamespace setVariable ["zsn_west_collector", this, true]) to the init field of your collector
// You can also add it in your mission with (missionNamespace setVariable ["zsn_west_collector", _mycollector, true]) where _mycollector is the designated unit or object
// Accepted values are "zsn_west_collector", "zsn_east_collector", "zsn_guer_collector" and "zsn_civ_collector" for the respective sides
// Dead or living units from any side can be collected by your side
// If you want the unit to be collectable from a distance (10 m), the collector needs to be of type "FlagCarrier", otherwise the unit will need to be in cargo to be collected

params ["_unit","_flags"];

_flags = [];

if (!isNil {missionnamespace getvariable "tun_respawn_flag_west_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_west_spawn", west]};
if (!isNil {missionnamespace getvariable "tun_respawn_flag_east_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_east_spawn", east]};
if (!isNil {missionnamespace getvariable "tun_respawn_flag_guerrila_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_guerrila_spawn", resistance]};
if (!isNil {missionnamespace getvariable "tun_respawn_flag_civilian_spawn"}) then {_flags pushBack [missionnamespace getvariable "tun_respawn_flag_civilian_spawn", civilian]};

if (!isNil {missionnamespace getvariable "zsn_west_collector"}) then {_flags pushBack [missionnamespace getvariable "zsn_west_collector", west]};
if (!isNil {missionnamespace getvariable "zsn_east_collector"}) then {_flags pushBack [missionnamespace getvariable "zsn_east_collector", east]};
if (!isNil {missionnamespace getvariable "zsn_guer_collector"}) then {_flags pushBack [missionnamespace getvariable "zsn_guer_collector", resistance]};
if (!isNil {missionnamespace getvariable "zsn_civ_collector"}) then {_flags pushBack [missionnamespace getvariable "zsn_civ_collector", civilian]};

if (count _flags > 0) then {
	[_unit, _flags] spawn {
		params ["_unit","_flags","_tickets"];
		waituntil {
			{
				sleep 1;
				_flag = _x select 0;
				if (!alive _unit) exitwith {true};
				[_flag, (_unit distance _flag), _unit] call zsn_fnc_hint;
				_bool = if (_flag iskindof "FlagCarrier") then {_unit distance _flag < 10} else {(_unit in crew _flag) OR (_unit in (_flag getVariable "ace_cargo_loaded"))};
				if (_bool) exitWith {
					switch (toLower str (_x select 1)) do {
						case "west": {
							if (!isnull (_unit getVariable "ace_common_owner")) then {
								_carrier = _unit getVariable "ace_common_owner";
								if (_carrier getVariable "ace_dragging_isDragging") then {[_carrier, _unit] call ace_dragging_fnc_dropObject};
								if (_carrier getVariable "ace_dragging_isCarrying") then {[_carrier, _unit] call ace_dragging_fnc_dropObject_carry};
							};
							_tickets = missionnamespace getvariable "tun_respawn_tickets_west";
							if (_unit iskindof "Man" && alive _unit) then {
								missionnamespace setvariable ["tun_respawn_tickets_west", (_tickets + ZSN_RedeemLiving), true];
								["Live unit redeemed for", ZSN_RedeemLiving, "tickets"] remoteexec ["zsn_fnc_hint"];
							} else {
								missionnamespace setvariable ["tun_respawn_tickets_west", (_tickets + ZSN_RedeemDead), true];
								["Dead unit redeemed for", ZSN_RedeemDead, "tickets"] remoteexec ["zsn_fnc_hint"];
							};
							deletevehicle _unit;
							true
						};
						case "east": {
							if (!isnull (_unit getVariable "ace_common_owner")) then {
								_carrier = _unit getVariable "ace_common_owner";
								if (_carrier getVariable "ace_dragging_isDragging") then {[_carrier, _unit] call ace_dragging_fnc_dropObject};
								if (_carrier getVariable "ace_dragging_isCarrying") then {[_carrier, _unit] call ace_dragging_fnc_dropObject_carry};
							};
							_tickets = missionnamespace getvariable "tun_respawn_tickets_east";
							if (_unit iskindof "Man" && alive _unit) then {
								missionnamespace setvariable ["tun_respawn_tickets_east", (_tickets + ZSN_RedeemLiving), true];
								["Live unit redeemed for", ZSN_RedeemLiving, "tickets"] remoteexec ["zsn_fnc_hint"];
							} else {
								missionnamespace setvariable ["tun_respawn_tickets_east", (_tickets + ZSN_RedeemDead), true];
								["Dead unit redeemed for", ZSN_RedeemDead, "tickets"] remoteexec ["zsn_fnc_hint"];
							};
							deletevehicle _unit;
							true
						};
						case "resistance": {
							if (!isnull (_unit getVariable "ace_common_owner")) then {
								_carrier = _unit getVariable "ace_common_owner";
								if (_carrier getVariable "ace_dragging_isDragging") then {[_carrier, _unit] call ace_dragging_fnc_dropObject};
								if (_carrier getVariable "ace_dragging_isCarrying") then {[_carrier, _unit] call ace_dragging_fnc_dropObject_carry};
							};
							_tickets = missionnamespace getvariable "tun_respawn_tickets_guer";
							if (_unit iskindof "Man" && alive _unit) then {
								missionnamespace setvariable ["tun_respawn_tickets_guer", (_tickets + ZSN_RedeemLiving), true];
								["Live unit redeemed for", ZSN_RedeemLiving, "tickets"] remoteexec ["zsn_fnc_hint"];
							} else {
								missionnamespace setvariable ["tun_respawn_tickets_guer", (_tickets + ZSN_RedeemDead), true];
								["Dead unit redeemed for", ZSN_RedeemDead, "tickets"] remoteexec ["zsn_fnc_hint"];
							};
							deletevehicle _unit;
							true
						};
						case "civilian": {
							if (!isnull (_unit getVariable "ace_common_owner")) then {
								_carrier = _unit getVariable "ace_common_owner";
								if (_carrier getVariable "ace_dragging_isDragging") then {[_carrier, _unit] call ace_dragging_fnc_dropObject};
								if (_carrier getVariable "ace_dragging_isCarrying") then {[_carrier, _unit] call ace_dragging_fnc_dropObject_carry};
							};
							_tickets = missionnamespace getvariable "tun_respawn_tickets_civ";
							if (_unit iskindof "Man" && alive _unit) then {
								missionnamespace setvariable ["tun_respawn_tickets_civ", (_tickets + ZSN_RedeemLiving), true];
								["Live unit redeemed for", ZSN_RedeemLiving, "tickets"] remoteexec ["zsn_fnc_hint"];
							} else {
								missionnamespace setvariable ["tun_respawn_tickets_civ", (_tickets + ZSN_RedeemDead), true];
								["Dead unit redeemed for", ZSN_RedeemDead, "tickets"] remoteexec ["zsn_fnc_hint"];
							};
							deletevehicle _unit;
							true
						};
					};
				};
				false
			} foreach _flags;
		};
	};
};