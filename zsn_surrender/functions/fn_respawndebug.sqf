if (!isNil ("zsn_est")) then {[east, zsn_wse, zsn_wce, zsn_loe, zsn_pvp, zsn_rse] call zsn_fnc_waverespawn;};
if (!isNil ("zsn_wst")) then {[west, zsn_wsw, zsn_wcw, zsn_low, zsn_pvp, zsn_rsw] call zsn_fnc_waverespawn;};
if (!isNil ("zsn_gst")) then {[resistance, zsn_wsg, zsn_wcg, zsn_log, zsn_pvp, zsn_rsg] call zsn_fnc_waverespawn;};
