params [
	["_zsn_side",""],
	["_zsn_list",""]
];
switch (_zsn_side) do {
	case east: {
		if ((zsn_wce ^ 2) >= 1) then {
			_zsn_list spawn zsn_fnc_spawnwave_east;
		} else {
			if (zsn_pvp) then {
				'SideScore' call BIS_fnc_endMissionServer;
			} else {
				'EveryoneLost' call BIS_fnc_endMissionServer;
			};
		};
	};
	case west: {
		if ((zsn_wcw ^ 2) >= 1) then {
			_zsn_list spawn zsn_fnc_spawnwave_west;
		} else {
			if (zsn_pvp) then {
				'SideScore' call BIS_fnc_endMissionServer;
			} else {
				'EveryoneLost' call BIS_fnc_endMissionServer;
			};
		};
	};
	case resistance: {
		if ((zsn_wcg ^ 2) >= 1) then {
			_zsn_list spawn zsn_fnc_spawnwave_resistance;
		} else {
			if (zsn_pvp) then {
				'SideScore' call BIS_fnc_endMissionServer;
			} else {
				'EveryoneLost' call BIS_fnc_endMissionServer;
			};
		};
	};
};

