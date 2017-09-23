
_this spawn
{
	private ["_this", "_ms"];
	_this = _this select 0;
	_ms = side _this;
	_this addItem "ACE_CableTie";
	if (_this in playableunits) exitwith {};
	waituntil {sleep 0.1; _this knowsAbout (_this findNearestEnemy getpos _this) > 0;};
	while {alive _this} do
	{
		if ([_this] call ace_medical_fnc_getUnconsciousCondition) then
		{
			waituntil {sleep 0.1; !([_this] call ace_medical_fnc_getUnconsciousCondition);};
			_this allowFleeing 1;
		};
		if (fleeing _this) then
		{
			if(_ms countSide nearestObjects [getpos _this, ["CAManBase"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] < 2) then
			{
				if (!(isNull objectParent _this)) then {unassignVehicle _this;};
				[_this, true] call ace_captives_fnc_setSurrendered;
				waituntil {sleep 0.1; _ms countSide nearestObjects [getpos _this, ["CAManBase"], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] >= 2;};
				[_this, false] call ace_captives_fnc_setSurrendered;
			};
		};
	};
};