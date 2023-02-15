params ["_box"]; 
if (isNil "zsn_crateindex") then {
	zsn_crateindex = 0;
} else {
	zsn_crateindex = (zsn_crateindex + 1);
};
_box setVariable ["zsn_craterank", zsn_crateindex];
_box setVariable ["zsn_craterole", "Multi"];
_rank = zsn_crateindex; 
waituntil {
	sleep 3; 
	_boxlist = _box nearSupplies 3;
	{
		if ((!(isNil {_x getVariable "zsn_craterank"})) && (_x getVariable "zsn_craterank") < _rank) then {
			_role = _x getVariable "zsn_craterole";
			switch (_role) do {
				case ("Multi"): {
					[_box, _x, ["weapons", "magazines", "items", "containers"], true, false] call zsn_fnc_transferContents;
					if (_x call ace_dragging_fnc_getWeight > (ACE_maxWeightCarry*(7/8))) then {
						[_x, _box, ["weapons", "items"], false, false] call zsn_fnc_transferContents;	
						clearWeaponCargoGlobal _x;
						clearItemCargoGlobal _x;
						_x setVariable ["zsn_craterole", "Ammo"];
						_box setVariable ["zsn_craterole", "Items"];
					};
				};
				case ("Ammo"): {
					if (_x call ace_dragging_fnc_getWeight < (ACE_maxWeightCarry*(7/8))) then {
						[_box, _x, ["magazines", "containers"], false, false] call zsn_fnc_transferContents;
						clearMagazineCargoGlobal _box;
						clearBackpackCargoGlobal _box;
						_box setVariable ["zsn_craterole", "Items"];
					};
				};
				case ("Items"): {
					if (_x call ace_dragging_fnc_getWeight < (ACE_maxWeightCarry*(7/8))) then {
						[_box, _x, ["weapons", "items"], false, false] call zsn_fnc_transferContents;
						clearWeaponCargoGlobal _box;
						clearItemCargoGlobal _box;
						_box setVariable ["zsn_craterole", "Ammo"];
					};
				};
			};
		};
	} foreach _boxlist;
	if (_box call ace_dragging_fnc_getWeight == 0) then {
		deletevehicle _box;
		true
	};
	false
}; 