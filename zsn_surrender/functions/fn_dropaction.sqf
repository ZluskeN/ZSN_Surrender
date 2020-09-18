#include "\a3\editor_f\Data\Scripts\dikCodes.h"
if (isClass(configFile >> "CfgPatches" >> "ace_hitreactions")) then {
	["ZluskeN", "Drop_Weapon", "Drop Weapon", {player call ace_hitreactions_fnc_throwWeapon}, {}] call cba_fnc_addKeybind;
} else {
	["ZluskeN", "Drop_Weapon", "Drop Weapon", {player call zsn_fnc_dropweapon}, {}] call cba_fnc_addKeybind;
};