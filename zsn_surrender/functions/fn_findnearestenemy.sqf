params ["_unit","_ms","_hopeless","_enemySides","_list","_nearEnemies","_nearestenemy","_dist","_targets","_isSurrendering"];
_hopeless = false;
_enemySides = _ms call BIS_fnc_enemySides;
_list = getpos _unit nearEntities ["AllVehicles", ZSN_surrenderdistance];
_nearEnemies = [_list, [_unit], {_unit distance _x}, "ASCEND", {side _x in _enemySides}] call BIS_fnc_sortBy;
if (count _nearEnemies > 0) then {
	_nearestenemy = _nearEnemies select 0;
	_dist = _nearestenemy distance _unit;
	_targets = getpos _unit nearEntities ["AllVehicles", _dist];
	if (_ms countSide _targets <= ZSN_Surrendercount) then {
		_hopeless = true;
		_unit doWatch _nearestenemy;
		_isSurrendering = _unit getVariable "ZSN_isSurrendering";
		if (!_isSurrendering) then {[_unit, "surrendered to", _nearestenemy] remoteexec ["zsn_fnc_hint"];};
	};
};
_hopeless