params ["_unit"];
_unit addEventHandler["HandleDamage",{
	[_this select 0, _this select 1, _this select 2, _this select 4] call {
		private ["_unit","_part","_dmg","_proj","_ms"];
		_unit = _this select 0;
		_part = _this select 1;
		_dmg = _this select 2;
		_proj = _this select 3;
		_ms = (_unit getVariable "ZSN_Side");
		if (alive _unit) then {
			if (_dmg > 0.1) then {
				if (random 1 < _dmg) then {
					if (isNull objectParent _unit) then {
						if (!(_unit getVariable "ZSN_isUnconscious")) then {
							_unit setvariable ["ZSN_isUnconscious", true, true];
							[_unit, _ms] remoteexec ["zsn_fnc_downed", _unit];
						};
					};
				};
			};
		};
		if (_proj == "") then {
			if (_part isEqualTo "") then {0} else {_unit getHit _part};
		} else {_dmg};
	};
}];
if (_unit getUnitTrait "Medic") then {
	_unit spawn zsn_fnc_medicloop;
};