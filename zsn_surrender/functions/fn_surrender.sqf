
_this spawn
{
	private ["_this", "_ms"];
	_this = _this select 0;
	_ms = side _this;
	for "_i" from 1 to 2 do {_this addItem "ACE_CableTie";};
	if (_this in playableunits) exitwith {};
	waituntil {_ms knowsAbout (_this findNearestEnemy getpos _this) > 0};
	while {alive _this} do
	{
		if ([_this] call ace_medical_fnc_getUnconsciousCondition) then
		{
			[_this] join grpNull;
			waituntil {!([_this] call ace_medical_fnc_getUnconsciousCondition)};
			_this allowFleeing 1;
		};
		if (fleeing _this) then
		{
			if(_ms countSide nearestObjects [getpos _this, ["CAManBase"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] < 2) then
			{
				if (!(isNull objectParent _this)) then {unassignVehicle _this;};
				[_this, true] call ace_captives_fnc_setSurrendered;
				[_this] join grpNull;
				waituntil {_ms countSide nearestObjects [getpos _this, ["CAManBase"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] >= 2};
				[_this, false] call ace_captives_fnc_setSurrendered;
				[_this] join (nearestObjects [getpos _this, ["CAManBase"], 100] select 0);
			};
		};
	};
};