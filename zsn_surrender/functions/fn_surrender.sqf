
_this spawn
{
	private ["_this", "_ms"];
	_this = _this select 0;
	_ms = side _this;
	waituntil {_ms knowsAbout (_this findNearestEnemy getpos _this) > 0};
	while {alive _this} do
	{
		if (!isplayer _this) then 
		{
			if ([_this] call ace_medical_fnc_getUnconsciousCondition) then
			{
				[_this] join grpNull;
				waituntil {!([_this] call ace_medical_fnc_getUnconsciousCondition)};
				_this allowFleeing 1;
			};
			if (fleeing _this) then
			{
				if(_ms countSide nearestObjects [getpos _this, [], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] < 2) then
				{
					if (!(isNull objectParent _this)) then {unassignVehicle _this;};
					[_this, true] call ace_captives_fnc_setSurrendered;
					waituntil {_ms countSide nearestObjects [getpos _this, [], (getpos (_this findNearestEnemy getpos _this)) distance (getpos _this)] >= 2};
					[_this, false] call ace_captives_fnc_setSurrendered;
				};
			};
		};
	};
};
