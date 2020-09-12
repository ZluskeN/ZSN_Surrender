if (isServer) then {
	params ["_unit"];
	if (isNil "cc") then {cc = []};
	publicVariable "cc";
	if (_unit isKindOf "CAManBase") then {
		_unit setUnitPosWeak "UP";
		_unit setCombatMode "WHITE";
		_unit setvariable ["ZSN_Dammage", 0, true];
		_unit setvariable ["ZSN_Side", side _unit, true];
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isUnconscious", false, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		_unit remoteExec ["ZSN_fnc_alerted", _unit];
		_unit remoteExecCall ["ZSN_fnc_Dammage", _unit];
		_unit addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle", "_turret"];
			if (_vehicle iskindof "Air" && _role != "cargo") then {
				_unit spawn {
					params ["_unit","_time"];
					_time = random 3;
					_unit setcaptive true;
					waituntil {sleep _time; getpos _unit select 2 < 2};
					_unit setcaptive false;
				};
			};
		}];
		if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
			_unit addItem "ACE_CableTie";
			if (currentWeapon _unit isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]) then {
				_unit spawn {
					private ["_unit","_time"];
					_unit = _this;
					_time = random 3;
					while {alive _unit} do {
						if (!(hasInterface && isPlayer _unit)) then {
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