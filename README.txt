Call of Duty 4: Conquest Mode OPEN SOURCE FILES
Date: March 31, 2021.
Development Time: 14 Days.
By SPi.

IMPORTANT NOTE:
THESE ARE NOT PLAYABLE FILES!!! 
YOU CAN'T PLAY THE MODE IF YOU DON'T HAVE COD4 MOD TOOLS AND THE KNOWLEDGE TO COMPILE THE FILES.

MODDER NOTE:
IT IS ASSUMED THAT YOU KNOW HOW TO USE CALL OF DUTY 4 MOD TOOLS 
AND THAT YOU HAVE THE MOD TOOLS SET UP AND READY TO USE. 
THIS GUIDE IS NOT FOR BEGINNERS! YOU MUST HAVE EXPERIENCE AND SKILL
WITH SETTING UP SINGLEPLAYER MAPS AND CODING THEM.

TEXT CATEGORIES:
1) Info
2) Gameplay Notes
3) OPEN SOURCE INSTRUCTIONS <- HOW TO MAKE YOUR OWN CONQUEST MAP!!!

SPi's YouTube PLEASE SUBSCRIBE!: https://www.youtube.com/channel/UCYpYA90Nr8C1qQnUrTlbCyA
MOD's MODDB Page: https://www.moddb.com/mods/call-of-duty-4-conquest-mode-open-source
Join SPi's Discord Server: https://discord.gg/Rs68sr4

###################
1) INFO
###################

Conquest Mode is a SINGLEPLAYER Custom Game Mode, created with the official Call of Duty 4 Mod Tools.
It is a recreation of a combination of Multiplayer modes Domination from Call of Duty and 
Conquest from battlefield games only on Singleplayer with NPCs/Bots.

The purpose is to simulate the classic old school Battlefield Conquest mode that we could play offline with bots.
The mode will also be Open Source and users will be able to customize and change the mode to their liking or even expand it
and improve it further from what I've provided and come up with even better variations.
The ability to create custom maps is also possible as I did my best to make the mode accessible from
mod tool users so they can easily apply it to any map they want using some prefabs and a couple of
script calls in their map's code. But that will come with the main release.

###################
2) GAMEPLAY NOTES
###################

What is Conquest Mode and how is it played?

The game mode is easy.
The maps have control-points or flags scattered in them.
There are two teams in each map. Each team starts with one flag which works as a spawn point.
Bots and player can go to capture flags. If they capture all flags and kill all enemies they win.
The teams also have points that work as remaining spawn points.
When a team member dies, either player or BOT, one team point is reduced.
If all team points are depleted, bots can't respawn.
And if all team members die while points are depleted the team loses and the other team wins.
The player can spawn regardless for gameplay convenience.

I've implemented a custom menu that allows you to chose a map, and match settings to play however you like.
In the maps menu, you can find some match settings.
These match settings allow you to set up matches in the map you chose with your own combination of settings.
These settings are: 
Match Time from 5,10,15,20,25,30 minutes and then to Unlimited.
Team Points from 100 to 1000 each change adds 100 until 1000.
Max Team Bots from 1 to 15. It is recommended to play with few bots for better experience.
If you wish to play chaotic battles, try 15vs15 it will work. 
However unexpected problems are possible to occure.

There are 3 maps in this version:
Basic: Just a cubic map for testing and sandbox matches.
Welltown: The good old Welltown from my Survival mode now in Conquest.
Outskirts: A brand new map created specifically for Conquest Mode. Not much detail added in it, but it works alright for what it is.

I don't plan to work on this mod a lot more. 
It will be open source so modders can add their own maps or even improve the mod any way they want.
I want to focus on Rooftops 2 and provide the super experience i prepare for YEARS.
If you don't know what Rooftops 2 is come in my discord and read some of my updates there.

Have fun with Conquest mode, I hope people will enjoy their time with it.


#########################
#########################
3) OPEN SOURCE INSTRUCTIONS
#########################
HOW TO MAKE YOUR OWN CONQUEST MAP!
#########################
#########################

----------------------------------------------
-------------- SPI APP  NOTE -----------------
----------------------------------------------

To make all this easier I developed a tool that helps with organising this stuff A LOT.
SPiApp2 is going to make your life A LOT more easier while using cod4 mod tools.
It has nummerous shortcuts that save a LOT of time and it saved me in terms of organizing my mods.
It's created by Scillman with my instructions and directions.

The Create Map function is the most useful, it generates ready to compile files for a cod4 SP map
using template files and you just need to put a file name for it.

You can select template type or even make your own by looking inside the template foler of the app.
I included a template for the CONQUEST MODE which will allow you to create conquest template maps with a click of a button!

Of course, capturing the minimap image will be necessary from scratch, but it will overall help with the production.
More info in the SPIAPP GUIDE.txt file in the SPiAppTool folder where i explain the whole proceedure with much simpler steps since spiapp2 simplifies everything.

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

Welcome to Call of Duty 4 Conquest Mode OPEN SOURCE FILES.

This guide will show you everything you need to know on how to use these files to make your own Conquest Contnet.
First of all let's list the files of this package:

Files...

####### INSTALLATION ###########

Copy the folders...
Paste them in your COD4 directory.

####### HOW TO SET UP A MAP ###########

First of all I will explain how conquest mode maps are set up:

You can always look and examine the source files of the maps i provided
to see how everything is structured and guide you through in case this
guide below won't help you. And don't forget to check the SPiApp2.
More info in the bottom of this file...

As always, make a new singleplayer map in Radiant.
Assuming the map is completed and can compile wihtout problems,
you now have to place a couple of ents for the conquest mode to work.

--------------FLAGS-----------------
Flags are easy to place yet can be tricky sometimes.

Create a script_origin

Then give it:
Key: targetname
Value: flag

And Also:
Key: radius
Value: (a number indicating the capture radius of the flag)
You can see the radius previewed in radiant so you can easily tell how big it is and how much you want it to be.
Make sure the radius of each flag isn't touching other flags radius and that it isn't smaller than 1 unit big.

That's it. Now you have a flag ready for conquest mode.
A flag pole model will spawn in this position and the flag model will be adjusted automatically.
Everything else will be handled by the conquest mode.

However, we're not done yet.
We need more than one flag in the map... otherwise it won't work.
A minimum of 3 flags is suggested. If you put less than 2 it will be buggy and probably put lots of errors.
You can put 2 flags but it's not suggested because the gameplay will be too linear.

To put more flags just do the same we did before.
Like I said earlier, make sure their radius aren't overlaping.

Note that the order you place the flags will indicate the letter ID of the flags in the minimap.
I know it's not a great way and it can be messed up in later compiles, but i couldn't make a system
where we can manually tell which flag is what letter. I'm afraid I couldn't do that and we have to deal with what we have now.
Hope someone fixes this since it's open source.

--------------SPAWNS-----------------

We're done with the flags but now we need spawns for each flag.
Without spawns player and NPCs won't be able to spawn in the map and no game can be done.

Spawns work with flags, they can't work individually. Each spawn must be connected to a flag or else it won't work.
To place a spawn simply create a script_origin and place it where you want your spawn to be.
It's usually a good idea to put spawns inside the radius of the trigger they are connected to.

Place as many spawns as you want but make sure they TWO OR MORE. Never one alone. It doesn't seem to work well.
After you are done placing the spawns of a flag its time to connect them to the flag.
To do this properly, select all of the spawns and give them a targetname of your liking
let's say for example: flag1_spawns
having done that, select the FLAG script_origin and put these key and values:
key: target
value: flag1_spawns (or the targetname you have to the spawns)

If everything is done properly the flag should have lines going to the spawns which means theyre connected.

--------------PLAYER SPAWN-----------------

For the conquest mode we don't need the info_player_spawn
It's included in one of my prefabs for the mode.

add a misc_prefab of this path:
cod4/map_source/sp_conquest/top_down_org.map

This misc prefab has the player spawn ent and a script origin which will indicate where
the top down view of the map will be. It may take some tries to adjust the position.
Place that prefab above and angled downwards overlooking the map and it should be good.

-------------- NPC SPAWNS -----------------

We also need our global NPC spawns which are also a prefab I made.
add a misc_prefab of this path:
cod4/map_source/sp_conquest/cq_cod4_spawns.map
Place it somewhere in your map, preferably outside 
and not in a strange position for example inside walls and such.
The script will handle everything else.

Just in case you didn't know for NPCs to be able to walk on the map, 
you need to place pathnodes all over the place.
Hope you are familiar with these because they are essential in making SP maps with NPCs.
NPCs can't walk anywhere without them.

--------------MISC-----------------

You can also add the health and ammo crates as prefabs:
cod4/map_source/sp_conquest/crate_ammo.map
cod4/map_source/sp_conquest/crate_medic.map

It's good that you have at least a couple in your map.

-------------- FLAG POLES -----------------

Last thing we need to add is the flag pole clip prefab.
It is essential so player can't go through the flag.
NPCs may sometimes go through it but they will immediately go outside it.
It's a work around I made for pathfinding.
I know it's not perfect but it works for what it is.

add a misc_prefab of this path:
cod4/map_source/sp_conquest/flag_poles_clip_x12.map

And you should be alright.

####### MAP COMPILE ###########

Well done! We are done with Radiant!
You can now start compiling BSP and Reflections like you should already know.

Before we compile fast file we should add the necessary calls in our map's gsc code file.

A well laid code that works well with survival should look like this:

##########################################################################################
############################## CODE STARTS ############################################
##########################################################################################

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
	maps\_compass::setupMiniMap("compass_map_YOURMAPNAME"); // Assign the map material of your map.
	setsaveddvar( "compassmaxrange", 2000 );
}	

conquest_map_settings()
{
	// This must be called here whatsoever
	thread custom_match_flag_team(); 

	// This lets the _conquest.gsc know that you put your own match settings for the map.
	// level.custom_conquest_match_settings = 1; // Comment this or the whole function to allow default match settings to be applied.
	if( !(isdefined(level.custom_conquest_match_settings)))
		return;

	// Time
	level.match_time = 600; // MAX 1800
	// Bots
	level.max_team_bots = 10; // MAX 15
	level.max_bots = level.max_team_bots*2;
	// Teams
	points = 500; // MAX 1000
	level.max_team_points = points;
	level.team1_points = points;
	level.team2_points = points;
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
##########################################################################################
############################## CODE ENDED ############################################
##########################################################################################

I hope it's not too much to digest, it's overall simple if you know how to code and mod cod4.
The conquest mode's core is this file
cod4/raw/maps/_conquest.gsc
Here is where everything happens.
This code file contains all the logic that brings life to the mode.
As you can see the individual map code necessary is extremely short.
Everything else is handled by the _conquest.gsc

You might be wondering, why don't we load _conquest.gsc in our map's zone file?
That's because _conquest.gsc is loaded in our MOD.FF file because it's a common mod file.
To apply any changes in _conquest.gsc you must build fast file again.
mod.ff also loads all necessary assets from the game like models, weapons, materials and stuff
instead of loading them in each map from scratch.
That's quite an upgraded method since survival mode.

-------------- MOD BUILDING -----------------

We of course need to build the mod.ff for the mode to be ready to function in a map.
Also it's imperative that we build the IWD files too.

7za.exe NOTE:
You will need to have a copy of the 7za.exe application in your mod folder.
It's basically a very common Compression/Extraction software that is used for the
ZIP and RAR files but COD also uses it for IWD files which are basically files like ZIP and RAR.
The following step will REQUIRE a 7za.exe app file to be in your mod folder so it works successfully.
You can easily find it online and it's also probably provided with the mod tools.

Go to cod4/mods/sp_conquest folder.
there are 2 BAT files
make_IWD.bat
make_FF.bat
Run the IWD one first, and then the FF one.
These will basically build the mod FF and IWD files necessary for the mode's assets.
mod.ff is mainly what concerns you as a user because it loads the _conquest.gsc file.

I'll say it again so it's easier to remember.
YOU MUST BUILD MOD.FF FROM THE MOD FOLDER 
TO APPLY ANY NEW CHANGES MADE IN _conquest.gsc 

Having build our mod files, we are ready to test the map.

-------------- SOURCE FILES -----------------

I have included a GDT file for all the custom images that the mode needs.
It's best that you convert the materials for the conquest mode.
I already included the material files but if you see errors regarding the materials,
try to re-convert them.

BE CAFERFUL NOT TO RUN FULL CONVERTER.
It is important never to run it again 
after you did once when you set up the mod tools.

-------------- TESTING THE MAP -----------------

Compile fast file of your map, and run the Call of Duty 4 Singleplayer with Conquest Mode Mod (sp_conquest) enabled.
Load your map as you should already know how, and try your map out.
If everything done correctly your map should run with the conquest mode enabled.

-------------- MAKING YOUR OWN MINIMAP -----------------

The only issue you might be facing is the lack of minimap.
Creating a minimap is no easy task and it's something you must do on your own.
I will give you instructions but the execution must be done on your part.

First of all, you need to place two prefabs from the original mod tool prefabs in your map.

Go in your map in radiant and
add TWO misc_prefab of this path:
cod4/map_source/prefabs/minimap_corner.map

These two origins must be placed in a way that they form two opposite corners of a square over your map.
Confused yet?
You are basically placing two of four minimap corners with those two origins.
Of course these corners must be diagonal to eachother.
Place these corners in a way that the square they create from the top covers all of your playable area.
Always make sure that the square has equal sides for more accurate minimaps.
Hope it's not too confusing.

Next, compile the map fully, run map as developer and developer_script.
When map starts, put these two commands in console:

scr_minimap_height 100000
hit enter, then:
exec minimap
hit enter again.

Now you should have an overhead view of your map with a white border around the map area.
That's the square the two origins created for us. That will be the minimap size.
Print screen / screenshot what you see and use an image editing software to crop 
the minimap image you took JUST around the white borders.

Save the image as tga, dds or even jpg if you dont care about details,
make sure the image resolution is power of 2. 
Which means it must be a 512x512 or 1024x1024 or even 512x1024 and so on. 
Google what power of 2 resolutions are to get a better idea if you dont know.

Then add the image as a custom material in assets manager.
Load the material in your map's zone file like this:
material,my_maps_minimap
and finally, remember that line from the example code i show above?
maps\_compass::setupMiniMap("compass_map_YOURMAPNAME"); 
you guessed it. Replace compass_map_YOURMAPNAME with your minimap material name.

When you converted your material an image of that minimap should have been generated in cod4/raw/images
copy that iwi image file and put it in the images folder in our sp_conquest mod folder.
make_IWD.bat and it should be added in the mod.
Compile your map fast file again, and run the map.

If you did everything correctly, your new minimap should appear in the screen.

As you can see all this is a long and hard proceedure.
That's why I don't urge begnners to mess with these things.
If you made it this far and everything works as intended, very well done, i hope the result was satisfying.
And more importantly, have fun!




























 
