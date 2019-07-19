////////////////////////////////////////////////////////////////////
//DeRap: zsn_surrender\config.bin
//Produced from mikero's Dos Tools Dll version 6.44
//'now' is Fri Jul 19 11:27:09 2019 : 'file' last modified on Fri Jul 19 11:23:09 2019
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#define _ARMA_

class CfgPatches
{
	class zsn_surrender
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1;
		requiredAddons[] = {"ace_common"};
	};
	class zsn_squat
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1;
		requiredAddons[] = {};
	};
};
class Extended_InitPost_EventHandlers
{
	class CAManBase
	{
		class zsn_surrenderInit
		{
			init = "_this call zsn_fnc_surrenderInit";
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
			curatorobjectplaced = "[_this select 1] call zsn_fnc_surrenderInit";
		};
	};
};
class CfgFunctions
{
	class ZSN
	{
		class Functions
		{
			class surrenderInit
			{
				file = "\zsn_surrender\functions\fn_surrender_init.sqf";
			};
			class WoundedEvent
			{
				file = "\zsn_surrender\functions\fn_wounded_event.sqf";
			};
			class surrenderCycle
			{
				file = "\zsn_surrender\functions\fn_surrender_cycle.sqf";
			};
			class Hint
			{
				file = "\zsn_surrender\functions\fn_hint.sqf";
			};
		};
	};
};
