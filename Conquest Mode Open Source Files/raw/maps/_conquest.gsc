/*/////////////////////////////////////////////////////////////
CALL OF DUTY 4: CONQUEST MODE FOR SINGLEPLAYER
BY SPi
Date started: February 27, 2021.
Date finished: March 27, 2021.
Total Work Time: 14+ Days.

=== Script Guide ===
0) INIT
1) FLAG SETUP 
2) TEAM LOGIC
3) BOT LOGIC
4) PLAYER LOGIC
5) MATCH LOGIC 
6) MUSIC
7) HUD TOOLS

/////////////////////////////////////////////////////////////*/

// ##################################################
// ############# 0) INIT ######################
// ##################################################

#include maps\_anim;
#include maps\_utility;
#include common_scripts\utility;
#include maps\_utility_code;

main() 
{
	// CONQUEST MODE INIT
	conquest_init();
	
	// Necessary for cod4.
	maps\_load::main(); 
	level.friendlyFireDisabled = 1;
	level.early_level[ level.script ] = false; // Prevents an annoying error.
	battlechatter_off("axis");
	battlechatter_off("allies");
	
	// MATCH SETTINGS
	Conquest_match_settings();
	
	// FLAG SYSTEM SETUP
	setup_flags();

	// TEAMS SYSTEM SETUP
	thread setup_teams();
	
	// BOT SYSTEM SETUP
	thread setup_bots();
	
	// PLAYER SYSTEM SETUP
	thread setup_player(); // GAMEPLAY START

	// MATCH SYSTEM SETUP
	thread setup_match(); // GAMEPLAY START

	// MUSIC SETUP
	thread conquest_music();
}


// CONQUEST MATCH SETTINGS

Conquest_match_settings()
{
	if( isdefined(level.custom_conquest_match_settings) )
		return;
	
	//iprintlnbold(&"DEFAULT_MATCH_SETTINGS");

	// Time
	//level.match_time = 900; // DEFAULT but its handled on MENU.
	level.match_time = GetDvarInt("cq_time");	
	// Points
	thread match_flag_settings(); // Doing this because flags need to wait for initialization so they can be set a team.
	// Bots
	//level.max_team_bots = 12; // DEFAULT but its handled on MENU. // max = 15
	level.max_team_bots = GetDvarInt("cq_maxteambots"); 
	level.max_bots = level.max_team_bots*2;
	// Teams	
	//level.max_team_points = 300; // DEFAULT but its handled on MENU.
	level.max_team_points = GetDvarInt("cq_teampoints");
	level.team1_points = level.max_team_points;
	level.team2_points = level.max_team_points;
	level.allies_color = (0,0.8,0); // Green
	level.axis_color = (1,0,0); // Red
	level.neutral_color = (0.85,0.85,0.85); // Greyish
	// Misc
	level.wind_angles = (0,90,0);
	//level.allies_color = (0,0.5,1); // Light Blue 
	//level.allies_color = (0,0,1); // Dark Blue
	//level.allies_color = (0,0.8,0); // Green
	//level.allies_color = (0,0.8,0.8); // Cyan
	//level.axis_color = (0.8,0.8,0); // Yellow
	//level.axis_color = (0.8,0,0.8); // Magenta
	//level.neutral_color = (1,1,1); // White

}

match_flag_settings()
{
	// Waiiting because flags need to wait for initialization so they can be set a team.
	// Also waitting more than 0.05 to let map script set its own flags and then this function
	// Will set flags or not.
	wait 0.1; 
	
	if( isdefined(level.custom_flag_teams))
		return;
	
	level.flags[0] maps\_conquest::flag_set_team("allies");
	level.flags[1] maps\_conquest::flag_set_team("axis");
}

conquest_init()
{	
	precachemenu("conquest_spawn_select8");
	precachemenu("conquest_spawn_select7");
	precachemenu("conquest_spawn_select6");
	precachemenu("conquest_spawn_select5");
	precachemenu("conquest_spawn_select4");
	precachemenu("conquest_spawn_select3");
	precachemenu("conquest_spawn_select2");
	precachemenu("conquest_spawn_select");
	precachemenu("conquest_team");
	precachemenu("conquest_class_allies");
	precachemenu("conquest_class_axis");
	precachemenu("conquest_gameover");
	
	precachemodel("flag_pole");
	precachemodel("viewhands_sas_woodland");
	precachemodel("viewhands_op_force");
	precachemodel("prop_flag_neutral");
	precachemodel("prop_flag_brit");
	precachemodel("prop_flag_russian");	
	precacheshader("faction_128_sas");
	precacheshader("faction_128_ussr");
	precacheshader("hudicon_neutral");
	
	precacheshader("compass_flag_neutral");
	precacheshader("compass_flag_british");
	precacheshader("compass_flag_russian");

	precacheshader("compass_waypoint_defend");
	precacheshader("compass_waypoint_defend_a");
	precacheshader("compass_waypoint_defend_b");
	precacheshader("compass_waypoint_defend_c");
	precacheshader("compass_waypoint_defend_d");
	precacheshader("compass_waypoint_defend_e");
	precacheshader("compass_waypoint_neutral");
	precacheshader("compass_waypoint_neutral_a");
	precacheshader("compass_waypoint_neutral_b");
	precacheshader("compass_waypoint_neutral_c");
	precacheshader("compass_waypoint_neutral_d");
	precacheshader("compass_waypoint_neutral_e");
	precacheshader("compass_waypoint_capture");
	precacheshader("compass_waypoint_capture_a");
	precacheshader("compass_waypoint_capture_b");
	precacheshader("compass_waypoint_capture_c");
	precacheshader("compass_waypoint_capture_d");
	precacheshader("compass_waypoint_capture_e");
	precacheshader("compass_waypoint_bomb");

	precacheshader("objective");
	precacheshader("damage_feedback");
	
	precacheshader("hud_med");
	precacheshader("hud_ammo");
	
//characters
precachemodel("head_sp_sas_woodland_todd");
precachemodel("body_sp_sas_woodland_assault_a");
precachemodel("body_sp_sas_woodland_support_a");
precachemodel("head_sp_usmc_force_nomex");
precachemodel("head_sp_sas_woodland_zied");
precachemodel("body_sp_sas_woodland_assault_b");
precachemodel("head_specops_sp");
precachemodel("body_sp_usmc_force_c");
precachemodel("head_sp_usmc_force_chad");
precachemodel("body_sp_usmc_force_b");
precachemodel("head_sp_spetsnaz_geoff_yuribody");
precachemodel("body_sp_spetsnaz_yuri");
precachemodel("head_sp_spetsnaz_vlad_vladbody");
precachemodel("body_sp_spetsnaz_vlad");
precachemodel("head_sp_spetsnaz_collins_vladbody");
precachemodel("body_sp_spetsnaz_vlad");
precachemodel("head_sp_spetsnaz_demetry_demetrybody");
precachemodel("body_sp_spetsnaz_demetry");
precachemodel("body_complete_sp_spetsnaz_boris");

//WeaponImages	
precacheshader("weapon_ak47");
precacheshader("weapon_rpd");
precacheshader("weapon_p90");
precacheshader("weapon_p90_suppressor");
precacheshader("weapon_m9beretta");
precacheshader("weapon_m9beretta_silencer");
precacheshader("weapon_dragunovsvd");
precacheshader("weapon_m4carbine_reflex");
precacheshader("weapon_m4carbine");
precacheshader("weapon_m249saw");
precacheshader("weapon_mp5");
precacheshader("weapon_mp5_suppressor");
precacheshader("weapon_usp_45");
precacheshader("weapon_usp_45_silencer");
precacheshader("weapon_m40a3");
precacheshader("weapon_c4");
precacheshader("weapon_fraggrenade");
precacheshader("weapon_flashbang");
precacheshader("weapon_smokegrenade");
precacheshader("weapon_claymore");
precacheshader("specialty_armorvest");

//CharacterImages	
precacheshader("char_ally_assault");
precacheshader("char_ally_support");
precacheshader("char_ally_medic");
precacheshader("char_ally_sniper");
precacheshader("char_ally_specops");
precacheshader("char_axis_assault");
precacheshader("char_axis_support");
precacheshader("char_axis_medic");
precacheshader("char_axis_sniper");
precacheshader("char_axis_specops");

//Weapons
precacheitem("ak47");
precacheitem("rpd");
precacheitem("dragunov");
precacheitem("p90");
precacheitem("p90_silencer");
precacheitem("beretta");
//precacheitem("beretta_silencer_mp");
precacheitem("m4_grunt");
precacheitem("m40a3");
precacheitem("saw");
precacheitem("usp");
precacheitem("usp_silencer");
precacheitem("mp5");
precacheitem("mp5_silencer");
precacheitem("c4");
precacheitem("claymore");
precacheitem("fraggrenade");
precacheitem("flash_grenade");
precacheitem("smoke_grenade_american");
//===

	
	level.cq_debug = false;
	level.max_flags = 8;
	level.bots_spawned = 0;
	level.ally_spawner = "";
	level.axis_spawner = "";
	
	level.top_down_org = getent("top_down_org","targetname");
	
	level.ally_team_icon = "faction_128_sas";
	level.axis_team_icon = "faction_128_ussr";
	level.ally_team_flagmodel = "prop_flag_brit";
	level.axis_team_flagmodel = "prop_flag_russian";
	level.no_team_flagmodel = "prop_flag_neutral";
	level.no_team_icon = "hudicon_neutral";
	level.no_team_icon = "hudicon_neutral";
	

	
	level.glowing_marker_YELLOW = loadfx( "misc/ui_pickup_available" );
	level.glowing_marker_RED 	= loadfx( "misc/ui_pickup_unavailable" );
}


// ##################################################
// ############# 1) FLAG SETUP ######################
// ##################################################

setup_flags()
{
	level.flag_poles = getentarray( "flag_pole" , "targetname" );
	for(i=0;i < level.flag_poles.size; i++)
		level.flag_poles[i].taken = false;
/*
	level.flags = [];  //stores all flags and shows how many flags there are.
	flag = getentarray( "flag" , "targetname" );
	for(i=0;i < flag.size; i++)
		flag[i] thread flag_think(i);
*/
	level.flags = [];
	flag = getentarray( "flag" , "targetname" );
	if(flag.size > level.max_flags)
	{
		// Flags amount more than max flags allowed, reducing by removing the last placed.
		for(i=0;i < level.max_flags; i++)
			flag[i] flag_think(i);
	}
	else
	{
		// Flags amount accepted.
		for(i=0;i < flag.size; i++)
			flag[i] flag_think(i);
	}
	thread team_flag_arrays();	
	
	level.objective_flags = 0;
	for( i = 0 ; i<level.flags.size; i++ )
	{
		j = i+1;
		level.objective_flags++;
		Objective_Add( j, "current", &"CONQUEST_NULL", level.flags[i].origin );
		Objective_AdditionalCurrent( j );
		Objective_Position( j, level.flags[i].origin );
		level.flags[i] thread flag_objectives_think(i,j);
	}
}

team_flag_arrays()
{
	level.flags_allies = [];
	level.flags_axis = [];
	level.flags_neutral = [];
	level.flags_neutral_and_allies = [];
	level.flags_neutral_and_axis = [];
	
	thread check_ally_flags_increased_reduced();
	thread check_axis_flags_increased_reduced();
	
	
	thread debug_team_flag_arrays();
	while(1)
	{
		level.flags_neutral_and_allies = thread array_combine( level.flags_allies, level.flags_neutral);
		level.flags_neutral_and_axis = thread array_combine( level.flags_axis, level.flags_neutral);
		wait 0.05;
	}
}

debug_team_flag_arrays()
{

	if(!level.cq_debug)
		return;
		
	neutral_flags = thread flag_debug_text(-230,&"NEUTRAL_FLAGS_","top");
	ally_flags = thread flag_debug_text(-215,&"ALLIES_FLAGS_","top");
	axis_flags = thread flag_debug_text(-200,&"AXIS_FLAGS_","top");
	while(1)
	{
		neutral_flags setvalue(level.flags_neutral.size);
		ally_flags setvalue(level.flags_allies.size);
		axis_flags setvalue(level.flags_axis.size);
		wait 0.05;
	}
}
	
flag_set_team(faction)
{
	self.owner = faction;
	if(faction == "allies")
	{
		self.captured_progress_allies = 100;
		self.flag moveto(self.up_pos,0.1);
	}
	else if(faction == "axis")
	{
		self.captured_progress_axis = 100;
		self.flag moveto(self.up_pos,0.1);
	}
	else if(faction == "neutral")
	{
		self.captured_progress_allies = 0;
		self.captured_progress_axis = 0;
		self.flag moveto(self.down_pos,0.1);
	}
}


get_pole()
{
	for(i=0;i < level.flag_poles.size; i++)
	{
		if(level.flag_poles[i].taken == false)
		{
			level.flag_poles[i].taken = true;
			return level.flag_poles[i];
		}
	}

}


flag_think(i)
{
	flag = spawnstruct();
	flag.origin = self.origin;
	flag.angles = self.angles;
	flag.id = i; // flag ids start from 0, flag,id = 0, flag1, flag2 ect
	flag.radius = self.radius;
	flag.trig = spawn( "trigger_radius", self.origin, 0, self.radius, self.height ); //Spawn( <classname>, <origin>, <flags>, <radius>, <height> )
	flag.pole = spawn( "script_model", self.origin+(0,0,2) );
	flag.pole setmodel("flag_pole");
	flag.pole.origin = self.origin+(0,0,2);
	flag.pole.angles = self.angles;
	flag.clip = get_pole();
	flag.clip moveto(self.origin,0.1);
	flag.clip rotateto(self.angles,0.1);
	flag.up_pos = self.origin+(0,0,160); 
	flag.down_pos = self.origin+(0,0,-52);
	flag.init_team = "neutral";
	flag.team = flag.init_team;
	flag.owner = flag.init_team;
	flag.selected = false;
	flag.capturable = true;
	flag.height_distance = 212;
	flag.capture_time = 10;
	flag.captured_progress_allies = 0;
	flag.captured_progress_axis = 0;
	flag.captured_progress_max = 100;
	flag.captured = true;
	flag.being_captured = false;
	flag.contested = false;
	flag.state = "captured";
	flag.capturing_team = "";
	flag.allies_guys_in = 0;
	flag.axis_guys_in = 0;
	flag.allies_inside = false;
	flag.axis_inside = false;
	flag.allies_capturing = false;
	flag.axis_capturing = false;
	flag.enemy_team_inside = false;
	flag.allow_spawn = true;
	
	if(isdefined(self.target))
	{
		flag.spawns = getentarray( self.target, "targetname" );
	}
	
	flag thread flag_team_owner_check();
	flag thread flag_team_points_check();
	flag thread flag_debug_stats();
	flag thread flag_wind_func();

	if(flag.capturable == true)
	{
		flag thread flag_checks();
		flag thread flag_capture_system();
		flag thread flag_hud();
	}
	level.flags[ level.flags.size ] = flag;	
}

flag_wind_func()
{
	wait 0.1; // for initialization
	self.flag.angles = level.wind_angles;
}


flag_team_owner_check()
{
	wait 0.1; // for definitions
	while(1)
	{
		if( self.owner == "allies" )
		{
			if( is_in_array(level.flags_axis,self) )
				level.flags_axis = array_remove( level.flags_axis, self );
			if( is_in_array(level.flags_neutral,self) )
				level.flags_neutral = array_remove( level.flags_neutral, self );	
				
			if( !(is_in_array(level.flags_allies,self)) )
			level.flags_allies[ level.flags_allies.size ] = self;

		}
		else if( self.owner == "axis" )
		{
			if( is_in_array(level.flags_allies,self) )
				level.flags_allies = array_remove( level.flags_allies, self );	
			if( is_in_array(level.flags_neutral,self) )
				level.flags_neutral = array_remove( level.flags_neutral, self );	
				
			if( !(is_in_array(level.flags_axis,self)) )
				level.flags_axis[ level.flags_axis.size ] = self;

		}
		else if( self.owner == "neutral" )
		{
			if( is_in_array(level.flags_allies,self) )
				level.flags_allies = array_remove( level.flags_allies, self );	
			if( is_in_array(level.flags_axis,self) )
				level.flags_axis = array_remove( level.flags_axis, self );
	
			if( !(is_in_array(level.flags_neutral,self)) )
				level.flags_neutral[ level.flags_neutral.size ] = self;
		}
		wait 0.05;
	}
}

flag_team_points_check()
{
	self.flag = spawn( "script_model", self.down_pos);
	while(1)
	{
		if( self.captured_progress_allies == 0 && self.captured_progress_axis == 0 )
		{
			self.team = "neutral";
			self.flag setmodel(level.no_team_flagmodel);	
		}
		else if( self.captured_progress_allies > 0 )
		{
			self.team = "allies";
			self.flag setmodel(level.ally_team_flagmodel);
		}
		else if( self.captured_progress_axis > 0 )
		{
			self.team = "axis";
			self.flag setmodel(level.axis_team_flagmodel);
		}
		wait 0.05;
	}
}

// FLAG CHECKS
// ==========================================================

flag_checks()
{
	wait 0.05;
	self thread flag_check_allies_in();
	self thread flag_check_axis_in();
	self thread flag_check_contested();
	self thread flag_check_enemy_inside();
	self thread flag_check_allow_spawn();
	while(1)
	{
		player_touching = self thread flag_check_player_touching();
		ally_npcs_touching = self thread flag_check_npcs_touching( level.ally_bots );
		axis_npcs_touching = self thread flag_check_npcs_touching( level.axis_bots );
		//axis_npcs_touching = self thread flag_check_npcs_touching( "axis" );
		if(isdefined(level.player.cq_team))
		{
			if(level.player.cq_team == "allies")
			{
				self.allies_guys_in = ally_npcs_touching + player_touching;
				self.axis_guys_in = axis_npcs_touching; 
			}
			else if(level.player.cq_team == "axis")
			{
				self.allies_guys_in = ally_npcs_touching;
				self.axis_guys_in = axis_npcs_touching + player_touching; 
			}
			else
			{
				self.allies_guys_in = ally_npcs_touching;
				self.axis_guys_in = axis_npcs_touching; 
			}
		}
		else
		{
			self.allies_guys_in = ally_npcs_touching;
			self.axis_guys_in = axis_npcs_touching; 
		}
		wait 0.05;
	}	
}

flag_check_player_touching()
{
	if( level.player istouching(self.trig) && level.player.cq_alive == true )
	{
		return 1;
	}
	else
		return 0;
}

flag_check_npcs_touching( array )
{
	touchers = 0;
	//team = getaiarray( faction );
	for( i = 0 ; i<array.size; i++ )
	{
		if( array[i] istouching(self.trig) )
		{
			touchers++;
		}
	}
	return touchers;

}

flag_check_allies_in()
{
	while(1)
	{
		if( self.allies_guys_in > 0)
			self.allies_inside = true;
		else
			self.allies_inside = false;
		wait 0.05;
	}
}

flag_check_axis_in()
{
	while(1)
	{
		if( self.axis_guys_in > 0)
			self.axis_inside = true;
		else
			self.axis_inside = false;
		wait 0.05;
	}
}

flag_check_contested()
{
	while(1)
	{
		if( self.allies_inside == true && self.axis_inside == true )
			self.contested = true;
		else
			self.contested = false;
		wait 0.05;
	}
}

flag_check_enemy_inside()
{
	while(1)
	{
		if( (self.owner == "allies" && self.axis_inside == true) || (self.owner == "axis" && self.allies_inside == true) )
			self.enemy_team_inside = true;
		else
			self.enemy_team_inside = false;
		wait 0.05;
	}
}

flag_check_allow_spawn()
{
	while(1)
	{
		if( self.owner == "allies" )
		{
			if( level.flags_allies.size > 1 && self.enemy_team_inside == true )
				self.allow_spawn = false;
			else if( level.flags_allies.size > 1 && self.enemy_team_inside == false )
				self.allow_spawn = true;
			else if( level.flags_allies.size == 1 && self.enemy_team_inside == true )
				self.allow_spawn = true;	
			else if( level.flags_allies.size == 1 && self.enemy_team_inside == false )
				self.allow_spawn = true;	
			else if( level.flags_allies.size < 1 )
				self.allow_spawn = false;	
			else
				self.allow_spawn = false;	
		}
		else if( self.owner == "axis" )
		{
			if( level.flags_axis.size > 1 && self.enemy_team_inside == true )
				self.allow_spawn = false;
			else if( level.flags_axis.size > 1 && self.enemy_team_inside == false )
				self.allow_spawn = true;
			else if( level.flags_axis.size == 1 && self.enemy_team_inside == true )
				self.allow_spawn = true;	
			else if( level.flags_axis.size == 1 && self.enemy_team_inside == false )
				self.allow_spawn = true;	
			else if( level.flags_axis.size < 1 )
				self.allow_spawn = false;	
			else
				self.allow_spawn = false;	
		}
		wait 0.05;
	}
}



check_ally_flags_increased_reduced()
{
	while(1)
	{
		previous_size = level.flags_allies.size;
		level.ally_flags_increased = false;
		level.ally_flags_reduced = false;
		while(1)
		{
			if(previous_size < level.flags_allies.size )
			{
				level.ally_flags_increased = true;
				break;
			}
			else if	(previous_size > level.flags_allies.size )
			{
				level.ally_flags_reduced = true;
				break;
			}
			wait 0.05;
		}
		wait 0.1;
	}
}

check_axis_flags_increased_reduced()
{
	while(1)
	{
		previous_size = level.flags_axis.size;
		level.axis_flags_increased = false;
		level.axis_flags_reduced = false;
		while(1)
		{
			if(previous_size < level.flags_axis.size )
			{
				level.axis_flags_increased = true;
				break;
			}
			else if	(previous_size > level.flags_axis.size )
			{
				level.axis_flags_reduced = true;
				break;
			}
			wait 0.05;
		}
		wait 0.1;
	}
}


// FLAG CAPTURE SYSTEM
// ==========================================================

flag_capture_system()
{
	while(1)
	{	
		while(1)
		{
			if( self.owner == "neutral"  ) 
			{
				if( self.allies_inside == true && self.axis_inside == false)
				{
					self.capturing_team = "allies";
					self thread flag_neutral_to_allies();  
					break;
				}
				else if( self.axis_inside == true && self.allies_inside == false)
				{
					self.capturing_team = "axis";
					self thread flag_neutral_to_axis();  
					break;
				}
			}
			else if( self.owner == "axis" ) 
			{
				if( self.allies_inside == true && self.axis_inside == false && self.being_captured == false )
				{
					self.being_captured = true;
					self thread flag_axis_to_neutral(); 
					break;
				}
				else
				{
					self.being_captured = false;
				}
			}
			else if(self.owner == "allies" ) 
			{
				if( self.axis_inside == true && self.allies_inside == false && self.being_captured == false  )
				{
					self.being_captured = true;
					self thread flag_allies_to_neutral(); 	
					break;
				}
				else
				{
					self.being_captured = false;
				}
			}
			wait 0.05;
		}
		self waittill("flag_capture_changed_state");
		wait 0.1;		
	}
}

// NEUTRAL TO TEAM ==============================

flag_neutral_to_allies()
{
	self endon("flag_capture_changed_state");
	while(1)
	{
		while( 1 )
		{
			if( self.allies_inside == true && self.axis_inside == true )
			{
				self.state = "contested";
			}
			else if( self.allies_inside == false && self.captured_progress_allies > 0)
			{
				self.state = "capturing";
				self.captured_progress_allies = self.captured_progress_allies-1;
				self.flag movez(-2.12, 0.1); 
				wait 0.1;
				break;
			}
			else if( self.allies_inside == true )
			{		
				self.state = "capturing";
				self.captured_progress_allies = self.captured_progress_allies+1;
				self.flag movez(2.12, 0.1); 
				wait 0.1;
				break;
			}
			wait 0.1;
		}
		if( self.captured_progress_allies == self.captured_progress_max )
		{
			self.state = "captured";
			self.owner = "allies";
			level notify("allies_captured_flag");
			break;
		}
		else if( self.captured_progress_allies == 0 )
		{
			self.state = "captured";
			self.owner = "neutral";
			break;
		}
		wait 0.05;
	}
	if( level.player istouching(self.trig) && level.player.cq_team == "allies" )
	{
		level.player.conquest_captures++;
	}
	wait 0.1;
	self notify("flag_capture_changed_state");
}

flag_neutral_to_axis()
{
	self endon("flag_capture_changed_state");
	while(1)
	{
		while( 1 )
		{
			if( self.axis_inside == true && self.allies_inside == true )
			{
				self.state = "contested";
			}
			else if( self.axis_inside == false && self.captured_progress_axis > 0)
			{
				self.state = "capturing";
				self.captured_progress_axis = self.captured_progress_axis-1;
				self.flag movez(-2.12, 0.1); 
				wait 0.1;
				break;
			}
			else if( self.axis_inside == true )
			{		
				self.state = "capturing";
				self.captured_progress_axis = self.captured_progress_axis+1;
				self.flag movez(2.12, 0.1); 
				wait 0.1;
				break;
			}
			wait 0.1;
		}
		if( self.captured_progress_axis == self.captured_progress_max )
		{
			self.state = "captured";
			self.owner = "axis";
			level notify("axis_captured_flag");
			break;
		}
		else if( self.captured_progress_axis == 0 )
		{
			self.state = "captured";
			self.owner = "neutral";
			break;
		}
		wait 0.05;
	}
	if( level.player istouching(self.trig) && level.player.cq_team == "axis" )
	{
		level.player.conquest_captures++;
	}
	wait 0.1;
	self notify("flag_capture_changed_state");
}

// TEAM TO NEUTRAL ==============================

flag_axis_to_neutral()
{
	self endon("flag_capture_changed_state");
	while(1)
	{
		wait 0.05;
		while( 1 )
		{
			if(self.allies_inside == true && self.axis_inside == true)
			{
				if(level.flags_axis.size < 2 )
				{
					self.state = "neutralize";
					self.captured_progress_axis = self.captured_progress_axis - 1;
					self.flag movez(-2.12, 0.1);
					wait 0.2;			
					break;
				}
				else
					self.state = "contested";
			}
			else if(self.allies_inside == true && self.axis_inside == false)
			{
				self.state = "neutralize";
				self.captured_progress_axis = self.captured_progress_axis - 1;
				self.flag movez(-2.12, 0.1);
				wait 0.1;			
				break;
			}
			else if(self.allies_inside == false && self.axis_inside == true)
			{
				self.state = "capturing";
				self.captured_progress_axis = self.captured_progress_axis + 1;
				self.flag movez(2.12, 0.1);
				wait 0.1;			
				break;
			}
			else if(self.allies_inside == false && self.axis_inside == false )
			{
				self.captured_progress_axis = self.captured_progress_axis + 1;
				self.flag movez(2.12, 0.1);
				wait 0.1;			
				break;
			}
			wait 0.1;			
		}
		if( self.captured_progress_axis == 0 )
		{
			self.owner = "neutral";
			level notify("axis_lost_flag");
			break;
		}
		else if( self.captured_progress_axis == self.captured_progress_max )
		{
			self.state = "captured";
			break;
		}
	}
	wait 0.1;
	self notify("flag_capture_changed_state");
}

flag_allies_to_neutral()
{
	self endon("flag_capture_changed_state");
	while(1)
	{
		while( 1 )
		{
			if(self.axis_inside == true && self.allies_inside == true)
			{
				if(level.flags_allies.size < 2)
				{
					self.state = "neutralize";
					self.captured_progress_allies = self.captured_progress_allies - 1;
					self.flag movez(-2.12, 0.1);
					wait 0.1;			
					break;
				}
				else
					self.state = "contested";
			}
			else if(self.axis_inside == true && self.allies_inside == false)
			{
				self.state = "neutralize";
				self.captured_progress_allies = self.captured_progress_allies - 1;
				self.flag movez(-2.12, 0.1);
				wait 0.1;			
				break;
			}
			else if(self.axis_inside == false && self.allies_inside == true)
			{
				self.state = "capturing";
				self.captured_progress_allies = self.captured_progress_allies + 1;
				self.flag movez(2.12, 0.1);
				wait 0.1;			
				break;
			}
			else if(self.axis_inside == false && self.allies_inside == false )
			{
				self.captured_progress_allies = self.captured_progress_allies + 1;
				self.flag movez(2.12, 0.1);
				wait 0.1;			
				break;
			}
			wait 0.1;			
		}
		if( self.captured_progress_allies == 0 )
		{
			self.owner = "neutral";
			level notify("allies_lost_flag");
			break;
		}
		else if( self.captured_progress_allies == self.captured_progress_max )
		{
			self.state = "captured";
			break;
		}
		wait 0.05;
	}
	wait 0.1;
	self notify("flag_capture_changed_state");
}


// FLAG OBJECTIVE ICONS
// ==========================================================

flag_objectives_think( flag_id , obj_num )
{
	local_1 = 0;
	while(1)
	{
		if( self.state == "captured" )
		{
			self thread flag_blink_change_icon( flag_id , obj_num );
			local_1 = 0;
			self notify("stop_blink" + flag_id);
			if( self.selected == true )
				Objective_Icon( obj_num, "objective" );
		}
		else
		{	
			if( local_1 == 0 )
			{
				self thread flag_map_icon_blink( flag_id , obj_num );
				local_1 = 1;
			}
		}
		wait 0.05;		
	}
}

flag_map_icon_blink( flag_id , obj_id )
{
	self endon("stop_blink"+flag_id);
	while(1)
	{
		wait 0.5;
		self thread flag_blink_change_icon( flag_id, obj_id, 1 );
		wait 0.5;
		self thread flag_blink_change_icon( flag_id, obj_id );
	}
}

flag_blink_change_icon( flag_id, obj_id, blink )
{
	flag_icon = "compass_waypoint_captureneutral";
	blink_icon = "compass_waypoint_captureneutral";
	if(self.owner == "allies")
	{
		flag_icon = "compass_waypoint_defend";
		blink_icon = "compass_waypoint_captureneutral";
	}
	else if(self.owner == "axis")
	{
		flag_icon = "compass_waypoint_capture";
		blink_icon = "compass_waypoint_captureneutral";
	}		
	else if(self.owner == "neutral")
	{
		if(self.capturing_team == "allies")
		{
			flag_icon = "compass_waypoint_captureneutral";
			blink_icon = "compass_waypoint_defend";
		}
		else if(self.capturing_team == "axis")
		{
			flag_icon = "compass_waypoint_captureneutral";
			blink_icon = "compass_waypoint_capture";
		}
	}	
	if(isdefined(blink))
	Objective_Icon( obj_id, blink_icon + flag_map_icons_think(flag_id) );
	else
	Objective_Icon( obj_id, flag_icon + flag_map_icons_think(flag_id) );
}

flag_map_icons_think(i)
{
	if(i==0)
		return "_a";
	else if(i==1)
		return "_b";
	else if(i==2)
		return "_c";
	else if(i==3)
		return "_d";
	else if(i==4)
		return "_e";
	else
		return "";
}


// FLAG HUD
// ==========================================================

flag_hud()
{
	level endon("destroy_all_flag_hud");
	while(1)
	{
		while(!(level.player istouching(self.trig)))
			wait 0.05;
		
		self thread flag_hud_text();
		
		while( level.player istouching(self.trig) )
			wait 0.05;
		
		self notify("destroy_flag_hud");
		wait 0.05;
	}
}

flag_hud_text()
{
	self notify("destroy_flag_hud");
	self endon("destroy_flag_hud");
	level endon("destroy_all_flag_hud");

	flag_text_top = newHudElem();
	flag_text_top.alignX = "center";
	flag_text_top.alignY = "middle";
	flag_text_top.horzAlign = "center";
	flag_text_top.vertAlign = "middle";
	flag_text_top.x = 0;
	flag_text_top.y = -188; 
	flag_text_top.font = "objective"; 
	flag_text_top.fontScale = 2; 
	flag_text_top.hidewheninmenu = true;
	flag_text_top.label = &"CONQUEST_FLAG_TITLE"; 
	
	flag_text_down = newHudElem();
	flag_text_down.alignX = "center";
	flag_text_down.alignY = "middle";
	flag_text_down.horzAlign = "center";
	flag_text_down.vertAlign = "middle";
	flag_text_down.x = 0;
	flag_text_down.y = -155; 
	flag_text_down.hidewheninmenu = true;
	flag_text_down.font = "objective"; 
	flag_text_down.fontScale = 1.5; 
	
	self thread flag_capture_bar();
	
	self thread flag_text_down_states(flag_text_down);
	self thread destroy_flag_hud(flag_text_top);
	self thread destroy_flag_hud(flag_text_down);
	
	//flag_text_top setvalue(level.survspi_wave);
	
	
}
flag_text_down_states(flag_text_down)
{	
	level endon("destroy_all_flag_hud");
	self endon("destroy_flag_hud");
	while(1)
	{
		if(self.state == "neutralize")
			flag_text_down.label = &"CONQUEST_FLAG_NEU"; 
		else if(self.state == "capturing")
			flag_text_down.label = &"CONQUEST_FLAG_CAP"; 
		else if(self.state == "contested")
			flag_text_down.label = &"CONQUEST_FLAG_CON"; 
		else if(self.state == "captured")
			flag_text_down.label = &"CONQUEST_FLAG_CAPD"; 
		else
			flag_text_down.label = &"CONQUEST_NULL"; 
		wait 0.05;
	}
}

destroy_flag_hud(hudelem)
{
	self add_wait( ::waittill_msg, "destroy_flag_hud" );
	level add_wait( ::waittill_msg, "destroy_all_flag_hud" );
	do_wait_any();
	
	hudelem destroy();
}

// FLAG BAR
// ==========================================================

flag_capture_bar()
{	
	self endon("destroy_flag_hud");
	self.capturebar = hud_bar_local( "white", "black", 128, 12 );
	self.capturebar maps\_hud_util::setPoint( "CENTER", undefined, 0, -170 );
	self thread destroy_capbar_hud();
	self thread flag_bar_progress();
	self thread flag_bar_color();
}

flag_bar_progress()
{
	self endon("destroy_flag_hud");
	level endon("destroy_all_flag_hud");
    while(1)
    {
		if(self.state == "neutralize")
		{
			if(self.owner == "allies")
			self.capturebar thread maps\_hud_util::updateBar( self.captured_progress_allies / self.captured_progress_max );
			else if(self.owner == "axis")
			self.capturebar thread maps\_hud_util::updateBar( self.captured_progress_axis / self.captured_progress_max );	
		}
		else if( self.state == "capturing" || self.state == "contested" )
		{
			if(self.capturing_team == "allies")
			self.capturebar thread maps\_hud_util::updateBar( self.captured_progress_allies / self.captured_progress_max );
			else if(self.capturing_team == "axis")
			self.capturebar thread maps\_hud_util::updateBar( self.captured_progress_axis / self.captured_progress_max );
		}
		else 
			self.capturebar thread maps\_hud_util::updateBar( 1 ); 
		wait 0.05;
    }
}

flag_bar_color()
{	
	self endon("destroy_flag_hud");
	level endon("destroy_all_flag_hud");
	while(1)
    {
		if(self.state == "neutralize" || self.state == "captured")
		{
			if(self.owner == "allies" )
				self.capturebar.bar.color = level.allies_color;
			else if(self.owner == "axis" )
				self.capturebar.bar.color = level.axis_color;
			else if(self.owner == "neutral" )
				self.capturebar.bar.color = level.neutral_color;
		}
		else if(self.state == "capturing")
		{
			if(self.capturing_team == "allies" )
				self.capturebar.bar.color = level.allies_color;
			else if(self.capturing_team == "axis" )
				self.capturebar.bar.color = level.axis_color;
		}
		else if(self.state == "contested")
		{
			self thread flag_bar_red_blink();
			while(1)
			{	
				if(!(self.state == "contested"))
					break;
				wait 0.05;
			}
			self notify("stop_bar_blink");
			self.capturebar.bar.alpha = 1;
		}
		wait 0.05;
    }
}

flag_bar_red_blink(bar)
{
	self endon("destroy_flag_hud");
	self endon("stop_bar_blink");
	level endon("destroy_all_flag_hud");
	while(1)
	{
		self.capturebar.bar.color = level.axis_color;
		wait 0.2;
		self.capturebar.bar.color = level.allies_color;
		wait 0.2;
	}
}

destroy_capbar_hud()
{
	self add_wait( ::waittill_msg, "destroy_flag_hud" );
	level add_wait( ::waittill_msg, "destroy_all_flag_hud" );
	do_wait_any();
	
	self.capturebar.bar destroy();
	self.capturebar destroy();
}

// FLAG DEBUG
// ==========================================================

flag_debug_stats()
{
	if(	!level.cq_debug )
		return;
	
	while(1)
	{
		if( level.player istouching(self.trig) )
		{

			ally_points = thread flag_debug_text(-180,&"ALLIES_POINTS_");
			axis_points = thread flag_debug_text(-160,&"AXIS_POINTS_");
			ally_in = thread flag_debug_text(-140,&"ALLIES_IN_");
			axis_in = thread flag_debug_text(-120,&"AXIS_IN_");
			flag_state = thread flag_debug_text(-100,&"STATE");
			flag_capture_team = thread flag_debug_text(-80,&"CAPTEAM");
			while(1)
			{

				if( !(level.player istouching(self.trig) ) )
				{
					level notify("flag_debug_destroy");
					break;
				}
				else
				{
					ally_points setvalue(self.captured_progress_allies);
					axis_points setvalue(self.captured_progress_axis);
					ally_in setvalue(self.allies_guys_in);
					axis_in setvalue(self.axis_guys_in);
					flag_state.label = self.state;
					flag_capture_team.label = self.capturing_team;
				}
				wait 0.05;
			}
		}
		wait 0.05;
	}
}

flag_debug_text(y,text,notz)
{
	flag_debug = newHudElem();
	flag_debug.alignX = "left";
	flag_debug.alignY = "middle";
	flag_debug.horzAlign = "left";
	flag_debug.vertAlign = "middle";
	flag_debug.x = 0;
	flag_debug.y = y; 
	flag_debug.font = "default"; 
	flag_debug.fontScale = 1.5; 
	flag_debug.label = text;

	if(!(isdefined(notz)))
	flag_debug thread destroy_debug();
	return flag_debug;
}

destroy_debug()
{
	level waittill("flag_debug_destroy");
	self destroy();
}

// ##################################################
// ############# 2) TEAM LOGIC #########################
// ##################################################

setup_teams()
{
	if(level.team1_points > 1000 )
	level.team1_points = 1000;
	if(level.team2_points > 1000 )
	level.team2_points = 1000;
	
	level.team_allies = spawnstruct();
	level.team_allies.points = level.team1_points;
	level.team_allies.points_max = level.team1_points;
	level.team_allies.bots_spawned = 0;
	level.team_allies thread calculate_spawn_delay_allies();
	
	level.team_axis = spawnstruct();
	level.team_axis.points = level.team2_points;
	level.team_axis.points_max = level.team2_points;
	level.team_axis.bots_spawned = 0;
	level.team_axis thread calculate_spawn_delay_axis();
	
	wait 0.1; // for definitions
	thread teams_hud();
	//thread flag_bars_test();
	
	while(1)
	{
		if( level.team_allies.points < 0 )
			level.team_allies.points = 0;
		if( level.team_axis.points < 0 )
			level.team_axis.points = 0;	
		wait 0.05;	
	}	
}
//Parameters keep not working...
calculate_spawn_delay_allies()
{
	level.team_allies_spawn_delay = 0.2;
	while(1)
	{
		if(self.bots_spawned == level.max_team_bots)
			break;
		wait 0.05;
	}

	while(1)
	{
		if(level.flags_allies.size>0)
		{
			if(level.flags_allies.size == 1)
				level.team_allies_spawn_delay = 1;
			else
				level.team_allies_spawn_delay = (level.flags_allies.size/level.flags.size)*2;
		}
		else
			level.team_allies_spawn_delay = 1;
		
		temp_flag_size = level.flags_allies.size;
		while( temp_flag_size == level.flags_allies.size )
			wait 0.05;
		wait 0.05;	
	}
}

calculate_spawn_delay_axis()
{
	level.team_axis_spawn_delay = 0.2;
	while(1)
	{
		if(self.bots_spawned == level.max_team_bots)
			break;
		wait 0.05;
	}
	while(1)
	{
		if(level.flags_axis.size>0)
		{
			if(level.flags_axis.size == 1)
				level.team_axis_spawn_delay = 1;
			else
				level.team_axis_spawn_delay = (level.flags_axis.size/level.flags.size)*2;
		}
		else
			level.team_axis_spawn_delay = 1;
		
		temp_flag_size = level.flags_axis.size;
		while( temp_flag_size == level.flags_axis.size )
			wait 0.05;
		wait 0.05;
	}
}

// TEAMS HUD
// ==========================================================

teams_hud()
{
	level endon("destroy_team_hud");
	icon_size = 20;
	top_bar_height_pos = -225;
	
	// SUPER TOP BAR
	team_superbg = newHudElem();
	team_superbg.alignX = "center";
	team_superbg.alignY = "top";
	team_superbg.horzAlign = "center";
	team_superbg.vertAlign = "top";
	team_superbg.x = 0;
	team_superbg.y = 0; 
	team_superbg.width = icon_size;
	team_superbg.height = icon_size;
	team_superbg.sort = -4;
	team_superbg.hidewheninmenu = true;
	team_superbg.alpha = 0.5;
	team_superbg.color = (0,0,0);
	team_superbg setShader( "black", 500, 29 );
	
	// ALLIES ICON
	team1_icon = newHudElem();
	team1_icon.alignX = "center";
	team1_icon.alignY = "middle";
	team1_icon.horzAlign = "center";
	team1_icon.vertAlign = "middle";
	team1_icon.x = -35;
	team1_icon.y = top_bar_height_pos; 
	team1_icon.width = icon_size;
	team1_icon.height = icon_size;
	team1_icon.sort = -1;
	//team1_icon.foreground = 1;
	team1_icon.hidewheninmenu = true;
	team1_icon.alpha = 1;
	team1_icon setShader( level.ally_team_icon, icon_size, icon_size );
	//team1_icon setShader( "default", icon_size, icon_size );
	// AXIS ICON
	team2_icon = newHudElem();
	team2_icon.alignX = "center";
	team2_icon.alignY = "middle";
	team2_icon.horzAlign = "center";
	team2_icon.vertAlign = "middle";
	team2_icon.x = 35;
	team2_icon.y = top_bar_height_pos; 
	team2_icon.width = icon_size;
	team2_icon.height = icon_size;
	team2_icon.sort = -1;
	//team2_icon.foreground = 1;
	team2_icon.hidewheninmenu = true;
	team2_icon.alpha = 1;
	team2_icon setShader( level.axis_team_icon, icon_size, icon_size );
	
	// ALLIES POINTS
	team1_points_text = newHudElem();
	team1_points_text.alignX = "center";
	team1_points_text.alignY = "middle";
	team1_points_text.horzAlign = "center";
	team1_points_text.vertAlign = "middle";
	team1_points_text.x = -67;
	team1_points_text.y = top_bar_height_pos; 
	team1_points_text.color = level.allies_color;
	team1_points_text.font = "objective"; 
	team1_points_text.sort = -1;
//	team1_points_text.foreground = 1;
	team1_points_text.hidewheninmenu = true;
	team1_points_text.fontScale = 1.5; 
	// AXIS POINTS
	team2_points_text = newHudElem();
	team2_points_text.alignX = "center";
	team2_points_text.alignY = "middle";
	team2_points_text.horzAlign = "center";
	team2_points_text.vertAlign = "middle";
	team2_points_text.x = 67;
	team2_points_text.y = top_bar_height_pos; 
	team2_points_text.color = level.axis_color;
	team2_points_text.font = "objective"; 
	team2_points_text.sort = -1;
	//team2_points_text.foreground = 1;
	team2_points_text.hidewheninmenu = true;
	team2_points_text.fontScale = 1.5; 

	// MATCH TIMER
	match_time = newHudElem();
	match_time.alignX = "center";
	match_time.alignY = "middle";
	match_time.horzAlign = "center";
	match_time.vertAlign = "middle";
	match_time.x = 0;
	match_time.y = top_bar_height_pos; 
	match_time.color = level.neutral_color;
	match_time.font = "objective"; 
	match_time.sort = -1;
	//match_time.foreground = 1;
	match_time.hidewheninmenu = true;
	match_time.fontScale = 1.5; 
	
	match_time thread match_time_think();

	match_time thread destroy_team_hud();

	team_superbg thread destroy_team_hud();
	team1_icon thread destroy_team_hud();
	team2_icon thread destroy_team_hud();
	team1_points_text thread destroy_team_hud();
	team2_points_text thread destroy_team_hud();
	
	team1_points_text thread text_flash_when_changed(1);
	team2_points_text thread text_flash_when_changed(2);
	
	thread team_points_bar(1,top_bar_height_pos);
	thread team_points_bar(2,top_bar_height_pos);
	
	wait 0.1;
	for( i = 0 ; i<level.flags.size; i++ )
		thread captured_flag_bar_item(i);
	//thread flag_bars_test_DYNAMIC_TEST();

	thread captured_flag_bar_bg();
	
	while(1)
	{
		team1_points_text setvalue(level.team_allies.points);
		team2_points_text setvalue(level.team_axis.points);
		wait 0.05;
	}
}

match_time_think()
{
	self.label = &"CONQUEST_ZEROTIME";
	level waittill("player_selected_team");
	if( level.match_time > -1)
	{
		self.label = &"CONQUEST_NULL";
		self SetTimer( level.match_time );
	}
	else
	{
		self.label = &"CONQUEST_ZEROTIME";
	}
}

text_flash_when_changed(num)
{
	level endon("destroy_team_hud");
	self.start_color = self.color;
	while(1)
	{
		if(num == 1)
		{
			prev_pts = level.team_allies.points;
			while(1)
			{
				if(!(prev_pts == level.team_allies.points))
					break;
				wait 0.05;
			}
			prev_pts = level.team_allies.points;
		}
		else
		{
			prev_pts = level.team_axis.points;
			while(1)
			{
				if(!(prev_pts == level.team_axis.points))
					break;
				wait 0.05;
			}
			prev_pts = level.team_axis.points;
		}
		self.color = (1,1,1);
		wait 0.2;
		self.color = self.start_color;
	}

}

// This was used when the player team was displayed on the top middle.
// But time took it's place now.
team_icon_set(icon_size)
{
	level endon("destroy_team_hud");
	wait 0.1;
	while(1)
	{
		if(level.player.cq_team == "allies")
			self setShader( level.ally_team_icon, icon_size, icon_size );
		else if(level.player.cq_team == "axis")
			self setShader( level.axis_team_icon, icon_size, icon_size );
		else
			self setShader( level.no_team_icon, icon_size, icon_size );
		wait 0.05;
	}
}

// TEAMS BARS
// ==========================================================
team_points_bar(team,top_bar_height_pos)
{
	level endon("destroy_team_hud");
	bar_positions = 170;
	if(team == 1)
	{
		level.team_allies.teambar = hud_bar_local( "white", "black", 150, 12 );
		level.team_allies.teambar maps\_hud_util::setPoint( "CENTER", undefined, -1*bar_positions, top_bar_height_pos  );
		level.team_allies.teambar.bar.alignX = "right";
		level.team_allies.teambar.bar.x = int((-1*bar_positions/2)-11); //-91.5 may be tricky at different sizes..
		level.team_allies.teambar.bar.color = level.allies_color;
		level.team_allies.teambar thread destroy_team_hud();
		level.team_allies.teambar.bar thread destroy_team_hud();	
	}
	else
	{	
		level.team_axis.teambar = hud_bar_local( "white", "black", 150, 12 );
		level.team_axis.teambar maps\_hud_util::setPoint( "CENTER", undefined, bar_positions, top_bar_height_pos  );
		level.team_axis.teambar.bar.color = level.axis_color;
		//iprintlnbold(level.team_axis.teambar.bar.x);
		level.team_axis.teambar thread destroy_team_hud();
		level.team_axis.teambar.bar thread destroy_team_hud();
	}
	while(1)
	{
		if(team == 1)
		{
			amount1 = level.team_allies.points / level.team_allies.points_max;
			level.team_allies.teambar thread maps\_hud_util::updateBar( amount1 );
			if(amount1 == 0)
				level.team_allies.teambar.bar.alpha = 0;
		}
		else
		{
			amount2 = level.team_axis.points / level.team_axis.points_max;
			level.team_axis.teambar thread maps\_hud_util::updateBar( amount2 );
			if(amount2 == 0)
				level.team_axis.teambar.bar.alpha = 0;
		}
		wait 0.05;
	}
}


// CAPTURED FLAG BARS
// ==========================================================

// Bar Local
captured_flag_bar_item(id)
{
	level endon("destroy_team_hud");

	if(level.flags.size == 0)
		return;
		
	number_offset = 0;
	level.flagbarY = -205;
	
	if
	(
		level.flags.size == 2 ||
		level.flags.size == 4 ||
		level.flags.size == 6 ||
		level.flags.size == 8 ||
		level.flags.size == 10 ||
		level.flags.size == 12 
	)
	{
		number_offset = -11;
	}
	
	flagbar = newHudElem();
	flagbar.alignX = "center";
	flagbar.alignY = "middle";
	flagbar.horzAlign = "center";
	flagbar.vertAlign = "middle";
	flagbar.x = 0; 
	flagbar.y = level.flagbarY; 
	flagbar.width = 12;
	flagbar.height = 8;
	flagbar.sort = -1;
	//flagbar.foreground = 1;
	flagbar.hidewheninmenu = true;
	flagbar.alpha = 1;
	flagbar setShader( "white", 16, 8 );

	if(id == 0)
		flagbar.x = 0; 
	else if(id == 1)
		flagbar.x = 20;
	else if(id == 2)
		flagbar.x = -20;		
	else if(id == 3)
		flagbar.x = 40;
	else if(id == 4)
		flagbar.x = -40;
	else if(id == 5)
		flagbar.x = 60;
	else if(id == 6)
		flagbar.x = -60;		
	else if(id == 7)
		flagbar.x = 80;
	else if(id == 8)
		flagbar.x = -80;
	else if(id == 9)
		flagbar.x = 100;
	else if(id == 10)
		flagbar.x = -100;		
	else if(id == 11)
		flagbar.x = 120;
	else if(id == 12)
		flagbar.x = -120;
	
	flagbar.x = flagbar.x+number_offset+1; // the last one fixes a small misalignment. Although not perfect, its good. 
	flagbar thread destroy_team_hud();
	
	while(1)
	{
		if(level.flags[id].owner == "allies")
		{
			flagbar.color = level.allies_color;
			if(level.flags[id].state == "captured")
			{
				flagbar.alpha = 1;
				flagbar.color = level.allies_color;
			}
			else
			{
				wait 0.5;
				//flagbar.alpha = 0.5;
				flagbar.color = level.axis_color;
				wait 0.5;
				flagbar.alpha = 1;
				flagbar.color = level.allies_color;
			}
		}
		else if(level.flags[id].owner == "axis")
		{
			flagbar.color = level.axis_color;
			if(level.flags[id].state == "captured")
			{
				flagbar.alpha = 1;
				flagbar.color = level.axis_color;
			}
			else
			{
				wait 0.5;
				//flagbar.alpha = 0.5;
				flagbar.color = level.allies_color;
				wait 0.5;
				flagbar.alpha = 1;
				flagbar.color = level.axis_color;
			}		
		}
		else
		{
			flagbar.color = level.neutral_color;
			if(level.flags[id].state == "captured")
			{
				flagbar.alpha = 1;
				flagbar.color = level.neutral_color;
			}
			else
			{
				wait 0.5;
				//flagbar.alpha = 0.5;
				if( level.flags[id].capturing_team == "allies" )
					flagbar.color = level.allies_color;
				else if( level.flags[id].capturing_team == "axis" )
					flagbar.color = level.axis_color;				
				wait 0.5;
				flagbar.alpha = 1;
				flagbar.color = level.neutral_color;
			}
		}
		wait 0.05;
	}
}

captured_flag_bar_bg()
{
	if(level.flags.size == 0)
		return;
	spacebetween = 2;
	flagbarBG = newHudElem();
	flagbarBG.alignX = "center";
	flagbarBG.alignY = "top";
	flagbarBG.horzAlign = "center";
	flagbarBG.vertAlign = "top";
	flagbarBG.x = 0; 
	flagbarBG.y = 30; 
	flagbarBG.width = 18;
	flagbarBG.height = 12;
	flagbarBG.sort = -2;
	//flagbarBG.foreground = 1;
	flagbarBG.hidewheninmenu = true;
	flagbarBG.alpha = 0.5;
	flagbarBG.color = (0,0,0);
	flagbarBG.width = level.flags.size*spacebetween + level.flags.size*flagbarBG.width;
	flagbarBG setShader( "black", flagbarBG.width, 11 );
	flagbarBG thread destroy_team_hud();
}

/*
flag_bars_test_DYNAMIC_TEST()
{
	level.test_flag_size = 1;
	thread make_nums_DYNAMIC_TEST();
	oldsize = level.test_flag_size;
	for(;;)
	{
		
		id = level.test_flag_size-1;
		for( i = 0 ; i<level.test_flag_size; i++ )
			thread captured_flag_bar_item_DYNAMIC_TEST(i);
		thread captured_flag_bar_bg_DYNAMIC_TEST();
		level waittill("flagbar_debug_changed");
		level notify("destroy_team_hud");
		wait 0.1;
	}
}
make_nums_DYNAMIC_TEST()
{
	while(1)
	{
		if( level.player buttonpressed( "1" ) )
		{
			level.test_flag_size = 1;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "2" ) )
		{
			level.test_flag_size = 2;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "3" ) )
		{
			level.test_flag_size = 3;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "4" ) )
		{
			level.test_flag_size = 4;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "5" ) )
		{
			level.test_flag_size = 5;			
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "6" ) )
		{
			level.test_flag_size = 6;			
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "7" ) )
		{
			level.test_flag_size = 7;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "8" ) )
		{
			level.test_flag_size = 8;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "9" ) )
		{
			level.test_flag_size = 9;			
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "0" ) )
		{
			level.test_flag_size = 10;			
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "-" ) )
		{
			level.test_flag_size = 11;
			level notify("flagbar_debug_changed");
		}
		else if( level.player buttonpressed( "=" ) )
		{
			level.test_flag_size = 12;
			level notify("flagbar_debug_changed");
		}
		wait 0.05;
	}
}
	

captured_flag_bar_item_DYNAMIC_TEST(id)
{
	level endon("destroy_team_hud");
	number_offset = 0;
	level.flagbarY = -205;
	if(level.test_flag_size == 2 ||level.test_flag_size == 4 ||level.test_flag_size == 6 ||
	level.test_flag_size == 8 ||level.test_flag_size == 10 ||level.test_flag_size == 12 )
	{number_offset = -11;}
	flagbar = newHudElem();
	flagbar.alignX = "center";
	flagbar.alignY = "middle";
	flagbar.horzAlign = "center";
	flagbar.vertAlign = "middle";
	flagbar.x = 0; 
	flagbar.y = level.flagbarY; 
	flagbar.width = 12;
	flagbar.height = 8;
	flagbar.sort = -1;
	flagbar.foreground = 1;
	flagbar.hidewheninmenu = true;
	flagbar.alpha = 1;
	flagbar setShader( "white", 16, 8 );
	if(id == 0)
		flagbar.x = 0; 
	else if(id == 1)
		flagbar.x = 20;
	else if(id == 2)
		flagbar.x = -20;		
	else if(id == 3)
		flagbar.x = 40;
	else if(id == 4)
		flagbar.x = -40;
	else if(id == 5)
		flagbar.x = 60;
	else if(id == 6)
		flagbar.x = -60;		
	else if(id == 7)
		flagbar.x = 80;
	else if(id == 8)
		flagbar.x = -80;
	else if(id == 9)
		flagbar.x = 100;
	else if(id == 10)
		flagbar.x = -100;		
	else if(id == 11)
		flagbar.x = 120;
	else if(id == 12)
		flagbar.x = -120;
	
	flagbar.x = flagbar.x+number_offset; 
	flagbar thread destroy_team_hud();
	flagbar.alpha = 1;
	flagbar.color = level.neutral_color;
	if(id == 0)
		flagbar.color = level.allies_color;
	else if(id == 1)
		flagbar.color = level.axis_color;
	
}

captured_flag_bar_bg_DYNAMIC_TEST()
{
	level endon("destroy_team_hud");

	spacebetween = 2;
	
	flagbarBG = newHudElem();
	flagbarBG.alignX = "center";
	flagbarBG.alignY = "top";
	flagbarBG.horzAlign = "center";
	flagbarBG.vertAlign = "top";
	flagbarBG.x = 0; 
	flagbarBG.y = 30; 
	flagbarBG.width = 18;
	flagbarBG.height = 12;
	flagbarBG.sort = -2;
	flagbarBG.foreground = 1;
	flagbarBG.hidewheninmenu = true;
	flagbarBG.alpha = 0.5;
	flagbarBG.color = (0,0,0);
	
	flagbarBG.width = level.test_flag_size*spacebetween + level.test_flag_size*flagbarBG.width;
	flagbarBG setShader( "black", flagbarBG.width, 11 );
	flagbarBG thread destroy_team_hud();
}
*/
//=====================================================================
	
destroy_team_hud()
{
	level waittill("destroy_team_hud");
	self destroy();

}


// ##################################################
// ############# 3) BOT LOGIC #########################
// ##################################################

setup_bots()
{
	level.ally_bots = [];
	level.axis_bots = [];

	level waittill("spawn_bots");
	
	run_thread_on_targetname( level.ally_spawner, ::add_spawn_function, ::assign_bots_to_array_allies );
	run_thread_on_targetname( level.axis_spawner, ::add_spawn_function, ::assign_bots_to_array_axis );
	bot_attackers_defenders();	
	
	thread bot_debug();
	thread ally_bot_loop();
	thread axis_bot_loop();	
	
}

assign_bots_to_array_allies()
{
	self.cq_team = "allies";
	level.ally_bots[ level.ally_bots.size ] = self;
	self waittill("death");
	
	if(self.cq_behaviour == "attacker" )
		level.ally_attackers--;
	else if(self.cq_behaviour == "defender" )
		level.ally_defenders--;
	
	level.ally_bots = array_remove( level.ally_bots, self );	
}

assign_bots_to_array_axis()
{
	self.cq_team = "axis";
	level.axis_bots[ level.axis_bots.size ] = self;
	self waittill("death");

	if(self.cq_behaviour == "attacker" )
		level.axis_attackers--;
	else if(self.cq_behaviour == "defender" )
		level.axis_defenders--;

	level.axis_bots = array_remove( level.axis_bots, self );	
}

ally_bot_loop()
{
	while(1)
	{
		thread spawner_think( level.ally_spawner , level.team_allies , level.flags_allies );
		wait level.team_allies_spawn_delay;
		wait 0.05;
	}
}

axis_bot_loop()
{
	while(1)
	{
		thread spawner_think( level.axis_spawner , level.team_axis , level.flags_axis );
		wait level.team_axis_spawn_delay;
		wait 0.05;
	}
}

spawner_think( spawner, team_team , team_flags, botarray )
{	
	if( team_team.points > 0 && team_flags.size > 0 && team_team.bots_spawned < level.max_team_bots && team_team.bots_spawned < team_team.points )
	{
		while(1)
		{
			wait 0.05;
			flag = random(team_flags);
			if(flag.allow_spawn == true )
			{
				spawn = random(flag.spawns);
				break;
			}
			else
				return;
		}
		bot_spawner = getent( spawner , "targetname" );
		bot = bot_spawner stalingradspawn();
		
		if(spawn_failed( bot ))
			return;
		bot force_teleport_local(spawn.origin,spawn.angles);
		
		bot bot_settings();		
		bot thread bot_behaviour();

		team_team.bots_spawned++;
		level.bots_spawned++;
		bot waittill("death");
		while(1)
		{
			if(!isalive(bot))
				break;
			wait 0.05;
		}
		wait 0.1;
		level.bots_spawned--;
		team_team.bots_spawned--;
		team_team.points--;
	}	
}

bot_settings()
{
	self endon("death");

	self.name = "";
	self.ignoreme = false;
	self.ignoreall = false;
	self.fixednode = false;
	self.goalradius = 32;
	self.health = 350;

	self.in_flag = false;
	self.going_to_flag = true;
	self.cq_is_attacking = true;
	self.cq_is_defending = true;
	self.cq_has_goal = false;
	
	self.cq_behaviour = "attacker";
	
	if(self.cq_team == "allies" )
	{
		//self decide_atk_def();
		if(self.cq_behaviour == "attacker" )
			level.ally_attackers++;
		else if(self.cq_behaviour == "defender" )
			level.ally_defenders++;
	}
	else if(self.cq_team == "axis" )
	{
		//self decide_atk_def();
		if(self.cq_behaviour == "attacker" )
			level.axis_attackers++;
		else if(self.cq_behaviour == "defender" )
			level.axis_defenders++;
	}
	
	self thread bot_select_class();
}

/*
decide_atk_def(  )
{
	self endon("death");
	
	
	
	
	
}	
*/

// BOT ATTACKERS/DEFENDERS ========================================================================

bot_attackers_defenders()
{
	level.axis_assault = 0;
	level.axis_support = 0;
	level.axis_medic = 0;
	level.axis_sniper = 0;
	level.axis_specops = 0;
	
	level.ally_assault = 0;
	level.ally_support = 0;
	level.ally_medic = 0;
	level.ally_sniper = 0;
	level.ally_specops = 0;
	
	level.axis_attackers = 0;
	level.axis_defenders = 0;
	level.ally_attackers = 0;
	level.ally_defenders = 0;
	
	level.defenders_ratio = 0;
	level.attackers_ratio = level.max_team_bots;
/*
	// checking how no defenders work. script comment
	if(level.max_team_bots < 3)
	{
		level.defenders_ratio = 1;
		level.attackers_ratio = 2;
	}
	else
	{
		level.defenders_ratio = int(level.max_team_bots/3);
		attackers_ratio_pre = int(level.max_team_bots/3);
		level.attackers_ratio = attackers_ratio_pre*2;
	}
*/
}

// BOT CLASS ========================================================================
bot_select_class( class_id_override, player_bot )
{
	class_id = 1;
	if(isdefined(class_id_override))
	{
		class_id = class_id_override;
	}
	else
	{
		class_id = RandomIntRange( 1, 6 );
	}

	if(!(isdefined(player_bot)))
	{
		player_bot = 0;
	}


		if(self.cq_team == "allies")
		{
			self.voice = "british";
			if(class_id == 1)
			{
				thread set_bot_class( "body_sp_sas_woodland_assault_a", "head_sp_sas_woodland_todd", "m4_grunt", "usp", "fraggrenade", "assault" , player_bot );
			}
			else if(class_id == 2)
			{
				thread set_bot_class( "body_sp_sas_woodland_support_a", "head_sp_usmc_force_nomex", "saw", "usp", "fraggrenade", "support" , player_bot );
			}
			else if(class_id == 3)
			{
				thread set_bot_class( "body_sp_sas_woodland_assault_b", "head_sp_sas_woodland_zied", "mp5", "usp", "nofrags", "medic" , player_bot );
			}
			else if(class_id == 4)
			{
				thread set_bot_class( "body_sp_usmc_force_c", "head_specops_sp", "m40a3", "usp", "nofrags", "sniper" , player_bot );
			}
			else if(class_id == 5)
			{
				thread set_bot_class( "body_sp_usmc_force_b", "head_sp_usmc_force_chad", "mp5_silencer", "usp_silencer", "flash_grenade", "specops" , player_bot );
			}
		}
		else if(self.cq_team == "axis")
		{
			self.voice = "russian";
			if(class_id == 1)
			{
				thread set_bot_class( "body_sp_spetsnaz_yuri", "head_sp_spetsnaz_geoff_yuribody", "ak47", "beretta", "fraggrenade", "assault" , player_bot );
			}
			else if(class_id == 2)
			{
				thread set_bot_class( "body_sp_spetsnaz_vlad", "head_sp_spetsnaz_vlad_vladbody", "rpd", "beretta", "fraggrenade", "support" , player_bot );
			}
			else if(class_id == 3)
			{
				thread set_bot_class( "body_sp_spetsnaz_vlad", "head_sp_spetsnaz_collins_vladbody", "p90", "beretta", "nofrags","medic" , player_bot );
			}
			else if(class_id == 4)
			{
				thread set_bot_class( "body_sp_spetsnaz_demetry", "head_sp_spetsnaz_demetry_demetrybody", "dragunov", "beretta", "nofrags","sniper" , player_bot );
			}
			else if(class_id == 5)
			{
				thread set_bot_class( "body_complete_sp_spetsnaz_boris", "nohead", "p90_silencer", "beretta", "flash_grenade", "specops" , player_bot );
			}
		}
}


set_bot_class( body, head, weapon1, weapon2, frags, class_type, player_bot )
{
	//self DetachAll();
	// detach all was used to remove the possible headmodel from npc to avoid exceeding 128 bones.
	// i would use detach() but im not sure what to put so it removed the headmodel.
	// Detachall however causes an error from the animscripts/init::initweapon below about mp5 failed to detach.
	// the error persists on every spawn, although not game breaking, you cant have proper debugging with it.
	// so i put 2 spawners for each team that use fullbodymodels and not body+heads.
	// It is highly suggested to do the same for the initial spawners so we wont have to detach the additional head.
	// The classes are set here anyway so its not that big of a deal.
	
	// Appearance
	self setModel(body);
	if( head != "nohead" )
		self attach(head, "", true);

	// Weapons
	if(player_bot == 0 )
	{
		self animscripts\init::initWeapon( weapon1, "primary" );
		self animscripts\shared::placeWeaponOn( weapon1, "right" );
		self animscripts\init::initWeapon( weapon1, "secondary" );
		self animscripts\init::initWeapon( weapon2, "sidearm" );
		self.weapon = weapon1;
		self.primaryweapon = weapon1;
		self.lastweapon = weapon1;
		self.secondaryweapon = weapon2;
		self.sidearm = weapon2;
	}
	else
	{
		weapList = level.player GetCurrentWeapon();
		if( weapList == "c4" || weapList == "claymore" ) // prevents gamebreaking error no aivsai accuracy
			weapList = weapon1;
		self animscripts\init::initWeapon(  weapList, "primary" );
		self animscripts\shared::placeWeaponOn(  weapList, "right" );
		self animscripts\init::initWeapon(  weapList, "secondary" );
		self.weapon =  weapList;
		self.primaryweapon =  weapList;
		self.lastweapon =  weapList;
		return;
	}

	
	if( class_type == "sniper" )
		self.isSniper = true;	
	
	if(frags == "nofrags")
	{
		self.grenadeAmmo = 0;
	}
	else
	{
		self.grenadeWeapon = frags;
		self.grenadeAmmo = 1;
	}
	
	// Class stuff
	self.cq_class = class_type;

	if(self.cq_team == "allies")
	{
		if( class_type == "assault" )
			level.ally_assault++;
		else if( class_type == "support" )
			level.ally_support++;
		else if( class_type == "medic" )
			level.ally_medic++;	
		else if( class_type == "sniper" )
			level.ally_sniper++;	
		else if( class_type == "specops" )
			level.ally_specops++;	
	}
	else if(self.cq_team == "axis")
	{
		if( class_type == "assault" )
			level.axis_assault++;
		else if( class_type == "support" )
			level.axis_support++;
		else if( class_type == "medic" )
			level.axis_medic++;	
		else if( class_type == "sniper" )
			level.axis_sniper++;	
		else if( class_type == "specops" )
			level.axis_specops++;	
	}
	self waittill("death");
	if(self.cq_team == "allies")
	{
		if( class_type == "assault" )
			level.ally_assault--;
		else if( class_type == "support" )
			level.ally_support--;
		else if( class_type == "medic" )
			level.ally_medic--;	
		else if( class_type == "sniper" )
			level.ally_sniper--;	
		else if( class_type == "specops" )
			level.ally_specops--;	
	}
	else if(self.cq_team == "axis")
	{
		if( class_type == "assault" )
			level.axis_assault--;
		else if( class_type == "support" )
			level.axis_support--;
		else if( class_type == "medic" )
			level.axis_medic--;	
		else if( class_type == "sniper" )
			level.axis_sniper--;	
		else if( class_type == "specops" )
			level.axis_specops--;	
	}	
}

// BOT BEHAVIOURS ========================================================================

bot_behaviour()
{
	self endon("death");
	self thread bot_ending_behaviour();
	level endon("match_end");
	while(1)
	{
		if(self.cq_team == "allies")
		{
			if(self.cq_behaviour == "attacker" )
			{
				wait 0.05;
				if( level.flags_neutral_and_axis.size < 1 )
				{
					self setgoalpos(self.origin);
					wait 0.1;
				}
				else
				{
					cap_flag = self get_random_closest_flag( level.flags_neutral_and_axis );
					if(isdefined(cap_flag))
						self bot_ATTACK_flag( cap_flag );
				}
			}
			else if(self.cq_behaviour == "defender" )
			{
				wait 0.05;
				if( level.flags_allies.size < 1 )
				{
					self.cq_behaviour = "attacker";
					continue;
				}
				else
				{
					def_flag = self get_random_closest_flag( level.flags_allies );
					if(isdefined(def_flag))
						self bot_DEFEND_flag( def_flag );
				}		
			}
		}
		else if(self.cq_team == "axis")
		{
			if(self.cq_behaviour == "attacker" )
			{
				wait 0.05;
				if( level.flags_neutral_and_allies.size < 1 )
				{
					self setgoalpos(self.origin);
					wait 0.1;
				}
				else
				{
					cap_flag = self get_random_closest_flag( level.flags_neutral_and_allies );
					if(isdefined(cap_flag))
						self bot_ATTACK_flag( cap_flag );
				}
			}
			else if(self.cq_behaviour == "defender" )
			{
				wait 0.05;
				if( level.flags_axis.size < 1 )
				{
					self.cq_behaviour = "attacker";
					continue;
				}
				else
				{
					def_flag = self get_random_closest_flag( level.flags_axis );
					if(isdefined(def_flag))
						self bot_DEFEND_flag( def_flag );
				}		
			}
		}
		wait 0.05;
	}	
}

get_random_closest_flag(array)
{
	if(array.size > 1)
	{
		closest_flags = get_array_of_closest( self.origin, array );
		rand = randomintrange(0,2);
		return closest_flags[rand];
	}
	else
	{
		cap_flag = getclosest( self.origin, array );
		return cap_flag;
	}
}

bot_ending_behaviour()
{
	self endon("death");
	level waittill("match_end");
	self thread magic_bullet_shield();
	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = true;	
	self setgoalpos(self.origin);
}

/*
bot_behaviour()	
{

	while(1)
	{
		if(self.cq_team == "allies")
		{
			if(self.cq_behaviour == "attacker" )
			{
				if( level.flags_neutral_and_axis.size < 1 || level.ally_flags_increased )
				{
					if( level.ally_defenders<level.defenders_ratio )
					{
						level.ally_attackers--;
						level.ally_defenders++;
						self.cq_behaviour = "defender";
					}
				}
				else
				{
					cap_flag = getclosest( self.origin, level.flags_neutral_and_axis );
					if(isdefined(cap_flag))
						bot_ATTACK_flag( cap_flag );
					else 
						wait 0.1;
				}
			}
			else if(self.cq_behaviour == "defender" )
			{
				if( level.ally_flags_reduced )
				{
					level.ally_defenders--;
					level.ally_attackers++;
					self.cq_behaviour = "attacker";
				}
				else
				{
					def_flag = random( level.flags_allies );
					bot_DEFEND_flag( def_flag, level.flags_allies);
				}
			}
		}
		else if(self.cq_team == "axis")
		{
			if(self.cq_behaviour == "attacker" )
			{
				if( level.flags_neutral_and_allies.size < 1 || level.axis_flags_increased )
				{
					if( level.axis_defenders<level.defenders_ratio )
					{
						level.axis_attackers--;
						level.axis_defenders++;
						self.cq_behaviour = "defender";
					}
				}
				else
				{
					cap_flag = getclosest( self.origin, level.flags_neutral_and_allies );
					if(isdefined(cap_flag))
						bot_ATTACK_flag( cap_flag );
					else 
						wait 0.1;
				}
			}
			else if(self.cq_behaviour == "defender" )
			{
				if( level.axis_flags_reduced )
				{
					level.axis_defenders--;
					level.axis_attackers++;
					self.cq_behaviour = "attacker";
				}
				else
				{
					def_flag = random( level.flags_axis );
					bot_DEFEND_flag( def_flag, level.flags_axis);
				}
			}
		}
		wait 0.05;
	}
}	
*/

/*

bot_ATTACK_flag( flag ) // older
{
	self endon("death");
	level endon("match_end");
	
	self.cq_has_goal = false;
	
	if( flag.radius>0 )
	{
		flag_dist = RandomIntRange( 16 , (flag.radius-4) );
		while(1)
		{
			iprintlnbold(flag_dist);
			if( distance( self.origin , flag.origin ) < flag_dist )
			{
				self setgoalpos(self.origin);
				self.cq_has_goal = false;
			}
			else if(self.cq_has_goal == false)
			{
				//spawn = random(flag.spawns);
				//self setgoalpos(spawn.origin);
				self setgoalpos(flag.origin);
				self.cq_has_goal = true;
			}
			
			if( flag.owner == self.cq_team )
				break;
			wait 0.1;
		}
		return true;
	}
	else
		return false;
}

bot_DEFEND_flag( flag, team_flags )
{
	self endon("death");
	level endon("match_end");

	if( flag.radius>0 )
	{
		team_flags_defending = team_flags.size;
		flag_dist = RandomIntRange( 12 , (flag.radius-4) );
		while(1)
		{	
			if( distance( self.origin , flag.origin ) < flag_dist )
			{
				self setgoalpos(self.origin);
				self.cq_has_goal = false;
			}
			else if(self.cq_has_goal == false)
			{
				self setgoalpos(flag.origin);
				self.cq_has_goal = true;
			}
			
			if( team_flags.size != team_flags_defending || flag.owner != self.cq_team)
				break;
			wait 0.1;
		}
		return true;
	}
	return false;

}

*/

bot_ATTACK_flag( flag )
{
	self endon("death");
	level endon("match_end");
	if( flag.radius>0 )
	{
		self bot_go_to_flag( flag );
		while(1) 
		{ 
			if( flag.owner == self.cq_team )	
				break; 
			wait 0.1;
		}
		return true;
	}
	return false;
}

bot_DEFEND_flag( flag, team_flags )
{
	self endon("death");
	level endon("match_end");

	if( flag.radius>0 )
	{
		team_flags_defending = team_flags.size;
		self bot_go_to_flag( flag );
		while(1) 
		{ 
			if( team_flags.size != team_flags_defending )	
				break; 
			wait 0.1;
		}
		return true;	
	}
	return false;
}

bot_go_to_flag( flag )
{
	self endon("death");
	level endon("match_end");
	self setgoalpos(flag.origin);
	while(1) 
	{ 
		if ( distance( self.origin , flag.origin ) < flag.radius ) 
			break; 
		wait 0.05; 
	}
	radius2 = ( (flag.radius/5) * randomintrange(1,6) );
	if(radius2 < 64)radius2 = 64; // doing this so npcs won't go too close to the flag pole model.
	while(1) 
	{ 
		if ( distance( self.origin , flag.origin ) < radius2 ) 
			break; 
		wait 0.05; 
	}
	self setgoalpos(self.origin);
}


// BOT DEBUG ========================================================================

bot_debug()
{
	if(	!level.cq_debug )
		return;
	
	ally_bots = thread bot_debug_text(-50,&"ALLY_BOTS_");
	axis_bots = thread bot_debug_text(-30,&"AXIS_BOTS_");
	total_bots = thread bot_debug_text(-10,&"TOTAL_BOTS_");
	ally_atk = thread bot_debug_text(10,&"ALLY_ATTACKERS_");
	ally_def = thread bot_debug_text(30,&"ALLY_DEFENDERS_");
	axis_atk = thread bot_debug_text(50,&"AXIS_ATTACKERS_");
	axis_def = thread bot_debug_text(70,&"AXIS_DEFENDERS_");
	
	ally_assault = thread bot_debug_text(88,&"ALLY_ASSAULT_",1);
	ally_support = thread bot_debug_text(96,&"ALLY_SUPPORT_",1);
	ally_medic = thread bot_debug_text(104,&"ALLY_MEDIC_",1);
	ally_sniper = thread bot_debug_text(112,&"ALLY_SNIPER_",1);
	ally_specops = thread bot_debug_text(120,&"ALLY_SPECOPS_",1);
	
	axis_assault = thread bot_debug_text(128,&"AXIS_ASSAULT_",1);
	axis_support = thread bot_debug_text(136,&"AXIS_SUPPORT_",1);
	axis_medic = thread bot_debug_text(144,&"AXIS_MEDIC_",1);
	axis_sniper = thread bot_debug_text(152,&"AXIS_SNIPER_",1);
	axis_specops = thread bot_debug_text(160,&"AXIS_SPECOPS_",1);
	
	ally_spawn_delay = thread bot_debug_text(172,&"ALL_SPWN_DEL_",1);
	axis_spawn_delay = thread bot_debug_text(184,&"AX_SPWN_DEL_",1);
	
	
	
	wait 0.1;
	while(1)
	{
		ally_bots setvalue(level.team_allies.bots_spawned);
		axis_bots setvalue(level.team_axis.bots_spawned);
		total_bots setvalue(level.bots_spawned);
		ally_atk setvalue(level.ally_attackers);
		ally_def setvalue(level.ally_defenders);
		axis_atk setvalue(level.axis_attackers);
		axis_def setvalue(level.axis_defenders);
		
		ally_assault setvalue(level.ally_assault);
		ally_support setvalue(level.ally_support);
		ally_medic setvalue(level.ally_medic);
		ally_sniper setvalue(level.ally_sniper);
		ally_specops setvalue(level.ally_specops);
		axis_assault setvalue(level.axis_assault);
		axis_support setvalue(level.axis_support);
		axis_medic setvalue(level.axis_medic);
		axis_sniper setvalue(level.axis_sniper);
		axis_specops setvalue(level.axis_specops);
		ally_spawn_delay setvalue(level.team_allies_spawn_delay);
		axis_spawn_delay setvalue(level.team_axis_spawn_delay);

		wait 0.05;
	}
	
}

bot_debug_text(y,text,scale)
{
	bot_debug_text = newHudElem();
	bot_debug_text.alignX = "left";
	bot_debug_text.alignY = "middle";
	bot_debug_text.horzAlign = "left";
	bot_debug_text.vertAlign = "middle";
	bot_debug_text.x = 0;
	bot_debug_text.y = y; 
	bot_debug_text.font = "default"; 
	bot_debug_text.fontScale = 1.5; 

	if(isdefined(scale))
		bot_debug_text.fontScale = scale; 
	
	bot_debug_text.label = text;
	return bot_debug_text;
}

// ##################################################
// ############# 4) PLAYER LOGIC #########################
// ##################################################

setup_player()
{
	level.player_linker = spawn_player_linker();
	level.player playerlinktodelta( level.player_linker, "", 0, 0, 0, 0, 0 );
	level.player_linker moveto(level.top_down_org.origin, 0.1);
	level.player_linker rotateto(level.top_down_org.angles, 0.1);
	wait 0.1;

	level.player.cq_team = "neutral";
	
	level.player.conquest_kills = 0;
	level.player.conquest_deaths = 0;
	level.player.conquest_captures = 0;
	
	thread player_stats_update();

	level.global_kill_func = ::conquest_player_kills;
	level.global_damage_func_ads = ::conquest_hitmarker;
	level.global_damage_func = ::conquest_hitmarker;
	
	level.player.cq_alive = false;
	level.player.cq_inflag = false;
	level.player_killer = undefined;
	
	level.player takeallweapons();
	level.player.ignoreme = true;
	level.player allowStand( true );
	level.player allowProne( false );
	level.player allowCrouch( false );
	level.player AllowSprint( false );
	level.player disableweapons();

	thread player_cq_health_system(); 
	thread player_team_selection(); // GAMEPLAY START
	thread health_crate(); 
	thread ammo_crate(); 
}

conquest_player_kills( type, location, point )
{
	level.player.conquest_kills++;
	thread conquest_hitmarker();
}

conquest_hitmarker( type, location, point)
{
	thread conquest_hitmarker2();
}

conquest_hitmarker2()
{
	if ( getdvar( "cq_hitmarker" ) == "0" )
		return;
	level notify("new_hitmarker");
	level endon("new_hitmarker");
	hud_damagefeedback = newHudElem();
	hud_damagefeedback.horzAlign = "center";
	hud_damagefeedback.vertAlign = "middle";
	hud_damagefeedback.x = -12;
	hud_damagefeedback.y = -12;
	hud_damagefeedback.alpha = 1;
	hud_damagefeedback thread conquest_hitmarker_destroy();
	hud_damagefeedback setShader("damage_feedback", 24, 48);
	hud_damagefeedback fadeOverTime(1);
	hud_damagefeedback.alpha = 0;
	level.player thread play_sound_on_tag("hitmarker");
	wait 1;
	hud_damagefeedback destroy();
	level notify("hitmarker_over");
}

conquest_hitmarker_destroy()
{
	level endon("hitmarker_over");
	level waittill("new_hitmarker");
	self destroy();
}


player_stats_update()
{
	level endon("match_end");
	while(1)
	{
		prev_caps = level.player.conquest_captures;
		prev_ks = level.player.conquest_kills;
		prev_ds = level.player.conquest_deaths;
		
		setMissionDvar( "cq_player_match_captures", level.player.conquest_captures );	
		setMissionDvar( "cq_player_match_kills", level.player.conquest_kills );	
		setMissionDvar( "cq_player_match_deaths", level.player.conquest_deaths );	
		
		// Prevents looping for no reason. When one of them changes, it loops to update.
		while(	prev_caps == level.player.conquest_captures && 
			prev_ks == level.player.conquest_kills && 
			prev_ds == level.player.conquest_deaths 
		)
		wait 0.05;
		
		wait 0.05;
	}
}

player_team_selection()
{	
	level.player openMenu("conquest_team");
	setblur(4,0);
	level.player waittill("menuresponse", menu, response);
	SetBlur( 0, 0 );
	
	if(response == "allies")
	{
		level.player.cq_team = "allies";
		level.ally_spawner = "ally_spawner";
		level.axis_spawner = "axis_spawner";
		level.player setviewmodel( "viewhands_sas_woodland" );
	}
	else if(response == "axis")
	{
		level.player.cq_team = "axis";
		level.ally_spawner = "axis_spawner";
		level.axis_spawner = "ally_spawner";
		level.player setviewmodel( "viewhands_op_force" );
	}
	
	level notify("player_selected_team");
	level notify("spawn_bots");
	
	level.player unlink();
	level.player_linker delete();
	thread player_class_selection();
	thread player_end_match();
}

player_end_match()
{
	level waittill("match_end");
	level notify("player_stop_functions");
	
	thread simple_hud_hide();
	level.player disableweapons();
	level.player SetMoveSpeedScale( 0 );
	level.player.ignoreme = true;
	level.player allowStand( true);
	level.player allowProne( false );
	level.player AllowSprint( false );
	level.player CloseMenu();
	wait 2;


	if( level.player.cq_alive == true )
		thread spawn_player_death_npc(1);
	level.player.cq_alive = false;
	
	level.player allowCrouch( false );	
	level.player unlink();
	level.player takeallweapons();
	level.player freezecontrols(true);

	level.player_linker = spawn_player_linker();
	level.player playerlinktodelta( level.player_linker, "", 0, 0, 0, 0, 0 );
	f_movetime = 4;
	level.player_linker moveto(level.top_down_org.origin, f_movetime,1,1);
	level.player_linker rotateto(level.top_down_org.angles, f_movetime,1,1);
	wait f_movetime;
	wait 0.2;
	level.player freezecontrols(false);
}

player_class_selection()
{
	level endon("player_stop_functions");

	level.player_linker = spawn_player_linker();
	level.player playerlinktodelta( level.player_linker, "", 0, 0, 0, 0, 0 );

	if(level.player.cq_team == "allies" )
		level.player openMenu("conquest_class_allies");
	else if(level.player.cq_team == "axis" )
		level.player openMenu("conquest_class_axis");
	
	setblur(4,0);
	level.player waittill("menuresponse", menu, response);
	SetBlur( 0, 0 );
	
	player_give_class(response);
	thread player_spawn_selection();
}

// This loops when player dies. Calls class selection, and goes back to this.


flag_objective_mark(objid)
{
	level endon("flag_objective_menu");
	//objid = int(objid);
	i = objid-1;
	while(1)
	{
		if(level.player.cq_team == "allies" )
		{
			if( level.flags[i].owner == "allies" && level.flags[i].allow_spawn == true )
			{
				level.flags[i].selected = true;
				level.player_spawn_valid_obj_select = 1;
				while(1)
				{
					if( level.flags[i].owner != "allies" || level.flags[i].allow_spawn == false )
						break;
					wait 0.05;
				}
			}
			//if( level.flags[i].owner == "axis" || level.flags[i].owner == "neutral" || level.flags[i].allow_spawn == ??? )
			else
			{
				level.flags[i].selected = false;
				level.player_spawn_valid_obj_select = 0;
				while(1)
				{
					if( level.flags[i].owner == "allies" && level.flags[i].allow_spawn == true )
						break;
					wait 0.05;
				}
			}
		}
		else if(level.player.cq_team == "axis" )
		{
			if( level.flags[i].owner == "axis" && level.flags[i].allow_spawn == true )
			{
				level.flags[i].selected = true;
				level.player_spawn_valid_obj_select = 1;
				while(1)
				{
					if( level.flags[i].owner != "axis" || level.flags[i].allow_spawn == false  )
						break;
					wait 0.05;
				}
			}
			//if( level.flags[i].owner == "allies" || level.flags[i].owner == "neutral" || level.flags[i].allow_spawn == ???  )
			else
			{
				level.flags[i].selected = false;
				level.player_spawn_valid_obj_select = 0;
				while(1)
				{
					if( level.flags[i].owner == "axis" && level.flags[i].allow_spawn == true )
						break;
					wait 0.05;
				}
			}
		}
		wait 0.05;
	}
}

player_spawn_selection()
{
	level endon("player_stop_functions");

	setblur(4,0);

	if( level.flags.size<9 && level.flags.size>1 )
	{
		level.player openMenu("conquest_spawn_select"+level.flags.size);
	}
	else
	{
		//iprintlnbold(&"too_many_or_too_few_flags_placed");
	}
	
	level.player_spawn_valid_obj_select = 0;
	previous_response = 0;
	while(1)
	{
		level.player waittill("menuresponse", menu, response);
		level notify("flag_objective_menu");
		if(response != "confirm_spawn")
		{
			response = int(response);
			for( i = 0 ; i<level.flags.size; i++ )
				level.flags[i].selected	= false;
			
			previous_response = response;
			thread flag_objective_mark(response);
		}
		else if(response == "confirm_spawn" )
		{
			if(level.player_spawn_valid_obj_select == 1)
				break;
			else
			{
				SetBlur( 0, 0 );
				thread player_spawn_selection();
				return;
			}
		}
		wait 0.05;
	}
	SetBlur( 0, 0 );
	for( i = 0 ; i<level.flags.size; i++ )
	level.flags[i].selected	= false;
	player_spawn = random(level.flags[(previous_response-1)].spawns);
	//player_spawn = random(level.flags[0].spawns);
	//player_spawn = player_select_spawn_flag();
	//level waittill("player_spawn_selected");
	
	level.player thread play_sound_on_entity ( "zoom_out" );
	spawn_player_transition(player_spawn); // cool bf1 style spawn from top view.

	wait 0.2;
	level.player unlink();
	level.player_linker delete();
	
	level.player.ignoreme = false;
	//level.player freezecontrols(false);
	level.player allowCrouch( true );
	level.player allowProne( true );
	level.player AllowSprint( true );
	level.player enableweapons();
	thread simple_hud_show();

	level.player notify("player_spawned");	
	level.player.cq_alive = true;
	level.player waittill("player_dead");
	level.player.cq_alive = false;

	thread simple_hud_hide();
	thread spawn_player_death_npc();
	level.player takeallweapons();
	level.player disableweapons();
	level.player.ignoreme = true;
	level.player freezecontrols(true);
	level.player allowProne( false );
	level.player AllowSprint( false );
	level.player allowCrouch( false );
	
	player_death_spot = spawn( "script_origin", level.player.origin );
	player_death_spot.origin = level.player.origin;
	player_death_spot.angles = (0,level.player getplayerangles()[1],0);
	level.player_linker = spawn_player_linker();
	level.player playerlinktodelta( level.player_linker, "", 0, 0, 0, 0, 0 );
	level.player_linker moveto(player_death_spot.origin+(0,0,128), 0.2);
	level.player_linker rotateto(player_death_spot.angles+(80,0,0), 0.2);
	wait 0.2;
	level.player_linker moveto(player_death_spot.origin+(0,0,512), 2,0.5,0.5);
	wait 2.5;
	
	f_movetime = 4;
	if(isalive(level.player_killer))
	{	
		level.player_linker thread rotateToPos(level.player_killer.origin, 1, 0.1, 0.5);
		wait 1.5;	
		level.player_killer = undefined;
		f_movetime = 2.5;
	}
	level.player thread play_sound_on_entity ( "zoom_in" );
	level.player_linker moveto(level.top_down_org.origin, f_movetime,1,1);
	level.player_linker rotateto(level.top_down_org.angles, f_movetime,1,1);
	wait f_movetime;
	wait 0.2;
	level.player freezecontrols(false);
	level.player unlink();
	level.player_linker delete();
	thread player_class_selection();
}


spawn_player_linker()
{
	linker = spawn( "script_origin", level.player.origin );
	linker.origin = level.player.origin;
	linker.angles = level.player getplayerangles();
	return linker;

}

// Move Player From Top View to spawn in a cool way.
// This is made to prevent clipping through walls when spawning
// map maker must put an extra origin that is targeted from spawn origin to override the spawn path.
// the spawns targeted org can have an extra targeted org for further movement. Just for fun.
// NOTE TO USER: Try not to put angles that are too different, it will make it look odd.
spawn_player_transition(player_spawn)
{
	level endon("player_stop_functions");

	if( isdefined(player_spawn.target))
	{
		player_spawn_target = getent(player_spawn.target , "targetname");
		if( isdefined(player_spawn_target.target))
		{
			player_spawn_target2 = getent(player_spawn_target.target , "targetname");
			
			distance_plr_target2 = distance( level.player.origin , player_spawn_target2.origin );
			distance_target2_target1 = distance( player_spawn_target.origin , player_spawn_target2.origin );
			distance_spawn_target1 = distance( player_spawn.origin , player_spawn_target.origin );
			distance_total = distance_plr_target2 + distance_spawn_target1 + distance_target2_target1;
			to_target2_time = 2*(distance_plr_target2/distance_total);
			to_target1_time = 2*(distance_target2_target1/distance_total);
			to_spawn_time = 2*(distance_spawn_target1/distance_total);
			level.player_linker moveto(player_spawn_target2.origin, to_target2_time, to_target2_time/4, 0);
			level.player_linker rotateto(player_spawn_target2.angles, to_target2_time, to_target2_time/4, 0);
			wait to_target2_time;
			level.player_linker moveto(player_spawn_target.origin, to_target1_time, 0, 0);
			level.player_linker rotateto(player_spawn_target.angles, to_target1_time, 0, 0);	
			wait to_target1_time;
			level.player_linker moveto(player_spawn.origin, to_spawn_time, 0, to_spawn_time/4);
			level.player_linker rotateto(player_spawn.angles, to_spawn_time, 0, to_spawn_time/4);	
			wait to_spawn_time;
		}
		else
		{
			distance_plr_target1 = distance( level.player.origin , player_spawn_target.origin );
			distance_spawn_target1 = distance( player_spawn.origin , player_spawn_target.origin );
			distance_total = distance_plr_target1 + distance_spawn_target1;
			to_target1_time = 2*(distance_plr_target1/distance_total);
			to_spawn_time = 2*(distance_spawn_target1/distance_total);
			level.player_linker moveto(player_spawn_target.origin, to_target1_time, to_target1_time/4, 0);
			level.player_linker rotateto(player_spawn_target.angles, to_target1_time, to_target1_time/4, 0);
			wait to_target1_time;
			level.player_linker moveto(player_spawn.origin, to_spawn_time, 0, to_spawn_time/4);
			level.player_linker rotateto(player_spawn.angles, to_spawn_time, 0, to_spawn_time/4);	
			wait to_spawn_time;
		}
	}
	else
	{
		level.player_linker moveto(player_spawn.origin, 2, 0.7, 0.7);
		level.player_linker rotateto(player_spawn.angles, 2, 0.7, 0.7);
		wait 2;
	}
}

// Player select spawn system. Putting global arrays as Parameter didn't work so i had to do big if statements.
player_select_spawn_flag()
{
	level endon("player_spawn_set");
	selector = 1;
	if( level.player.cq_team == "allies")
	{
		currentsize = level.flags_allies.size;
		if( level.flags_allies.size > 0 )
		{
			for( i = 0 ; i<level.flags_allies.size; i++ )
				level.flags_allies[i].selected = false;
			level.flags_allies[(selector-1)].selected = true;
			level.flags_allies[(selector-1)] thread spawn_select_mark_flag();
		}
		while(1)
		{
			if( level.flags_allies.size > 0 )
			{
				if( level.player buttonpressed( "w" ) ) 
				{	
					for( i = 0 ; i<level.flags_allies.size; i++ )
						level.flags_allies[i].selected = false;
					selector = selector+1;
					if(selector>level.flags_allies.size)
						selector = 1;
					if(level.flags_allies[(selector-1)].selected == false)
					{
						level.flags_allies[(selector-1)].selected = true;
						level.flags_allies[(selector-1)] thread spawn_select_mark_flag();
					}
					wait 0.1;
					continue;
				}
				else if( level.player buttonpressed( "s" ))
				{				
					for( i = 0 ; i<level.flags_allies.size; i++ )
						level.flags_allies[i].selected = false;
					selector = selector-1;
					if(selector<1)
						selector = level.flags_allies.size;
					if(level.flags_allies[(selector-1)].selected == false)
					{
						level.flags_allies[(selector-1)].selected = true;
						level.flags_allies[(selector-1)] thread spawn_select_mark_flag();
					}	
					wait 0.1;
					continue;
				}
				else if(currentsize > level.flags_allies.size)
				{					
					currentsize = level.flags_allies.size;
					for( i = 0 ; i<level.flags_allies.size; i++ )
						level.flags_allies[i].selected = false;
					selector = selector-1;
					if(selector<1)
						selector = level.flags_allies.size;
					if(level.flags_allies[(selector-1)].selected == false)
					{
						level.flags_allies[(selector-1)].selected = true;
						level.flags_allies[(selector-1)] thread spawn_select_mark_flag();
					}
					wait 0.1;
					continue;
				}
				else if(currentsize < level.flags_allies.size)
				{					
					currentsize = level.flags_allies.size;
					wait 0.1;
					continue;
				}
				else if( level.player buttonpressed( "f" ) )
				{
					level notify("flag_marker_destroy");
					level notify("player_spawn_selected");
					return random(level.flags_allies[(selector-1)].spawns);
				}
			}
			else
			{
				for( i = 0 ; i<level.flags_allies.size; i++ )
					level.flags_allies[i].selected = false;				
				level notify("flag_marker_destroy");
			}
			wait 0.1;
		}
	}
	else if( level.player.cq_team == "axis") 
	{
		currentsize = level.flags_axis.size;
		if( level.flags_axis.size > 0 )
		{
			for( i = 0 ; i<level.flags_axis.size; i++ )
				level.flags_axis[i].selected = false;
			level.flags_axis[(selector-1)].selected = true;
			level.flags_axis[(selector-1)] thread spawn_select_mark_flag();
		}
		while(1)
		{
			if( level.flags_axis.size > 0 )
			{
				if( level.player buttonpressed( "w" ) ) 
				{	
					for( i = 0 ; i<level.flags_axis.size; i++ )
						level.flags_axis[i].selected = false;
					selector = selector+1;
					if(selector>level.flags_axis.size)
						selector = 1;
					if(level.flags_axis[(selector-1)].selected == false)
					{
						level.flags_axis[(selector-1)].selected = true;
						level.flags_axis[(selector-1)] thread spawn_select_mark_flag();
					}
					wait 0.1;
					continue;
				}
				else if( level.player buttonpressed( "s" ))
				{				
					for( i = 0 ; i<level.flags_axis.size; i++ )
						level.flags_axis[i].selected = false;
					selector = selector-1;
					if(selector<1)
						selector = level.flags_axis.size;
					if(level.flags_axis[(selector-1)].selected == false)
					{
						level.flags_axis[(selector-1)].selected = true;
						level.flags_axis[(selector-1)] thread spawn_select_mark_flag();
					}	
					wait 0.1;
					continue;
				}
				else if(currentsize > level.flags_axis.size)
				{					
					currentsize = level.flags_axis.size;
					for( i = 0 ; i<level.flags_axis.size; i++ )
						level.flags_axis[i].selected = false;
					selector = selector-1;
					if(selector<1)
						selector = level.flags_axis.size;
					if(level.flags_axis[(selector-1)].selected == false)
					{
						level.flags_axis[(selector-1)].selected = true;
						level.flags_axis[(selector-1)] thread spawn_select_mark_flag();
					}
					wait 0.1;
					continue;
				}
				else if(currentsize < level.flags_axis.size)
				{					
					currentsize = level.flags_axis.size;
					wait 0.1;
					continue;
				}
				else if( level.player buttonpressed( "f" ) )
				{
					level notify("flag_marker_destroy");
					level notify("player_spawn_selected");
					return random(level.flags_axis[(selector-1)].spawns);
				}
			}
			else
			{
				for( i = 0 ; i<level.flags_axis.size; i++ )
					level.flags_axis[i].selected = false;				
				level notify("flag_marker_destroy");
			}
			wait 0.1;
		}
	}
}

spawn_select_mark_flag(id)
{
	level notify("flag_marker_destroy");
	marker = spawn( "script_model", self.origin+(0,0,7) );
	marker.angles = (-90,0,0);
	marker setModel( "tag_origin" );
	playfxontag( level.glowing_marker_YELLOW, marker, "tag_origin" );	
	level waittill("flag_marker_destroy");
	marker delete();
}

// ======== AMMO CRATES ======

ammo_crate()
{
	ammo_crate_trigger = getentarray("ammo_crate_trigger","targetname");
	for ( i=0; i<ammo_crate_trigger.size; i++ )
	{
		ammo_crate_trigger[i] thread ammo_crate_trigg_think();
		ammo_crate_trigger[i] thread item_crate_icon( "hud_ammo" , -20 );
	}
}

ammo_crate_trigg_think()
{
	temp = 0;
	while(1)
	{
		if( level.player istouching(self) )
		{
			weapList = level.player GetWeaponsListPrimaries();
			for ( i=0; i<weapList.size; i++ )
			level.player SetWeaponAmmoStock( weapList[i], 9999 );
			if( temp == 0 )
				level.player thread play_sound_on_entity ( "weap_pickup" );
			temp = 1;
		}
		else
			temp = 0;
		wait 1;
	}
}

// ======== HEALTH CRATES ======

health_crate()
{
	medic_crate_trigger = getentarray("medic_crate_trigger","targetname");
	for ( i=0; i<medic_crate_trigger.size; i++ )
	{
		medic_crate_trigger[i] thread health_crate_trigg_think();
		medic_crate_trigger[i] thread item_crate_icon( "hud_med" , 40 );
	}
}

health_crate_trigg_think()
{
	while(1)
	{
		if( level.player istouching(self) &&  (level.player.conquest_health != level.player.conquest_maxhealth)  )
		{
			level.player healthpack_give_health(20);
			level.player thread play_sound_on_entity ( "health_pickup_medium" );
		}
		wait 1;
	}
}

// ======== ICONS ======

item_crate_icon(iconz, yoffset)
{
	icon = refill_icon( iconz, yoffset );
	while(1)
	{
		if(level.player istouching(self))
			icon.alpha = 0.8;
		else
			icon.alpha = 0;
		wait 0.1;
	}
}

refill_icon( icon, yoffset )
{
	icon_size = 52;
	refilicon = newHudElem();
	refilicon.alignX = "right";
	refilicon.alignY = "middle";
	refilicon.horzAlign = "right";
	refilicon.vertAlign = "middle";
	refilicon.x = -10;
	refilicon.y = yoffset; 
	refilicon.width = icon_size;
	refilicon.height = icon_size;
	refilicon.sort = -1;
	refilicon.hidewheninmenu = true;
	refilicon.alpha = 0;
	refilicon setShader( icon, icon_size, icon_size );
	return refilicon;
}





// ======== PLAYER CLASS SYSTEM ======
/*
		=====Assault===================
		ak47, m9, frags x2, flash x1
		=====Support===================
		rpd, m9, ammopack, frags x3, smoke x1
		=====Medic===================
		p90, m9, medpack, frags x1
		=====Sniper===================
		dragunov, m9,	claymores x2, frags x1
		=====Spec-Ops===================
		p90sd, m9sd, c4 x2, flash x4		
*/
player_give_class(response)
{	
	level.player takeallweapons();
	level.player.cq_class = response;
	plrprimary = "mp5";
	level.player SetMoveSpeedScale( 1 );
	level.player.conquest_maxhealth = level.player.conquest_maxhealth_value;
	level.player.conquest_health = level.player.conquest_maxhealth;
	
	if(level.player.cq_team == "allies")
	{
		if(response == "assault")
		{
			level.player.cq_class_id = 1;		
			level.player giveweapon("m4_grunt");
			level.player givemaxammo("m4_grunt");	
			plrprimary = "m4_grunt";
			level.player giveweapon("usp");	
			level.player givemaxammo("usp");
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "flash_grenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 2 );
			level.player SetWeaponAmmoStock( "flash_grenade", 1 );			
		}
		else if(response == "support")
		{
			level.player.cq_class_id = 2;
			level.player giveweapon("saw");
			level.player givemaxammo("saw");	
			plrprimary = "saw";
			level.player giveweapon("usp");	
			level.player givemaxammo("usp");
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "smoke_grenade_american" );
			level.player SetWeaponAmmoStock( "fraggrenade", 3 );
			level.player SetWeaponAmmoStock( "smoke_grenade_american", 1 );			
			//level.player SetActionSlot( 2, "weapon" , "ammopack" );
			//level.player giveweapon("ammopack");
			//level.player SetWeaponAmmoStock( "ammopack", 3 );		
		}
		else if(response == "medic")
		{
			level.player.cq_class_id = 3;
			level.player giveweapon("mp5");
			level.player givemaxammo("mp5");
			plrprimary = "mp5";
			level.player giveweapon("usp");	
			level.player givemaxammo("usp");
			level.player giveWeapon( "fraggrenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 1 );		
			level.player.conquest_maxhealth = 400;
			level.player.conquest_health = level.player.conquest_maxhealth;
			//level.player SetActionSlot( 2, "weapon" , "medpack" );
			//level.player giveweapon("medpack");
			//level.player SetWeaponAmmoStock( "medpack", 3 );
		}
		else if(response == "sniper")
		{
			level.player.cq_class_id = 4;
			level.player giveweapon("m40a3");
			level.player givemaxammo("m40a3");
			plrprimary = "m40a3";
			level.player giveweapon("usp");	
			level.player givemaxammo("usp");
			level.player giveWeapon( "fraggrenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 1 );		
			level.player SetActionSlot( 2, "weapon" , "claymore" );
			level.player giveweapon("claymore");
			level.player SetWeaponAmmoStock( "claymore", 2 );	
		}
		else if(response == "specops")
		{
			level.player.cq_class_id = 5;
			level.player giveweapon("mp5_silencer");
			level.player givemaxammo("mp5_silencer");
			plrprimary = "mp5_silencer";
			level.player giveweapon("usp_silencer");	
			level.player givemaxammo("usp_silencer");
			level.player giveWeapon( "flash_grenade" );
			level.player SetWeaponAmmoStock( "flash_grenade", 4 );		
			level.player SetActionSlot( 2, "weapon" , "c4" );
			level.player giveweapon("c4");
			level.player SetWeaponAmmoStock( "c4", 2 );	
			level.player SetMoveSpeedScale( 1.25 );
		}
	}
	else if(level.player.cq_team == "axis")
	{
		if(response == "assault")
		{
			level.player.cq_class_id = 1;
			level.player giveweapon("ak47");
			level.player givemaxammo("ak47");	
			plrprimary = "ak47";
			level.player giveweapon("beretta");	
			level.player givemaxammo("beretta");
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "flash_grenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 2 );
			level.player SetWeaponAmmoStock( "flash_grenade", 1 );			
		}
		else if(response == "support")
		{
			level.player.cq_class_id = 2;
			level.player giveweapon("rpd");
			level.player givemaxammo("rpd");	
			plrprimary = "rpd";
			level.player giveweapon("beretta");	
			level.player givemaxammo("beretta");
			level.player giveWeapon( "fraggrenade" );
			level.player giveWeapon( "smoke_grenade_american" );
			level.player SetWeaponAmmoStock( "fraggrenade", 3 );
			level.player SetWeaponAmmoStock( "smoke_grenade_american", 1 );			
			//level.player SetActionSlot( 2, "weapon" , "ammopack" );
			//level.player giveweapon("ammopack");
			//level.player SetWeaponAmmoStock( "ammopack", 3 );		
		}
		else if(response == "medic")
		{
			level.player.cq_class_id = 3;
			level.player giveweapon("p90");
			level.player givemaxammo("p90");
			plrprimary = "p90";
			level.player giveweapon("beretta");	
			level.player givemaxammo("beretta");
			level.player giveWeapon( "fraggrenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 1 );		
			level.player.conquest_maxhealth = 400;
			level.player.conquest_health = level.player.conquest_maxhealth;
			//level.player SetActionSlot( 2, "weapon" , "medpack" );
			//level.player giveweapon("medpack");
			//level.player SetWeaponAmmoStock( "medpack", 3 );
		}
		else if(response == "sniper")
		{
			level.player.cq_class_id = 4;
			level.player giveweapon("dragunov");
			level.player givemaxammo("dragunov");
			plrprimary = "dragunov";
			level.player giveweapon("beretta");	
			level.player givemaxammo("beretta");
			level.player giveWeapon( "fraggrenade" );
			level.player SetWeaponAmmoStock( "fraggrenade", 1 );		
			level.player SetActionSlot( 2, "weapon" , "claymore" );
			level.player giveweapon("claymore");
			level.player SetWeaponAmmoStock( "claymore", 2 );	
		}
		else if(response == "specops")
		{
			level.player.cq_class_id = 5;
			level.player giveweapon("p90_silencer");
			level.player givemaxammo("p90_silencer");
			plrprimary = "p90_silencer";
			level.player giveweapon("beretta");	
			//level.player giveweapon("beretta_silencer_mp");	
			level.player givemaxammo("beretta");
			//level.player givemaxammo("beretta_silencer_mp");
			level.player giveWeapon( "flash_grenade" );
			level.player SetWeaponAmmoStock( "flash_grenade", 4 );		
			level.player SetActionSlot( 2, "weapon" , "c4" );
			level.player giveweapon("c4");
			level.player SetWeaponAmmoStock( "c4", 2 );	
			level.player SetMoveSpeedScale( 1.25 );
		}
	}
	level.player switchtoweapon(plrprimary);
}

// ==== Player Health System =====
player_cq_health_system()
{
	
	level.player.conquest_maxhealth_value = 250;
	level.player.conquest_maxhealth = level.player.conquest_maxhealth_value;
	level.player.conquest_health = level.player.conquest_maxhealth;

	level.player thread conquest_healthbar();
	level.player thread InfiniteHealth();
	level.player thread player_conquest_health_logic();
	level.player thread hideshow_health_Bar(0);
	
	level endon("match_end");

    while(1)
    {
		current_health = level.player.conquest_health / level.player.conquest_maxhealth;
		if ( current_health > 1 )current_health = 1;else if ( current_health < 0 )current_health = 0;		
		level.player thread healthbar_color_manage();
		level.player.healthbar thread maps\_hud_util::updateBar( current_health );
		wait 0.05;
    }
}

//Health logic
player_conquest_health_logic()
{
	level endon("match_end");
	while(1)
	{
		self waittill("player_spawned");
		self.conquest_health = self.conquest_maxhealth;
		self thread hideshow_health_Bar(1);
		self DisableInvulnerability();
		while(1)
		{
			self waittill( "damage", damage_amount, attacker);
			self.conquest_health = self.conquest_health - damage_amount;
			if(self.conquest_health<1)
				break;		
		}
		
		if( isai(attacker) || isalive(attacker) )
			level.player_killer = attacker;
		self thread hideshow_health_Bar(0);
		self EnableInvulnerability();
		self notify("player_dead");
		self.conquest_deaths++;
	}
}


healthpack_give_health(amount)
{
	if( self.conquest_health > 0 )
	{
		if( (self.conquest_health + amount) > self.conquest_maxhealth )
		{
			//iprintlnbold(&"full_health");
			self.conquest_health = self.conquest_maxhealth;
		}
		else
		{
			//iprintlnbold(&"full_health_increased");
			self.conquest_health = self.conquest_health + amount;
		}
	}
}

InfiniteHealth()
{
	while(1)
	{
		self.health = 1000000;
		self waittill( "damage" );
	}
}

//Health Bar
conquest_healthbar()
{
	self.healthbar = maps\_hud_util::createBar( "white", "black", 128 , 12 );
	self.healthbar maps\_hud_util::setPoint( "CENTER", undefined, 0, 230 );
	//self.healthbar.foreground = 1;
	self.healthbar.hidewheninmenu = true;
	//self.healthbar.bar.foreground = 1;
	self.healthbar.bar.hidewheninmenu = true;
	
	level waittill("match_end");
	self.healthbar.bar destroy();
	self.healthbar destroy();
}

healthbar_color_manage()
{
	value = self.conquest_health;
	//define what colors to use
	color_green = []; //250
	color_green[0] = 0.0;
	color_green[1] = 1.0;
	color_green[2] = 0.0;
	color_lime = [];
	color_lime[0] = 0.5;
	color_lime[1] = 1.0;
	color_lime[2] = 0.0;
	color_yellow = [];
	color_yellow[0] = 1.0;
	color_yellow[1] = 1.0;
	color_yellow[2] = 0.0;
	color_orange = [];
	color_orange[0] = 1.0;
	color_orange[1] = 0.5;
	color_orange[2] = 0.0;
	color_red = []; //0
	color_red[0] = 1.0;
	color_red[1] = 0.0;
	color_red[2] = 0.0;
	//default color
	SetValue = [];
	SetValue[0] = color_green[0];
	SetValue[1] = color_green[1];
	SetValue[2] = color_green[2];
	//define where the non blend points are	
	green = self.conquest_maxhealth_value;
	lime = 175;
	yellow = 125;
	orange = 75;
	red = 0;
	iPercentage = undefined;
	difference = undefined;
	increment = undefined;
	if ( (value < green) && (value >= lime) )
	{
		iPercentage = int( (value - green) * (100 / (lime - green) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_lime[colorIndex] - color_green[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_green[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value < lime) && (value >= yellow) )
	{
		iPercentage = int( (value - lime) * (100 / (yellow - lime) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_yellow[colorIndex] - color_lime[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_lime[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value < yellow) && (value >= orange) )
	{
		iPercentage = int( (value - yellow) * (100 / (orange - yellow) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_orange[colorIndex] - color_yellow[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_yellow[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value < orange) && (value >= red) )
	{
		iPercentage = int( (value - orange) * (100 / (red - orange) ) );
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			difference = (color_red[colorIndex] - color_orange[colorIndex]);
			increment = (difference / 100);
			SetValue[colorIndex] = color_orange[colorIndex] + (increment * iPercentage);
		}
	}
	else if ( (value <= red) )
	{
		for ( colorIndex = 0 ; colorIndex < SetValue.size ; colorIndex++ )
		{
			SetValue[colorIndex] = color_red[colorIndex];
		}
	}
	self.healthbar.bar.color = (SetValue[0], SetValue[1], SetValue[2]);
}


hideshow_health_Bar( arg )
{
	if(arg == 1)
	{
		self.healthbar.bar.alpha = 1;
		self.healthbar.alpha = 0.5;
	}
	else
	{
		self.healthbar.bar.alpha = 0;
		self.healthbar.alpha = 0;
	}
}

// ==== Fake Player NPC Spawn =====

spawn_player_death_npc(dont_kill)
{
	fake_player = getent( "player_npc_spawner" , "targetname") stalingradspawn();
	wait 0.05;
	fake_player.name = "";
	fake_player.ignoreme = true;
	fake_player.ignoreall = true;
	fake_player.a.pose = level.player GetStance();
	fake_player.cq_team = level.player.cq_team;
	fake_player bot_select_class(level.player.cq_class_id,1); //set_bot_class handles giving player weapons to playerbot.
	fake_player force_teleport_local(level.player.origin , level.player.angles);
	if( !( isdefined( dont_kill ) ) )
		fake_player dodamage(100000, fake_player.origin);
}

// ##################################################
// ########### 5) MATCH LOGIC #######################
// ##################################################

setup_match()
{
	level.end_condition = ""; //TIME, FLAG, POINTS
	
	level.victorious_team = "";
	
	thread match_point_end();
	thread match_flag_end();
	thread match_time_end();
}





match_point_end()
{
	level endon("match_end_time");
	level endon("match_end_flags");
	level endon("match_flags_cancel_others");
	wait 0.05; // to make sure that points are set
	while(1)
	{
		if( level.team_axis.points == 0 && level.team_allies.points > 0)
		{
			level.end_condition = "points";
			thread match_end_allies();
			break;
		}	
		else if( level.team_allies.points == 0 && level.team_axis.points > 0)
		{
			level.end_condition = "points";
			thread match_end_axis();
			break;
		}	
		wait 0.05;
	}
	level notify("match_end_points");	
}

match_flag_end()
{
	level endon("match_end_points");
	level endon("match_end_time");
	
	level waittill("spawn_bots");
	wait 0.1;
	level.end_remove_points = 1;
	while(1)
	{
		if( level.flags.size == level.flags_allies.size && level.flags_axis.size == 0 && level.team_axis.bots_spawned == 0 )
		{
			level notify("match_flags_cancel_others");
			set_flag_end_remove_points(level.team_axis.points);
			level notify("point_countdown_started");
			while( level.team_axis.points > 0 )
			{	
				level.team_axis.points = level.team_axis.points-level.end_remove_points;
				wait 0.05;
			}
			level.end_condition = "flags";
			thread match_end_allies();
			break;
		}	
		else if( level.flags.size == level.flags_axis.size && level.flags_allies.size == 0 && level.team_allies.bots_spawned == 0 )
		{
			level notify("match_flags_cancel_others");
			set_flag_end_remove_points(level.team_allies.points);
			level notify("point_countdown_started");
			while( level.team_allies.points > 0 )
			{
				level.team_allies.points = level.team_allies.points-level.end_remove_points;
				wait 0.05;
			}			
			level.end_condition = "flags";
			thread match_end_axis();
			break;
		}	
		wait 0.05;
	}	
	level notify("match_end_flags");
}

set_flag_end_remove_points(points)
{
	level.end_remove_points = 1; // 400 points takes around 20 seconds to reduce to 0

	if(points>499)
		level.end_remove_points = 2; // 900 points takes around 22 seconds to reduce to 0
	
	if(points>999)
		level.end_remove_points = 4; // 1400 points takes around 18 seconds to reduce to 0
	
	if(points>1499)
		level.end_remove_points = 5; // 1900 points takes around 18 seconds to reduce to 0
	
	if(points>1999)
		level.end_remove_points = 6; // 2400 points takes around 20 seconds to reduce to 0
	
	if(points>2499)
		level.end_remove_points = 8; // 2900 points takes around 18 seconds to reduce to 0
	
	//iprintlnbold(level.end_remove_points);
}

match_time_end()
{
	level endon("match_end_points");
	level endon("match_end_flags");
	level endon("match_flags_cancel_others"); // When this is not commented: when the time ends before the flag->point elimination loop ends it will be match end because of time not flags.

	
	if( level.match_time < 0)
		return;
		
	level.match_time_count = level.match_time;
	level waittill("player_selected_team");

	thread match_time_out();	
	wait level.match_time;
	
	level notify("match_end_time");
	
	level.end_condition = "time";

	if( level.team_allies.points == level.team_axis.points )
		thread match_end_tie();
	else if( level.team_allies.points > level.team_axis.points )
		thread match_end_allies();
	else if( level.team_allies.points < level.team_axis.points )
		thread match_end_axis();
}

match_time_out()
{
	level endon("match_end");
	level endon("match_end_points");
	level endon("match_end_flags");
	level endon("match_flags_cancel_others");
	thread match_time_count();
	while(1)
	{
		if( level.match_time_count < 60 )
			break;
		wait 0.05;
	}
	thread timeout_text();
	thread play_music_stop_prev("conquest_time_running_out");
	while(1)
	{
		if( level.match_time_count < 30 && level.match_time_count > 10 )
		{
			level.player thread play_sound_on_entity ( "time_sec_tick" );
			wait 1;
		}
		if( level.match_time_count < 11 && level.match_time_count > 0)
		{
			level.player thread play_sound_on_entity ( "time_sec_tick" );
			wait 0.5;
		}
		if( level.match_time_count < 1 )
			break;
		wait 0.05;
	}	
}

match_time_count()
{
	level endon("match_end");
	level endon("match_end_points");
	level endon("match_end_flags");
	level endon("match_flags_cancel_others");
	wait 1;
	while(1)
	{
		level.match_time_count = level.match_time_count-1;
		if( level.match_time_count < 1 )
			break;
		wait 1;
	}
}

timeout_text()
{
	level endon("match_end");
	timeout = create_end_hud_text( 0, -80, (1,1,1), &"CONQUEST_TIMELOW", 1.5 );	
	timeout thread timeout_text_destroy();
	timeout thread fade_overlay_local(1,0.5);
	wait 4;
	timeout thread fade_overlay_local(0,2);
	wait 2.1;
	timeout destroy();
	level notify("timeout_text_done");
}

timeout_text_destroy()
{
	level endon("timeout_text_done");
	level waittill("match_end");
	self destroy();
}

match_end_tie()
{
	thread match_end_HUD("tie");
	level.victorious_team = "neutral";
}
match_end_allies()
{
	thread match_end_HUD("allies");
	level.victorious_team = "allies";
}
match_end_axis()
{
	thread match_end_HUD("axis");
	level.victorious_team = "axis";
}

match_end_HUD(vic_team,wincondition)
{
	wait 2; // to "feel" the ending :P
	level notify("match_end");
	level notify("destroy_team_hud");
	level notify("destroy_all_flag_hud");
	level notify("destroy_flag_hud");
	thread simple_hud_hide();
	fade_time = 2;
	setblur(4,fade_time);

	wincondition = "";
	wincondition_plr_win = "";
	wincondition_plr_def = "";

	if(level.end_condition == "points")
	{
		wincondition_plr_win = &"CONQUEST_MATCH_POINTS_WIN";
		wincondition_plr_def = &"CONQUEST_MATCH_POINTS_DEF";
	}
	else if(level.end_condition == "flags")
	{
		wincondition_plr_win = &"CONQUEST_MATCH_FLAGS_VIC";
		wincondition_plr_def = &"CONQUEST_MATCH_FLAGS_DEF";	
	}
	else if(level.end_condition == "time")
	{
		wincondition = &"CONQUEST_MATCH_TIME_UP";
		wincondition_plr_win = &"CONQUEST_MATCH_TIME_WIN";
		wincondition_plr_def = &"CONQUEST_MATCH_TIME_DEF";
	}
	
	if(vic_team == "tie")
	{
		icon_size = 80;
		custom_height = 80;
		heighten = -40;
		tie_icon_distance = 80;
		icon1 = create_end_hud_icon( -1*tie_icon_distance, heighten, icon_size, icon_size, level.ally_team_icon );
		icon2 = create_end_hud_icon( tie_icon_distance, heighten, icon_size, icon_size, level.axis_team_icon );
		match_end_title = create_end_hud_text( 0, -1*icon_size+heighten, (1,1,1), &"CONQUEST_MATCH_TIE");		
		match_end_team1_title = create_end_hud_text( -1*tie_icon_distance, icon_size+heighten, level.allies_color, &"CONQUEST_ALLIES");		
		match_end_team2_title = create_end_hud_text( tie_icon_distance, icon_size+heighten, level.axis_color, &"CONQUEST_AXIS");
		match_condition = create_end_hud_text( 0, icon_size+heighten+30, (1,1,1), wincondition, 2);	
		match_sub_condition = create_end_hud_text( 0, icon_size+heighten+60, (1,1,1), &"CONQUEST_MATCH_TIE_REASON", 2 );

		icon1 thread fade_overlay_local(1,2);
		icon2 thread fade_overlay_local(1,2);
		match_end_title thread fade_overlay_local(1,2);
		match_end_team1_title thread fade_overlay_local(1,2);
		match_end_team2_title thread fade_overlay_local(1,2);
		match_condition thread fade_overlay_local(1,2);
		match_sub_condition thread fade_overlay_local(1,2);
		
		wait 2.5;
		
		thread show_end_match_player_stats(icon_size,heighten);	
	
		/*
		// oldstyle
		icon1 = create_end_hud_icon(-100,0,100,100,level.ally_team_icon);
		icon2 = create_end_hud_icon(100,0,100,100,level.axis_team_icon);
		match_end_title = create_end_hud_text( 0, -100, (1,1,1), &"CONQUEST_MATCH_TIE");		
		match_end_team1_title = create_end_hud_text( -100, 100, level.allies_color, &"CONQUEST_ALLIES");		
		match_end_team2_title = create_end_hud_text( 100, 100, level.axis_color, &"CONQUEST_AXIS");
		match_condition = create_end_hud_text( 0, 140, (1,1,1), wincondition, 2);	
		match_sub_condition = create_end_hud_text( 0, 170, (1,1,1), &"CONQUEST_MATCH_TIE_REASON", 2 );

		icon1 thread fade_overlay_local(1,2);
		icon2 thread fade_overlay_local(1,2);
		match_end_title thread fade_overlay_local(1,2);
		match_end_team1_title thread fade_overlay_local(1,2);
		match_end_team2_title thread fade_overlay_local(1,2);
		match_condition thread fade_overlay_local(1,2);
		match_sub_condition thread fade_overlay_local(1,2);
		*/
		
	}
	else if(vic_team == "allies")
	{
		if(level.player.cq_team == "allies")
		{
			if(level.end_condition == "time")
				thread match_end_hud_group( level.ally_team_icon, &"CONQUEST_MATCH_VICTORY", &"CONQUEST_MATCH_ALLIES_WIN", level.allies_color , wincondition , wincondition_plr_win );
			else
				thread match_end_hud_group( level.ally_team_icon, &"CONQUEST_MATCH_VICTORY", &"CONQUEST_MATCH_ALLIES_WIN", level.allies_color , wincondition_plr_win , &"CONQUEST_NULL");
		}
		else if(level.player.cq_team == "axis")
		{
			if(level.end_condition == "time")
				thread match_end_hud_group( level.ally_team_icon, &"CONQUEST_MATCH_DEFEAT", &"CONQUEST_MATCH_ALLIES_WIN", level.allies_color , wincondition , wincondition_plr_def );
			else
				thread match_end_hud_group( level.ally_team_icon, &"CONQUEST_MATCH_DEFEAT", &"CONQUEST_MATCH_ALLIES_WIN", level.allies_color , wincondition_plr_def , &"CONQUEST_NULL" );
		}
	}
	else if(vic_team == "axis")
	{
		if(level.player.cq_team == "axis")
		{
			if(level.end_condition == "time")
				thread match_end_hud_group( level.axis_team_icon, &"CONQUEST_MATCH_VICTORY", &"CONQUEST_MATCH_AXIS_WIN", level.axis_color , wincondition , wincondition_plr_win );
			else
				thread match_end_hud_group( level.axis_team_icon, &"CONQUEST_MATCH_VICTORY", &"CONQUEST_MATCH_AXIS_WIN", level.axis_color , wincondition_plr_win , &"CONQUEST_NULL"  );
		}
		else if(level.player.cq_team == "allies")
		{
			if(level.end_condition == "time")
				thread match_end_hud_group( level.axis_team_icon, &"CONQUEST_MATCH_DEFEAT", &"CONQUEST_MATCH_AXIS_WIN", level.axis_color , wincondition , wincondition_plr_def );
			else
				thread match_end_hud_group( level.axis_team_icon, &"CONQUEST_MATCH_DEFEAT", &"CONQUEST_MATCH_AXIS_WIN", level.axis_color , wincondition_plr_def , &"CONQUEST_NULL" );
		}
	}
	
	wait 4;
	level.player openMenu("conquest_gameover");
	level.player waittill("menuresponse", menu, response);
	if(response == "quitlvl" )
		changelevel("");
}

match_end_hud_group( icon, win_def_text, win_team_text, win_team_color, end_reason, end_reason2)
{
	// custom_height = 100; // default
	//icon_size = 100; // default
	icon_size = 80;
	custom_height = 80;
	heighten = -40;
	icon = create_end_hud_icon(0,heighten,icon_size,icon_size, icon );
	match_end_title = create_end_hud_text( 0, -1*icon_size+heighten, (1,1,1), win_def_text );		
	match_end_team_title = create_end_hud_text( 0, icon_size+heighten, win_team_color, win_team_text );	
	match_condition = create_end_hud_text( 0, icon_size+heighten+30, (1,1,1), end_reason, 2 );	
	match_sub_condition = create_end_hud_text( 0, icon_size+heighten+60, (1,1,1), end_reason2, 2 );
	icon thread fade_overlay_local(1,2);
	match_end_title thread fade_overlay_local(1,2);
	match_end_team_title thread fade_overlay_local(1,2);
	match_condition thread fade_overlay_local(1,2);
	match_sub_condition thread fade_overlay_local(1,2);
	
	wait 2.5;
	thread show_end_match_player_stats(icon_size,heighten);	
	
/*
	// old style
	icon = create_end_hud_icon(0,0,100,100, icon );
	match_end_title = create_end_hud_text( 0, -100, (1,1,1), win_def_text );		
	match_end_team_title = create_end_hud_text( 0, 100, win_team_color, win_team_text );	
	match_condition = create_end_hud_text( 0, 140, (1,1,1), end_reason, 2 );	
	match_sub_condition = create_end_hud_text( 0, 170, (1,1,1), end_reason2, 2 );
	icon thread fade_overlay_local(1,2);
	match_end_title thread fade_overlay_local(1,2);
	match_end_team_title thread fade_overlay_local(1,2);
	match_condition thread fade_overlay_local(1,2);
	match_sub_condition thread fade_overlay_local(1,2);

*/
}

show_end_match_player_stats(icon_size,heighten)
{
	plr_kills = create_end_hud_text( 0, icon_size+heighten+90, (1,1,1), &"CONQUEST_KILLS", 1.5, level.player.conquest_kills );
	plr_deaths = create_end_hud_text( 0, icon_size+heighten+110, (1,1,1), &"CONQUEST_DEATHS", 1.5, level.player.conquest_deaths );
	plr_caps = create_end_hud_text( 0, icon_size+heighten+130, (1,1,1), &"CONQUEST_CAPTURES", 1.5, level.player.conquest_captures );
	plr_kills thread fade_overlay_local(1,2);
	plr_deaths thread fade_overlay_local(1,2);
	plr_caps thread fade_overlay_local(1,2);
}


create_end_hud_text( x, y, color, text, scale, value)
{
	end_match_text = newHudElem();
	end_match_text.alignX = "center";
	end_match_text.alignY = "middle";
	end_match_text.horzAlign = "center";
	end_match_text.vertAlign = "middle";
	end_match_text.x = x;
	end_match_text.y = y; 
	end_match_text.color = color;
	end_match_text.font = "objective"; 
	end_match_text.alpha = 0;
	end_match_text.sort = -1;
	end_match_text.foreground = 1;
	end_match_text.hidewheninmenu = false;
	
	if(isdefined(scale))
		end_match_text.fontScale = scale; 
	else
		end_match_text.fontScale = 3; 
		
	if(isdefined(value))
		end_match_text setvalue(value);
	
	end_match_text.label = text; 
	return end_match_text;
	

}

create_end_hud_icon( x, y, w, h, shader)
{
	end_team_icon = newHudElem();
	end_team_icon.alignX = "center";
	end_team_icon.alignY = "middle";
	end_team_icon.horzAlign = "center";
	end_team_icon.vertAlign = "middle";
	end_team_icon.x = x;
	end_team_icon.y = y; 
	end_team_icon.width = w;
	end_team_icon.height = h;
	end_team_icon.alpha = 0;
	end_team_icon.sort = -1;
	end_team_icon.foreground = 1;
	end_team_icon.hidewheninmenu = false;
	end_team_icon.alpha = 1;
	end_team_icon setShader( shader, w, h );
	return end_team_icon;
}

// ##################################################
// ############# 6) MUSIC #########################
// ##################################################

conquest_music()
{
	level waittill("player_selected_team");
	thread music_conquest_start();
	thread music_conquest_end();
	thread music_flag_taken_update();
	thread music_flag_lost_update();
	thread music_lowpoints_update();
}

music_conquest_start()
{	
	level.player waittill("player_spawned");
	if(level.player.cq_team == "allies")
		play_music_stop_prev("conquest_ally_spawn");
	else if(level.player.cq_team == "axis")
		play_music_stop_prev("conquest_axis_spawn");
}

music_conquest_end()
{	
	level waittill("match_end");
	if( level.player.cq_team == "allies" )
	{
		if( level.victorious_team == "allies" )
			play_music_stop_prev("conquest_ally_victory");
		else if( level.victorious_team == "axis" )
			play_music_stop_prev("conquest_ally_defeat");
		else if( level.victorious_team == "neutral" )
			play_music_stop_prev("conquest_tie");
	}
	else if( level.player.cq_team == "axis" )
	{
		if( level.victorious_team == "axis" )
			play_music_stop_prev("conquest_axis_victory");
		else if( level.victorious_team == "allies" )
			play_music_stop_prev("conquest_axis_defeat");
		else if( level.victorious_team == "neutral" )
			play_music_stop_prev("conquest_tie");
	}	
}

music_flag_taken_update()
{
	level endon("match_end");
	while(1)
	{
		if( level.player.cq_team == "allies" )
		{
			level waittill("allies_captured_flag");	
			level.player thread play_sound_on_entity ( "conquest_point_captured" );
		}
		else if( level.player.cq_team == "axis" )
		{
			level waittill("axis_captured_flag");	
			level.player thread play_sound_on_entity ( "conquest_point_captured" );
		}			
		wait 0.05;
	}
}

music_flag_lost_update()
{
	level endon("match_end");
	while(1)
	{
		if( level.player.cq_team == "allies" )
		{
			level waittill("allies_lost_flag");	
			level.player thread play_sound_on_entity ( "conquest_point_lost" );
		}
		else if( level.player.cq_team == "axis" )
		{
			level waittill("axis_lost_flag");	
			level.player thread play_sound_on_entity ( "conquest_point_lost" );
		}			
		wait 0.05;
	}
}

music_lowpoints_update()
{
	level endon("match_end");
	level waittill("point_countdown_started");
	play_music_stop_prev("conquest_points_low");
}

play_music_stop_prev(music)
{
	level notify("newconqmus");
	level endon("newconqmus");
	musicstop();
	wait 0.1;
	musicplay(music);
}

// ##################################################
// ############# 7) HUD TOOLS #########################
// ##################################################

hud_overlay_local( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.sort = 1;
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	return overlay;
}

hud_message_local( text, time )
{
	level notify("hud_message_destroy");
	level endon("hud_message_destroy");
	
	hud_message = NewHudElem();
	hud_message.alignX = "center";
	hud_message.alignY = "middle";
	hud_message.horzAlign = "center";
	hud_message.vertAlign = "middle";
	hud_message.x = 0;
	hud_message.y = -100; 
	hud_message.foreground = true;
	hud_message.fontScale = 2;
	hud_message.alpha = 1;
	hud_message setText(text);
	
	hud_message thread message_destroy();
	
	if(isdefined(time))
		wait time;
	else
		wait 3.5;

	hud_message thread fade_overlay_local( 0, 1);
	wait 1.1; 
	hud_message destroy();	
}

message_destroy()
{
	self endon("death");
	level waittill("hud_message_destroy");
	self destroy();	
}

// Bar Local
hud_bar_local( shader, BGshader, width, height )
{
	barElem = newHudElem();
	barElem.x = 0 + 2;
	barElem.y = 0 + 2;
	barElem.alignX = "left";
	barElem.horzAlign = "left";
	barElem.frac = 0.25;
	barElem.shader = shader;
	barElem.sort = -1;
	//barElem.foreground = 1;
	barElem.hidewheninmenu = true;
	barElem setShader( shader, width - 2, height - 2 );

	barElemBG = newHudElem();
	barElemBG.elemType = "bar";
	barElemBG.x = 0;
	barElemBG.y = 0;
	barElemBG.width = width;
	barElemBG.height = height;
	barElemBG.xOffset = 0;
	barElemBG.yOffset = 0;
	barElemBG.padding = 2;
	barElemBG.bar = barElem;
	barElemBG.children = [];
	barElemBG.sort = -2;
	//barElemBG.foreground = 1;
	barElemBG.hidewheninmenu = true;
	barElemBG.alpha = 0.5;
	barElemBG maps\_hud_util::setParent( level.uiParent );
	barElemBG setShader( BGshader, width, height );
	
	return barElemBG;
}

// Fade
fade_overlay_local( target_alpha, fade_time )
{
	self fadeOverTime( fade_time );
	self.alpha = target_alpha;
	wait fade_time;
}

// Hud hide
simple_hud_hide()
{
	setsaveddvar( "compass", 0 ); 
	setsaveddvar( "hud_showstance", "0" ); 
	SetSavedDvar( "ammoCounterHide", "1" );
}

simple_hud_show()
{
	setsaveddvar( "compass", 1 ); 
	setsaveddvar( "hud_showstance", "1" ); 
	SetSavedDvar( "ammoCounterHide", "0" );
}

//Force teleport local
force_teleport_local( origin, angles )
{
	linker = spawn( "script_model", origin );
	linker setmodel( "fx" );
	self linkto( linker );
	self teleport( origin, angles );
	self unlink();
	linker delete();
}

rotateToPos( position, time, accel, deccel)	
{	
	disOrgs = vectornormalize( self.origin - position );
	dirAng = vectortoangles( -1*disOrgs );
	if(isdefined(time))
	{
		if( isdefined(accel) )
		{
			if( isdefined(deccel) )
				self rotateto( (dirAng[0],dirAng[1],dirAng[2]) , time, accel, deccel);
			else
				self rotateto( (dirAng[0],dirAng[1],dirAng[2]) , time, accel);
		}
		else
			self rotateto( (dirAng[0],dirAng[1],dirAng[2]) , time);
	}
	else
	{
		self rotateto( (dirAng[0],dirAng[1],dirAng[2]) , 0.1);
	}
}



