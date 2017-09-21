
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
class Extended_Init_EventHandlers 
{
	class CAManBase
	{
        	class zsn_surrender_init
		{
            		init = "_this call zsn_fnc_surrender";
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
	class ModuleCurator_F : Module_F
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
			file = "\zsn_surrender\functions";
			class surrender{};
		};
	};
};