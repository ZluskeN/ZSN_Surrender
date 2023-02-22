params ["_unit","_ms"];
if (!(hasinterface && isplayer _unit)) then {
	if ([_unit, _ms] call zsn_fnc_findnearestenemy) then {
		_unit setCaptive true;
		[_unit] joinsilent grpNull;
		if (count weaponsItems _unit > 0) then {_unit call ace_hitreactions_fnc_throwWeapon};
		[_unit, true] call ace_captives_fnc_setSurrendered;
	} else {
		_redeemable = _unit getvariable "ZSN_isRedeemable";
		if (!_redeemable) then {[_unit, _ms] remoteexecCall ["zsn_fnc_recover", _unit]};
	};
};