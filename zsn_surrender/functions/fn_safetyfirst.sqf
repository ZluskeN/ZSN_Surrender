
// Give FNGs safety vests, so they are easier to keep track of
if (isMultiplayer) then {
	if (isnil {squadParams player select 0 select 1}) then {
		removeVest player; 
		if (571710 in (getDLCs 1)) then	{
			player addvest selectRandom ["V_safety_yellow_F","V_safety_orange_F","V_safety_blue_F"];
		} else {
			if (isClass(configFile >> "CfgPatches" >> "us_military_units")) then {	
				player addvest "usm_vest_safety";
			} else {
				if (isClass(configFile >> "CfgPatches" >> "CUP_Creatures_Military_USMC")) then {
					player addvest selectRandom ["CUP_V_B_LHDVest_Yellow","CUP_V_B_LHDVest_White","CUP_V_B_LHDVest_Red","CUP_V_B_LHDVest_Blue"];
				} else {
					player addvest selectRandom ["V_DeckCrew_yellow_F","V_DeckCrew_white_F","V_DeckCrew_red_F","V_DeckCrew_blue_F"];
				};
			};
		};
	};
};
