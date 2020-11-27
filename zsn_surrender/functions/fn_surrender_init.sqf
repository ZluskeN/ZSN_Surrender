if (isServer) then {
	params ["_unit"];
	if (isNil "cc") then {cc = []};
	publicVariable "cc";
	if (_unit isKindOf "CAManBase") then {
		_time = random 3;
		_unit setvariable ["ZSN_Dammage", 0, true];
		_unit setvariable ["ZSN_Side", side _unit, true];
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		[_unit, _time] remoteExec ["ZSN_fnc_alerted", _unit];
//		[_unit, _time] remoteExec ["ZSN_fnc_Dammage", _unit];
		if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
			_unit addItem "ACE_CableTie";
		};
		_unit addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle"];
			if (_vehicle iskindof "Air" && _role != "cargo") then {
				[_unit, _time] spawn {
					params ["_unit"];
					_unit setcaptive true;
					waituntil {getpos _unit select 2 < 2};
					_unit setcaptive false;
				};
			};
		}];
		if (isClass(configFile >> "CfgPatches" >> "ace_weaponselect")) then {
			if (!(hasInterface && isPlayer _unit)) then {
				if (currentWeapon _unit == handGunWeapon _unit) then {
					_unit spawn {
						params ["_unit","_time"];
						_time = random 3;
						while {alive _unit} do {
							if (currentWeapon _unit == handGunWeapon _unit) then {
								if ((behaviour _unit == "SAFE") OR (behaviour _unit == "CARELESS")) then {
									[_unit] call ace_weaponselect_fnc_putWeaponAway;
									waituntil {sleep _time; ((behaviour _unit != "CARELESS") && (behaviour _unit != "SAFE"));};
									_unit selectWeapon handgunWeapon _unit;
								};
							};
							sleep _time;
						};
					};
				};
			};
		};
	};
};