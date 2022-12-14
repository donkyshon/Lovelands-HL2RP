--[[
	© 2018 Thriving Ventures AB do not share, re-distribute or modify
	
	without permission of its author (gustaf@thrivingventures.com).
]]

local plugin = plugin;

plugin.name = "Sandbox Settings";
plugin.author = "alexgrist";
plugin.version = "1.0";
plugin.description = "Sandbox settings.";
plugin.permissions = {"Sandbox settings"};

plugin.convars = {
	"sbox_maxballoons",
	"sbox_maxbuttons",
	"sbox_maxdynamite",
	"sbox_maxeffects",
	"sbox_maxemitters",
	"sbox_maxhoverballs",
	"sbox_maxlamps",
	"sbox_maxlights",
	"sbox_maxnpcs",
	"sbox_maxprops",
	"sbox_maxragdolls",
	"sbox_maxsents",
	"sbox_maxspawners",
	"sbox_maxthrusters",
	"sbox_maxturrets",
	"sbox_maxvehicles",
	"sbox_maxwheels",
	
	"sbox_maxdoors",
	"sbox_maxhoverboards",
	"sbox_maxkeypads",
	"sbox_maxwire_keypads",
	
	"sbox_maxwire_addressbuss",
	"sbox_maxwire_adv_emarkers",
	"sbox_maxwire_adv_inputs",
	"sbox_maxwire_buttons",
	"sbox_maxwire_cameracontrollers",
	"sbox_maxwire_cd_disks",
	"sbox_maxwire_cd_locks",
	"sbox_maxwire_cd_rays",
	"sbox_maxwire_clutchs",
	"sbox_maxwire_colorers",
	"sbox_maxwire_consolescreens",
	"sbox_maxwire_cpus",
	"sbox_maxwire_damage_detectors",
	"sbox_maxwire_data_satellitedishs",
	"sbox_maxwire_data_stores",
	"sbox_maxwire_data_transferers",
	"sbox_maxwire_dataplugs",
	"sbox_maxwire_dataports",
	"sbox_maxwire_datarates",
	"sbox_maxwire_datasockets",
	"sbox_maxwire_deployers",
	"sbox_maxwire_detonators",
	"sbox_maxwire_dhdds",
	"sbox_maxwire_digitalscreens",
	"sbox_maxwire_dual_inputs",
	"sbox_maxwire_dynamic_buttons",
	"sbox_maxwire_egps",
	"sbox_maxwire_emarkers",
	"sbox_maxwire_exit_points",
	"sbox_maxwire_explosives",
	"sbox_maxwire_expressions",
	"sbox_maxwire_extbuss",
	"sbox_maxwire_eyepods",
	"sbox_maxwire_forcers",
	"sbox_maxwire_freezers",
	"sbox_maxwire_fx_emitters",
	"sbox_maxwire_gate_angles",
	"sbox_maxwire_gate_arithmetics",
	"sbox_maxwire_gate_arrays",
	"sbox_maxwire_gate_bitwises",
	"sbox_maxwire_gate_comparisons",
	"sbox_maxwire_gate_entitys",
	"sbox_maxwire_gate_logics",
	"sbox_maxwire_gate_memorys",
	"sbox_maxwire_gate_rangers",
	"sbox_maxwire_gate_selections",
	"sbox_maxwire_gate_strings",
	"sbox_maxwire_gate_times",
	"sbox_maxwire_gate_trigs",
	"sbox_maxwire_gate_vectors",
	"sbox_maxwire_gates",
	"sbox_maxwire_gimbals",
	"sbox_maxwire_gpss",
	"sbox_maxwire_gpus",
	"sbox_maxwire_grabbers",
	"sbox_maxwire_graphics_tablets",
	"sbox_maxwire_gyroscopes",
	"sbox_maxwire_hdds",
	"sbox_maxwire_holoemitters",
	"sbox_maxwire_hologrids",
	"sbox_maxwire_hoverballs",
	"sbox_maxwire_hoverdrivecontrolers",
	"sbox_maxwire_hudindicators",
	"sbox_maxwire_hydraulics",
	"sbox_maxwire_igniters",
	"sbox_maxwire_indicators",
	"sbox_maxwire_inputs",
	"sbox_maxwire_keyboards",
	"sbox_maxwire_keypads",
	"sbox_maxwire_lamps",
	"sbox_maxwire_las_receivers",
	"sbox_maxwire_latchs",
	"sbox_maxwire_levers",
	"sbox_maxwire_lights",
	"sbox_maxwire_locators",
	"sbox_maxwire_motors",
	"sbox_maxwire_nailers",
	"sbox_maxwire_numpads",
	"sbox_maxwire_oscilloscopes",
	"sbox_maxwire_outputs",
	"sbox_maxwire_pixels",
	"sbox_maxwire_plugs",
	"sbox_maxwire_pods",
	"sbox_maxwire_radios",
	"sbox_maxwire_rangers",
	"sbox_maxwire_relays",
	"sbox_maxwire_screens",
	"sbox_maxwire_sensors",
	"sbox_maxwire_simple_explosives",
	"sbox_maxwire_sockets",
	"sbox_maxwire_soundemitters",
	"sbox_maxwire_spawners",
	"sbox_maxwire_speedometers",
	"sbox_maxwire_spus",
	"sbox_maxwire_target_finders",
	"sbox_maxwire_textreceivers",
	"sbox_maxwire_textscreens",
	"sbox_maxwire_thrusters",
	"sbox_maxwire_trails",
	"sbox_maxwire_turrets",
	"sbox_maxwire_twoway_radios",
	"sbox_maxwire_users",
	"sbox_maxwire_values",
	"sbox_maxwire_vectorthrusters",
	"sbox_maxwire_vehicles",
	"sbox_maxwire_watersensors",
	"sbox_maxwire_waypoints",
	"sbox_maxwire_weights",
	"sbox_maxwire_wheels"
};
