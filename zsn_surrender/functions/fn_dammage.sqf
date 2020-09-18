params ["_unit", "_time","_ms"];
_ms = (_unit getVariable "ZSN_Side");
_unit addEventHandler ["HitPart", {
	_part = ((_this select 0) select 5); 
	_target = ((_this select 0) select 0); 
	_weapon = currentWeapon _target;
	[_target, "Was hit", _part] remoteexec ["zsn_fnc_hint"];	
	if ("hit_hands" in _part OR "hit_arms" in _part) then {
		if (isClass(configFile >> "CfgPatches" >> "ace_overheating") && random 2 < 1) then {
			[_target, currentWeapon _target] call ace_overheating_fnc_jamWeapon;
		} else {
			if (_weapon isKindOf ["Rifle_Base_F", configFile >> "CfgWeapons"]) then {
				_attachmentslist = primaryWeaponItems _target; 
				_attachments = []; 
				{if (_x != "") then {_attachments pushback _x}} foreach _attachmentslist; 
				{_attachments pushback _x} foreach primaryWeaponMagazine _target; 
				_attachment = _attachments select floor random count _attachments; 
				_target removePrimaryWeaponItem _attachment; 
			};
		};
		if (isClass(configFile >> "CfgPatches" >> "ace_hitreactions")) then {
			_target call ace_hitreactions_fnc_throwWeapon;
		} else {
			_target call zsn_fnc_dropweapon;
		};
		[_target, true, _ms] spawn zsn_fnc_recover;
	};
}];
while {alive _unit} do {
	sleep _time;
	_ms = (_unit getVariable "ZSN_Side");	
	if ((lifestate _unit == "INCAPACITATED") && (isNull objectParent _unit)) then {
		if (!(_unit getVariable "ZSN_isUnconscious")) then {
			_unit setvariable ["ZSN_isUnconscious", true, true];
			[_unit, "Went down", _ms] remoteexec ["zsn_fnc_hint"];	
			isNil {[_unit, false, _ms] call zsn_fnc_recover;};
			[_unit, _ms, _time] spawn {
				params ["_unit","_ms","_time"];
				while {(lifestate _unit == "INCAPACITATED")} do {
					sleep _time;
					_unit setSuppression 1;
					_unit setCaptive true;
				};
				if (!alive _unit) exitWith {};
				_unit allowFleeing 1;
				_unit setvariable ["ZSN_isUnconscious", false, true];
				isNil {[_unit, _ms, _time] call zsn_fnc_surrenderCycle;};
			};
		};
	};
};