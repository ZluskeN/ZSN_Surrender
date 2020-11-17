if (isServer) then {
	params ["_unit"];
	if (isNil "cc") then {cc = []};
	publicVariable "cc";
	if (_unit isKindOf "CAManBase") then {
		_time = random 3;
		_unit setUnitPosWeak "UP";
		_unit setCombatMode "WHITE";
		_unit setvariable ["ZSN_Dammage", 0, true];
		_unit setvariable ["ZSN_Side", side _unit, true];
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		[_unit, _time] remoteExec ["ZSN_fnc_alerted", _unit];
//		[_unit, _time] remoteExec ["ZSN_fnc_Dammage", _unit];
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
		if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
			_unit addItem "ACE_CableTie";
			if (currentWeapon _unit isKindOf ["Pistol_Base_F", configFile >> "CfgWeapons"]) then {
				[_unit, _time] spawn {
					params ["_unit","_time"];
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
	if (isClass(configFile >> "CfgPatches" >> "ace_medical_engine")) then {
		["ace_unconscious", { // global event (runs on all machines)
			params ["_unit", "_isUnconscious","_time","_ms"];
			_time = random 3;
			_ms = (_unit getVariable "ZSN_Side");	
			if ((_isUnconscious) && (isNull objectParent _unit)) then {
				if (!(_unit getVariable "ZSN_isUnconscious")) then {
					_unit setvariable ["ZSN_isUnconscious", true, true];
					[_unit, "Went down", _ms] remoteexec ["zsn_fnc_hint"];	
					isNil {[_unit, false, _ms] call zsn_fnc_recover;};
					[_unit, _ms, _time] spawn {
						params ["_unit","_ms","_time"];
						while {(lifestate _unit == "INCAPACITATED")} do {
							sleep _time;
							_unit setSuppression 1;
							_unit setCaptive true;
						};
						if (!alive _unit) exitWith {};
						_unit allowFleeing 1;
						_unit setvariable ["ZSN_isUnconscious", false, true];
						isNil {[_unit, _ms, _time] call zsn_fnc_surrenderCycle;};
					};
				};
			};
		}] call CBA_fnc_addEventHandler;
	};
};