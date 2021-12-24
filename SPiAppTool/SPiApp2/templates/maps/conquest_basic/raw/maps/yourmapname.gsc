#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_utility_code;

#using_animtree("generic_human");

main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;

	precacheitem("mp5");
	
	conquest_map_settings(); // Set map specific conquest settings.
	maps\_conquest::main(); // Call Conquest mode.
	level.early_level[ level.script ] = false; // Prevents an annoying error.

	// Switching off battlechatter.
	battlechatter_off("axis");
	battlechatter_off("allies");
	
	wait 0.05; // Must wait at least 0.05 before calling any dvars in our code.
	setsaveddvar( "cg_fov" , "80" );	
	maps\_compass::setupMiniMap("compass_map_killhouse"); // Assign the map of your map when taken.
	setsaveddvar( "compassmaxrange", 2000 );

}	

conquest_map_settings()
{
	// This let's the _conquest.gsc know that you put your own match settings for the map.
	// Comment this or the whole function to allow default match settings to be applied.
	// level.custom_conquest_match_settings = 1; 
	
	if( !(isdefined(level.custom_conquest_match_settings)))
		return;

	iprintlnbold(&"CUSTOM_MATCH_SETTINGS");

	// Time
	level.match_time = 900;
	// Bots
	level.max_team_bots = 6; //15
	level.max_bots = level.max_team_bots*2;
	// Teams
	points = 1200;
	level.max_team_points = points;
	level.team1_points = points;
	level.team2_points = points;
	level.allies_color = (0,0.5,1); // Light Blue 
	level.axis_color = (1,0,0); // Red
	level.neutral_color = (0.85,0.85,0.85); // Greyish
	// Misc
	level.wind_angles = (0,30,0);
	// Points: For points wait 0.05 or more so the flags are initialized
	thread custom_match_flag_team();
}

custom_match_flag_team()
{
	wait 0.05;
	level.flags[0] maps\_conquest::flag_set_team("allies");
	level.flags[2] maps\_conquest::flag_set_team("axis");
}
























