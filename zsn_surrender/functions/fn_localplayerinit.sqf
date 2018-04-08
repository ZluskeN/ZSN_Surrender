// Save inventory if altered in editor, to load later on respawn
[player, [missionNamespace, "inventory_var"]] call BIS_fnc_saveInventory;

// Remove magazine from gun and add it to inventory
call zsn_fnc_clearweapon;

// Create trigger on respawn markers, which will be consulted when displaying explanatory hints on player death
zsn_eplayer_trg = createTrigger ["EmptyDetector", getmarkerPos "respawn_east"];
zsn_eplayer_trg setTriggerActivation ["civ", "PRESENT", true];				
zsn_wplayer_trg = createTrigger ["EmptyDetector", getmarkerPos "respawn_west"];
zsn_wplayer_trg setTriggerActivation ["civ", "PRESENT", true];
zsn_gplayer_trg = createTrigger ["EmptyDetector", getmarkerPos "respawn_guerrila"];
zsn_gplayer_trg setTriggerActivation ["civ", "PRESENT", true];

// Add script to respawn event, which will initialize spectating and handle counters
player addEventHandler ["Respawn", {
	[player] join grpNull;
	titleText ["", "BLACK OUT"];
	[player, [missionNamespace, "inventory_var"]] call BIS_fnc_loadInventory;
	if ((player inArea zsn_eplayer_trg) OR (player inArea zsn_wplayer_trg)  OR (player inArea zsn_gplayer_trg)) then {
		["Initialize",[player, [playerside], false, false, true, true, true, true, true, true]] call BIS_fnc_EGSpectator;
		if (isClass(configFile >> "CfgPatches" >> "task_force_radio")) then {[player, true] call TFAR_fnc_forceSpectator;};
		switch (playerSide) do {
			case east: {
				if ((zsn_wce ^ 2) >= 1) then {
					if ((zsn_wse - (count list zsn_eplayer_trg)) > 1) then {
						hint format ["Wave Respawn is in effect, wave size is %1. You will respawn when %2 more players die.", zsn_wse, (zsn_wse - (count list zsn_eplayer_trg + 1))];
					} else {
						hint format ["Wave Respawn is in effect, wave size is %1.", zsn_wse];
					};
				};
			};
			case west: {
				if ((zsn_wcw ^ 2) >= 1) then {
					if ((zsn_wsw - (count list zsn_wplayer_trg)) > 1) then {
						hint format ["Wave Respawn is in effect, wave size is %1. You will respawn when %2 more players die.", zsn_wsw, (zsn_wsw - (count list zsn_wplayer_trg + 1))];
					} else {
						hint format ["Wave Respawn is in effect, wave size is %1.", zsn_wsw];
					};
				};
			};
			case resistance: {
				if ((zsn_wcg ^ 2) >= 1) then {
					if ((zsn_wsg - (count list zsn_gplayer_trg)) > 1) then {
						hint format ["Wave Respawn is in effect, wave size is %1. You will respawn when %2 more players die.", zsn_wsg, zsn_wsg - (count list zsn_gplayer_trg + 1)];
					} else {
						hint format ["Wave Respawn is in effect, wave size is %1.", zsn_wsg];
					};	
				};
			};
		};
		[player] join createGroup CIVILIAN;
	};
	titleText ["", "BLACK IN"];
}];
