params ["_unit","_ms","_time","_isSurrendering","_willsurrender","_hopeless"];
if (!(hasinterface && isplayer _unit)) then {
	_hopeless = [_unit, _ms] call zsn_fnc_findnearestenemy;
	if (_hopeless) then {
		_unit setvariable ["ZSN_Group", group _unit, true];
		_unit setvariable ["ZSN_isSurrendering", true, true];
		if (!(isNull objectParent _unit)) then {
			doGetOut _unit;
			waitUntil {sleep _time; isNull objectParent _unit};
		};
		_unit setCaptive true;
		[_unit] joinsilent grpNull;
		if (count weaponsItems _unit > 0) then {_unit call ace_hitreactions_fnc_throwWeapon};
		[_unit, true] call ace_captives_fnc_setSurrendered;
	} else {
		_unit setvariable ["ZSN_isSurrendering", false, true];
		_unit setCaptive false;
		[_unit, _ms] remoteexecCall ["zsn_fnc_recover", _unit];
		_unit setSuppression 0;
	};
};