["ZSN_Surrenderdistance",	"SLIDER",	["Surrender distance","Units will start surrendering when enemies are closer than this"],			["ZluskeN Hors de Combat"],[0,1000,100,0],	nil,{params ["_value"]; ZSN_Surrenderdistance = _value;},false] call CBA_fnc_addSetting;
["ZSN_Surrendercount",		"SLIDER",	["Surrender count","Units will surrender when they are fewer than this"],							["ZluskeN Hors de Combat"],[0,12,2,0],		nil,{params ["_value"]; ZSN_Surrendercount = _value;},false] call CBA_fnc_addSetting;
["ZSN_WeaponsDrop",			"LIST",		["Units Drop Weapons","Sets whether units will drop their held weapon when they go unconscious"],	["ZluskeN Hors de Combat"],[["true","AI","false"],["Yes","Only AI","No"],0],nil,{params ["_value"]; ZSN_WeaponsDrop = _value;},false] call CBA_fnc_addSetting;
["ZSN_UnconsciousAction",	"LIST",		["Unconscious Action","When a player has been unconscious for the time defined below, they can be placed in spectator mode or respawned. If they are respawned, their body will be replaced by an AI unit"],["ZluskeN Hors de Combat"],[["Nothing","Spectator","Respawn"],["Nothing","Spectator","Respawn"], 0],nil,{params ["_value"]; ZSN_UnconsciousAction = _value;},false] call CBA_fnc_addSetting;
["ZSN_UnconsciousTimer",	"SLIDER",	["Unconscious Timer","Time spent Unconscious before Unconscious Action happens"],					["ZluskeN Hors de Combat"],[5,600,300,0],	nil,{params ["_value"]; ZSN_UnconsciousTimer = _value;},false] call CBA_fnc_addSetting;
["ZSN_CreateBox",			"CHECKBOX",	["Create ammobox with possessions","An ammobox is created with the wounded units possessions"],		["ZluskeN Hors de Combat"],True,			nil,{params ["_value"]; ZSN_CreateBox = _value;},false] call CBA_fnc_addSetting;
["ZSN_SpawnStretcher",		"CHECKBOX",	["Stretcher for Casualties","A stretcher is spawned for wounded units (Vurtual Seat)"],				["ZluskeN Hors de Combat"],True,			nil,{params ["_value"]; ZSN_SpawnStretcher = _value;},false] call CBA_fnc_addSetting;
["ZSN_BodyBags",			"CHECKBOX",	["Put dead units in bodybags","When players die, their body is replaced by a bodybag"],				["ZluskeN Hors de Combat"],True,			nil,{params ["_value"]; ZSN_BodyBags = _value;},false] call CBA_fnc_addSetting;
["ZSN_RedeemLiving",		"SLIDER",	["Redeem living units","Living units (Unconscious and POW) can be returned to flagpole for extra respawn tickets (TUN Respawn)"],["ZluskeN Hors de Combat"],[0,12,2,0],nil,{params ["_value"]; ZSN_RedeemLiving = _value;},false] call CBA_fnc_addSetting;
["ZSN_RedeemDead",			"SLIDER",	["Redeem dead units","Dead units (in Bodybags) can be returned to flagpole for extra respawn tickets (TUN Respawn)"],["ZluskeN Hors de Combat"],[0,12,1,0],nil,{params ["_value"]; ZSN_RedeemDead = _value;},false] call CBA_fnc_addSetting;
