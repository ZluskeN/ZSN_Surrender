params ["_oldunit", "_lifestate"];

_oldunit allowDamage false;
_pos = getPos _oldunit;
_dir = getDir _oldunit;
ZSN_loadOut = getUnitLoadout _oldunit;
_medState = [_oldunit] call ace_medical_fnc_serializeState;
_side = side group _oldunit;

_newgrp = creategroup (_side);
(typeof _oldunit) createUnit [[(random 20 - 10), (random 20 - 10), 0], _newgrp, "ZSN_newunit = this; this setUnitLoadout ZSN_loadOut;"];
ZSN_newunit setcaptive true;
[ZSN_newunit, face _oldunit] call BIS_fnc_setIdentity;
ZSN_newunit setName [name _oldunit,"",name _oldunit];
ZSN_newunit setUnitRank rank _oldunit;
ZSN_newunit setvariable ["ZSN_Side", _side, true];
[ZSN_newunit, _medState] call ace_medical_fnc_deserializeState;
if (_lifestate == "INCAPACITATED") then {
	[ZSN_newunit, true, 3600] call ace_medical_fnc_setUnconscious;
	[ZSN_newunit, true] call ace_medical_engine_fnc_setUnconsciousAnim;
} else {
	[ZSN_newunit, true, ZSN_newunit] call ACE_captives_fnc_setHandcuffed;
	[_side, 1] Call zsn_fnc_addtuntickets;
};
if (vehicle _oldunit == _oldunit) then {
	if (!isnull (_oldunit getVariable "ace_common_owner")) then {
		_carrier = _oldunit getVariable "ace_common_owner";
		if (_carrier getVariable "ace_dragging_isDragging") then {
			[_carrier, _oldunit] call ace_dragging_fnc_dropObject;
		};
		if (_carrier getVariable "ace_dragging_isCarrying") then {
			[_carrier, _oldunit] call ace_dragging_fnc_dropObject_carry;
		};
		if (_carrier getVariable "ace_captives_isEscorting") then {
			[_carrier, _oldunit, false] call ACE_captives_fnc_doEscortCaptive;
		};
	};
	_unconAnim = animationState _oldunit;
	[ZSN_newunit, _unconAnim, 2] call ace_common_fnc_doAnimation;
	_oldunit setPos [(random 20 - 10), (random 20 - 10), 0];
	ZSN_newunit setDir _dir;
	ZSN_newunit setVehiclePosition [_pos, [], 0, "CAN_COLLIDE"];
} else {
	_vehicle = vehicle _oldunit;
	_crew = fullCrew _vehicle;
	{
		if (_oldunit in _x) exitWith {
			_oldunit moveOut _vehicle;
			_oldunit setPos [(random 20 - 10), (random 20 - 10), 0];
			[_vehicle, ZSN_newunit, [_x select 1, _x select 3]] call BIS_fnc_moveIn;
		};
	} foreach _crew;
};

_oldunit setcaptive false;
_oldunit allowDamage true;
_oldunit setDammage 1;
[{_this call zsn_fnc_spawnstretcher}, [ZSN_newunit], 5] call CBA_fnc_waitAndExecute;