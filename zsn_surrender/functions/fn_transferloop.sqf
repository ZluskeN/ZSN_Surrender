params ["_box"]; 
if (isNil "zsn_crateindex") then {
	zsn_crateindex = 0;
} else {
	zsn_crateindex = (zsn_crateindex + 1);
};
_box setVariable ["zsn_craterank", zsn_crateindex];
_box setVariable ["zsn_craterole", "Multi"];
_rank = zsn_crateindex; 
_handle = [{
	params ["_box"];
	_boxlist = _box nearSupplies 3;
	{
		if ((!(isNil {_x getVariable "zsn_craterank"})) && (_x getVariable "zsn_craterank") < _rank) then {
			_role = _x getVariable "zsn_craterole";
			switch (_role) do {
				case ("Multi"): {
					[_box, _x, ["weapons", "magazines", "items", "containers"], true, false] call zsn_fnc_transferContents;
					if (_x call ace_dragging_fnc_getWeight > ACE_maxWeightCarry) then {
						[_x, _box, ["weapons", "items"], false, false] call zsn_fnc_transferContents;	
						clearWeaponCargoGlobal _x;
						clearItemCargoGlobal _x;
						_x setVariable ["zsn_craterole", "Ammo"];
						_box setVariable ["zsn_craterole", "Items"];
					};
				};
				case ("Ammo"): {
					if (_x call ace_dragging_fnc_getWeight < ACE_maxWeightCarry) then {
						[_box, _x, ["magazines", "containers"], false, false] call zsn_fnc_transferContents;
						clearMagazineCargoGlobal _box;
						clearBackpackCargoGlobal _box;
						_box setVariable ["zsn_craterole", "Items"];
					};
				};
				case ("Items"): {
					if (_x call ace_dragging_fnc_getWeight < ACE_maxWeightCarry) then {
						[_box, _x, ["weapons", "items"], false, false] call zsn_fnc_transferContents;
						clearWeaponCargoGlobal _box;
						clearItemCargoGlobal _box;
						_box setVariable ["zsn_craterole", "Ammo"];
					};
				};
			};
		};
	} foreach _boxlist;
	if ((str getItemCargo _box == "[[],[]]" && str getBackpackCargo _box == "[[],[]]") && (str getMagazineCargo _box == "[[],[]]" && str getWeaponCargo _box == "[[],[]]")) then {
		deletevehicle _box;
	};
}, 3, _box] call CBA_fnc_addPerFrameHandler;

_box setVariable ["zsn_boxhandler", _handle];
_box addEventHandler ["Deleted", {
	params ["_box", "_killer", "_instigator", "_useEffects"];
	_handle = _box getVariable "zsn_boxhandler";
	[_handle] call CBA_fnc_removePerFrameHandler;
}];
