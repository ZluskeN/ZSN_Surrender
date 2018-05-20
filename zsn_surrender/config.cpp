////////////////////////////////////////////////////////////////////
//DeRap: Produced from mikero's Dos Tools Dll version 5.66
//'now' is Fri May 18 21:57:49 2018 : 'file' last modified on Thu May 17 21:49:21 2018
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#define _ARMA_

//Class zsn_surrender : config.bin{
class CfgPatches
{
	class zsn_surrender
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1;
		requiredAddons[] = {"ace_common"};
	};
};
class Extended_InitPost_EventHandlers
{
	class CAManBase
	{
		class zsn_surrender_init
		{
			init = "_this spawn zsn_fnc_surrender";
		};
	};
};
class cfgvehicles
{
	class Logic;
	class module_F: Logic
	{
		class EventHandlers;
	};
	class ModuleCurator_F: Module_F
	{
		class EventHandlers
		{
			init = "_this call bis_fnc_moduleInit;";
			curatorobjectplaced = "[_this select 1] call zsn_fnc_surrender";
		};
	};
};
class CfgFunctions
{
	class ZSN
	{
		class Functions
		{
			class surrender
			{
				file = "\zsn_surrender\functions\fn_surrender.sqf";
			};
		};
	};
};
//};
