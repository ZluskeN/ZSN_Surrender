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
class Extended_PreInit_EventHandlers 
{
    class zsn_hdc_settings
	{
        init = "call compile preprocessFileLineNumbers 'zsn_surrender\XEH_preInit.sqf'";
    };
};
class Extended_PostInit_EventHandlers
{
	class zsn_downed_init
	{
		init = "_this call zsn_fnc_downedinit";
	};
};
class Extended_InitPost_EventHandlers
{
	class CAManBase
	{
		class zsn_surrender_init
		{
			init = "_this select 0 call zsn_fnc_surrenderInit";
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
			class surrenderCycle
			{
				file = "\zsn_surrender\functions\fn_surrender_cycle.sqf";
			};
			class Recover
			{
				file = "\zsn_surrender\functions\fn_recover.sqf";
			};
			class Hint
			{
				file = "\zsn_surrender\functions\fn_hint.sqf";
			};
			class Alerted
			{
				file = "\zsn_surrender\functions\fn_alerted.sqf";
			};
			class dropWeapon
			{
				file = "\zsn_surrender\functions\fn_dropWeapon.sqf";
			};
			class downedInit
			{
				file = "\zsn_surrender\functions\fn_downedInit.sqf";
			};
			class findNearestEnemy
			{
				file = "\zsn_surrender\functions\fn_findNearestEnemy.sqf";
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
