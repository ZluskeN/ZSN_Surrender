if (isServer) then {
	params ["_unit"];
	_unit setvariable ["ZSN_Side", side _unit, true];
	if (_unit isKindOf "CAManBase" && side _unit != CIVILIAN) then {
		_time = random 3;
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isSurrendering", false, true];
		[_unit, _time] remoteExec ["ZSN_fnc_alerted", _unit];
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
	};
};