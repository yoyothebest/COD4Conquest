#include "ui/menudef.h"
#include "ui_mp/common_macro.inc"
#define OPTIONS_STYLE			1
#include "ui_mp/menustyle.inc"
#include "ui/choices_setup_common.menu"


/*
		// ===== MATCH OPTIONS ================================================================================
		#undef CHOICE_SIZE_X
		#undef CHOICE_SIZE_Y
		#define CHOICE_SIZE_X			120 // defines the match settings button width
		#define CHOICE_SIZE_Y			22 // (def:22) defines the match settings button height (dont touch that its default and its fine.)
		
		#undef CHOICE_X_START
		//#define CHOICE_X_START			-30 // is added to choice_x_spacing to move the element towards the right
		#define CHOICE_X_START			135 // is added to choice_x_spacing to move the element towards the right
		
		#undef CHOICE_Y_START			// default: 82
		#define CHOICE_Y_START			10 // determines the height start position of the match elements.
		//#define CHOICE_Y_START			10 // determines the height start position of the match elements.
		//#define CHOICE_Y_START			82 
		
		#undef CHOICE_X_SPACING
		//#define CHOICE_X_SPACING		285 // Determines how far right the match settings stuff will be aligned from the levels.
		#define CHOICE_X_SPACING		265 // Determines how far right the match settings stuff will be aligned from the levels.
		
	


{
	menuDef
	{
		name			"match_settings"
		fullScreen		0
		rect			0 0 640 480
		focusColor		COLOR_FOCUSED
		soundloop		""
		onOpen
		{
			setLocalVarBool ui_hideBack 1;
		}
		onClose
		{
			setLocalVarBool ui_hideBack 0;
		}
		onESC
		{
			close self;
		}	
	
*/
	//To work on player given match settings:
		CHOICE_SECTION_TITLE( 21, "@CONQUEST_MATCH_SETTINGS" )
		CHOICE_DVARFLOATLIST(22,"@CONQUEST_MATCH_TIME",cq_time,
		{ 
		"@CONQUEST_UNLIMITED" -2	
		"@CONQUEST_M5" 300 	
		"@CONQUEST_M10" 600 
		"@CONQUEST_M15" 900 
		"@CONQUEST_M20" 1200 
		"@CONQUEST_M25" 1500
		"@CONQUEST_M30" 1800 
		},;)
		CHOICE_DVARFLOATLIST(23,"@CONQUEST_TEAM_POINTS",cq_teampoints,
		{ 
		"@CONQUEST_N100" 100 
		"@CONQUEST_N200" 200 
		"@CONQUEST_N300" 300 
		"@CONQUEST_N400" 400 
		"@CONQUEST_N500" 500 
		"@CONQUEST_N600" 600
		"@CONQUEST_N700" 700 
		"@CONQUEST_N800" 800 
		"@CONQUEST_N900" 900 
		"@CONQUEST_N1000" 1000
		"@CONQUEST_N1500" 1500
		"@CONQUEST_N2000" 2000
		"@CONQUEST_N2500" 2500
		"@CONQUEST_N3000" 3000
		},;)
		CHOICE_DVARFLOATLIST(24,"@CONQUEST_MAX_BOTS_PER_TEAM",cq_maxteambots,
		{ 
		"@CONQUEST_N1" 1 
		"@CONQUEST_N2" 2 
		"@CONQUEST_N3" 3 
		"@CONQUEST_N4" 4 
		"@CONQUEST_N5" 5 
		"@CONQUEST_N6" 6 
		"@CONQUEST_N7" 7 
		"@CONQUEST_N8" 8 
		"@CONQUEST_N9" 9 
		"@CONQUEST_N10" 10 
		"@CONQUEST_N11" 11 
		"@CONQUEST_N12" 12 
		"@CONQUEST_N13" 13 
		"@CONQUEST_N14" 14 
		"@CONQUEST_N15" 15 
		},;)

	//}
//}


















