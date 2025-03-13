if (isServer) then {
	params ["_unit"];
	_grp = group _unit;
	_side = side _grp;
	if (_unit isKindOf "CAManBase" && _side != CIVILIAN) then {
		_unit setVariable ["ZSN_Group", _grp];
		_unit setvariable ["ZSN_Side", _side, true];
		{
			while {_item = (_x select 0); ({_x == _item} count items _unit) < (_x select 1)} do {
				_unit addItem (_x select 0);	
			};
		} forEach [["ACE_CableTie",1]];
		_unit addEventHandler ["Killed", {
			params ["_unit", "_killer", "_instigator", "_useEffects"];
			if (_unit == ACE_player) then {
				[{(_this select 0) call zsn_fnc_spawnstretcher}, [_unit], 5] call CBA_fnc_waitAndExecute;
			};
		}];
		_unit addEventHandler ["GetOutMan", {
			params ["_unit", "_role", "_vehicle"];
			if (_vehicle iskindof "Air" && _role != "cargo") then {
//				[_unit] spawn {
//					params ["_unit"];
					_unit setcaptive true;
					[{getpos (_this select 0) select 2 < 2}, {(_this select 0) setcaptive false}, [_unit]] call CBA_fnc_waitUntilAndExecute;
//					waituntil {sleep 1; getpos _unit select 2 < 2};
//					_unit setcaptive false;
//				};
			};
		}];
	};
};
