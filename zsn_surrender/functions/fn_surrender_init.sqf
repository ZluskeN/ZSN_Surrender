if (isServer) then {
	params ["_unit"];
	if (_unit isKindOf "CAManBase" && side _unit != CIVILIAN) then {
		_unit setvariable ["ZSN_Time", random 3, true];
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
			_unit addItem "ACE_CableTie";
		};
		_unit addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle"];
			if (_vehicle iskindof "Air" && _role != "cargo") then {
				[_unit] spawn {
					params ["_unit"];
					_unit setcaptive true;
					waituntil {getpos _unit select 2 < 2};
					_unit setcaptive false;
				};
			};
		}];
	};
};