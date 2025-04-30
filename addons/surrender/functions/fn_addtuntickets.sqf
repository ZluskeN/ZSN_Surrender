params ["_side","_newtickets", "_oldtickets"];

switch (toLower str _side) do {
	case "west": {
		_oldtickets = missionnamespace getvariable "tun_respawn_tickets_west";
		missionnamespace setvariable ["tun_respawn_tickets_west", (_oldtickets + _newtickets), true];
	};
	case "east": {
		_tickets = missionnamespace getvariable "tun_respawn_tickets_east";
		missionnamespace setvariable ["tun_respawn_tickets_east", (_tickets + _newtickets), true];
	};
	case "resistance": {
		_tickets = missionnamespace getvariable "tun_respawn_tickets_guer";
		missionnamespace setvariable ["tun_respawn_tickets_guer", (_tickets + _newtickets), true];
	};
	case "civilian": {
		_tickets = missionnamespace getvariable "tun_respawn_tickets_guer";
		missionnamespace setvariable ["tun_respawn_tickets_guer", (_tickets + _newtickets), true];
	};
};
[_side, "Redeemed a unit for tickets:", _newtickets] remoteexec ["zsn_fnc_hint"];