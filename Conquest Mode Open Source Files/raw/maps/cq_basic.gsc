#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_utility_code;
#using_animtree("generic_human");

main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	
	conquest_map_settings(); // Set map specific conquest settings.
	maps\_conquest::main(); // Call Conquest mode.
	
	wait 0.05; // Must wait at least 0.05 before calling any dvars in our code.
	setsaveddvar( "cg_fov" , "80" );	
	maps\_compass::setupMiniMap("compass_map_cq_basic"); // Assign the map of your map when taken.
	setsaveddvar( "compassmaxrange", 2000 );
}	

conquest_map_settings()
{
	// This must be called here whatsoever
	thread custom_match_flag_team(); 

	// This lets the _conquest.gsc know that you put your own match settings for the map.
	//level.custom_conquest_match_settings = 1; // Comment this or the whole function to allow default match settings to be applied.
	if( !(isdefined(level.custom_conquest_match_settings)))
		return;

	//iprintlnbold(&"CUSTOM_MATCH_SETTINGS");
	// Time
	level.match_time = 600;
	// Bots
	level.max_team_bots = 10; //15
	level.max_bots = level.max_team_bots*2;
	// Teams
	points = 500;
	level.max_team_points = points;
	level.team1_points = points;
	level.team2_points = points;
	level.allies_color = (0,0.8,0); // Green
	level.axis_color = (1,0,0); // Red
	level.neutral_color = (0.85,0.85,0.85); // Greyish
}

custom_match_flag_team()
{
	wait 0.05;
	level.custom_flag_teams = 1; // This lets _conquest.gsc know that you are setting flag's teams so it won't take over.
	// Comment its definition to let _conquest.gsc take over and set default flags which is not recommended.
	level.flags[0] maps\_conquest::flag_set_team("allies");
	level.flags[2] maps\_conquest::flag_set_team("axis");
	level.wind_angles = (0,-120,0);
}























