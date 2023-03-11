if (isServer) then {
	params ["_unit"];
	_side = side group _unit;
	if (_unit isKindOf "CAManBase" && _side != CIVILIAN) then {
		_unit setvariable ["ZSN_Side", _side, true];
		{
			while {_item = (_x select 0); ({_x == _item} count items _unit) < (_x select 1)} do {
				_unit addItem (_x select 0);	
			};
		} forEach [["ACE_CableTie",1]];
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