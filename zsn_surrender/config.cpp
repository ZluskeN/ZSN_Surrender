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
		requiredAddons[] = {"cba_main"};
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
		class zsn_dropWeapon
		{
			init = "nul = [] execVM 'zsn_surrender\functions\fn_dropaction.sqf'";
		};
	};
};
//class cfgvehicles
//{
//	class Logic;
//	class module_F: Logic
//	{
//		class EventHandlers;
//	};
//	class ModuleCurator_F: Module_F
//	{
//		class EventHandlers
//		{
//			init = "_this call bis_fnc_moduleInit;";
//			curatorobjectplaced = "[_this select 1] call zsn_fnc_surrenderInit";
//		};
//	};
//};
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
			class surrenderCycle
			{
				file = "\zsn_surrender\functions\fn_surrender_cycle.sqf";
			};
			class Recover
			{
				file = "\zsn_surrender\functions\fn_recover.sqf";
			};
//			class Dammage
//			{
//				file = "\zsn_surrender\functions\fn_dammage.sqf";
//			};
			class Hint
			{
				file = "\zsn_surrender\functions\fn_hint.sqf";
			};
//			class Downed
//			{
//				file = "\zsn_surrender\functions\fn_downed.sqf";
//			};
			class Alerted
			{
				file = "\zsn_surrender\functions\fn_alerted.sqf";
			};
//			class medicLoop
//			{
//				file = "\zsn_surrender\functions\fn_medicloop.sqf";
//			};
			class dropAction
			{
				file = "\zsn_surrender\functions\fn_dropAction.sqf";
			};
			class dropWeapon
			{
				file = "\zsn_surrender\functions\fn_dropWeapon.sqf";
			};
		};
	};
};
class CfgRemoteExec
{
	class Functions
	{
		class ZSN_fnc_surrenderCycle {};
		class ZSN_fnc_Dammage {};
		class ZSN_fnc_Alerted {};
		class ZSN_fnc_Hint {};
	};
};
