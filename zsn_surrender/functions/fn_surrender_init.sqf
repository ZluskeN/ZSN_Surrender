if (isServer) then {
	params ["_unit"];
	if (_unit isKindOf "CAManBase" && side _unit != CIVILIAN) then {
		_unit setvariable ["ZSN_Side", side _unit, true];
		_unit setvariable ["ZSN_isRedeemable", false, true];
		if (isClass(configFile >> "CfgPatches" >> "ace_captives")) then {
			_unit addItem "ACE_CableTie";
		};
		_unit addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle"];
			if (_vehicle iskindof "Air" && _role != "cargo") then {
				[_unit] spawn {
					params ["_unit"];
					_unit setcaptive true;
					waituntil {sleep 1; getpos _unit select 2 < 2};
					_unit setcaptive false;
				};
			};
		}];
	};
};