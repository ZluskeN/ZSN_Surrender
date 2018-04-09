params [
	["_zsn_side", west, [east]],			//Side to execute wave respawn for 		(SIDE, Default west)
	["_zsn_ws", 8, [9]],				//Size of respawn waves				(NUMBER, Default 8)
	["_zsn_wc", -1, [8]],				//Number of respawn waves 			(NUMBER, Default -1 = infinite)
	["_zsn_lo", false, [true]],			//new wave receives custom gear			(BOOLEAN, Default false)
	["_zsn_pvp", false, [true]],			//pvp or coop					(BOOLEAN, Default false = coop)
	["_zsn_rs", _this select 0, [east]]		//Side to execute wave respawn for 		(SIDE, Default same as _zsn_side)
];
zsn_pvp = _zsn_pvp;
publicVariable "zsn_pvp";
rd = (getMissionConfigValue ["respawnDelay",2]) + 1;
switch (_zsn_side) do {
	case east: {
		if (isNil ("respawn_east")) then {respawn_east = createMarker ["respawn_east", [100,0]];};
		zsn_ofe = 0;
		publicVariable "zsn_ofe";
		zsn_loe = _zsn_lo;
		publicVariable "zsn_loe";
		zsn_wce = _zsn_wc;
		publicVariable "zsn_wce";
		zsn_wse = _zsn_ws;
		publicVariable "zsn_wse";
		zsn_rse = _zsn_rs;
		publicVariable "zsn_rse";
		if (!isNil ("zsn_est")) then {deleteVehicle zsn_est;};
		zsn_est = createTrigger ["EmptyDetector", getmarkerPos "respawn_east"];
		zsn_est setTriggerActivation ["civ", "PRESENT", true];
		if (zsn_rse == west) then {zsn_est setTriggerStatements ["isServer && (zsn_wce ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wse", "thisList spawn zsn_fnc_spawnwave_west;",""];};
		if (zsn_rse == east) then {zsn_est setTriggerStatements ["isServer && (zsn_wce ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wse", "thisList spawn zsn_fnc_spawnwave_east;",""];};
		if (zsn_rse == resistance) then {zsn_est setTriggerStatements ["isServer && (zsn_wce ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wse", "thisList spawn zsn_fnc_spawnwave_resistance;",""];};
		if (!isNil ("zsn_eft")) then {deleteVehicle zsn_eft;};
		zsn_eft = createTrigger ["EmptyDetector", getmarkerPos "respawn_east"];
		zsn_eft setTriggerTimeout [rd, rd, rd, true];
		zsn_eft setTriggerActivation ["civ", "PRESENT", true];
      		zsn_eft setTriggerStatements ["isServer && {alive _x && Side _x == east} count (allPlayers - entities 'HeadlessClient_F') < 1 && {Side _x == civilian} count thislist >= 1", "[zsn_rse, thisList] call zsn_fnc_allplayersdead;",""];
	};
	case west: {
		if (isNil ("respawn_west")) then {respawn_west = createMarker ["respawn_west", [0,100]];};
		zsn_ofw = 0;
		publicVariable "zsn_ofw";
		zsn_low = _zsn_lo;
		publicVariable "zsn_low";
		zsn_wcw = _zsn_wc;
		publicVariable "zsn_wcw";
		zsn_wsw = _zsn_ws;
		publicVariable "zsn_wsw";
		zsn_rsw = _zsn_rs;
		publicVariable "zsn_rsw";
		if (!isNil ("zsn_wst")) then {deleteVehicle zsn_wst;};
		zsn_wst = createTrigger ["EmptyDetector", getmarkerPos "respawn_west"];
		zsn_wst setTriggerActivation ["civ", "PRESENT", true];
		if (zsn_rsw == west) then {zsn_wst setTriggerStatements ["isServer && (zsn_wcw ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsw", "thisList spawn zsn_fnc_spawnwave_west;",""];};
		if (zsn_rsw == east) then {zsn_wst setTriggerStatements ["isServer && (zsn_wcw ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsw", "thisList spawn zsn_fnc_spawnwave_east;",""];};
		if (zsn_rsw == resistance) then {zsn_wst setTriggerStatements ["isServer && (zsn_wcw ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsw", "thisList spawn zsn_fnc_spawnwave_resistance;",""];};
		if (!isNil ("zsn_wft")) then {deleteVehicle zsn_wft;};
		zsn_wft = createTrigger ["EmptyDetector", getmarkerPos "respawn_west"];
		zsn_wft setTriggerTimeout [rd, rd, rd, true];
		zsn_wft setTriggerActivation ["civ", "PRESENT", true];
       		zsn_wft setTriggerStatements ["isServer && {alive _x && Side _x == west} count (allPlayers - entities 'HeadlessClient_F') < 1 && {Side _x == civilian} count thislist >= 1", "[zsn_rsw, thisList] call zsn_fnc_allplayersdead;",""];
	};
	case resistance: {
		if (!isNil ("respawn_guerrila")) then {respawn_guerrila = createMarker ["respawn_guerrila", [0,0]];};
		zsn_ofg = 0;
		publicVariable "zsn_ofg";
		zsn_log = _zsn_lo;
		publicVariable "zsn_log";
		zsn_wcg = _zsn_wc;
		publicVariable "zsn_wcg";
		zsn_wsg = _zsn_ws;
		publicVariable "zsn_wsg";
		zsn_rsg = _zsn_rs;
		publicVariable "zsn_rsg";
		if (!isNil ("zsn_gst")) then {deleteVehicle zsn_gst;};
		zsn_gst = createTrigger ["EmptyDetector", getmarkerPos "respawn_guerrila"];
		zsn_gst setTriggerActivation ["civ", "PRESENT", true];
		if (zsn_rsg == west) then {zsn_gst setTriggerStatements ["isServer && (zsn_wcg ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsg", "thisList spawn zsn_fnc_spawnwave_west;",""];};
		if (zsn_rsg == east) then {zsn_gst setTriggerStatements ["isServer && (zsn_wcg ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsg", "thisList spawn zsn_fnc_spawnwave_east;",""];};
		if (zsn_rsg == resistance) then {zsn_gst setTriggerStatements ["isServer && (zsn_wcg ^ 2) >= 1 && {Side _x == civilian} count thislist >= zsn_wsg", "thisList spawn zsn_fnc_spawnwave_resistance;",""];};
		if (!isNil ("zsn_gft")) then {deleteVehicle zsn_gft;};
		zsn_gft = createTrigger ["EmptyDetector", getmarkerPos "respawn_guerrila"];
		zsn_gft setTriggerTimeout [rd, rd, rd, true];
		zsn_gft setTriggerActivation ["civ", "PRESENT", true];
           	zsn_gft setTriggerStatements ["isServer && {alive _x && Side _x == resistance} count (allPlayers - entities 'HeadlessClient_F') < 1 && {Side _x == civilian} count thislist >= 1", "[zsn_rsg, thisList] call zsn_fnc_allplayersdead;",""];
	};
};
addMissionEventHandler ["entityKilled", {
	params ["_unit"]; 
	if (!isPlayer _unit) then {
		[_unit] join grpNull;
		_unit setVariable ["loadout", getUnitLoadout _unit]
   		};
 	}];
addMissionEventHandler ["entityRespawned", {
	params ["_unit"];
	if (!isPlayer _unit) then {
		[_unit] join createGroup CIVILIAN;
		_unit setUnitLoadout (_unit getVariable "loadout")
	};
}];