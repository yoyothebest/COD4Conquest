#define COMPASS_SIZE_SP		151
#define MINIMAP_X_SP        -138//-114    // 0
#define MINIMAP_Y_SP        12
#define MINIMAP_W_SP        125
#define	MINIMAP_H_SP        125

#define MINIMAP_RECT_4_3 	0 30 COMPASS_SIZE_SP COMPASS_SIZE_SP HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP //HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
#define MINIMAP_RECT 	0 0 COMPASS_SIZE_SP COMPASS_SIZE_SP HORIZONTAL_ALIGN_RIGHT VERTICAL_ALIGN_TOP //HORIZONTAL_ALIGN_LEFT VERTICAL_ALIGN_TOP
#define MINIMAP_ORIGIN  6 6

#define VIS_4_3_COMPASS						dvarstring( r_mode ) == "640x480" || \
											dvarstring( r_mode ) == "720x480" || \
											dvarstring( r_mode ) == "720x576" || \
											dvarstring( r_mode ) == "800x600" || \
											dvarstring( r_mode ) == "1024x768" || \
											dvarstring( r_mode ) == "1152x864" || \
											dvarstring( r_mode ) == "1280x960" || \
											dvarstring( r_mode ) == "1280x1024" || \
											dvarstring( r_mode ) == "1600x1024" 
											
#define VIS_NORMAL_COMPASS						dvarstring( r_mode ) != "640x480" && \
											dvarstring( r_mode ) != "720x480" && \
											dvarstring( r_mode ) != "720x576" && \
											dvarstring( r_mode ) != "800x600" && \
											dvarstring( r_mode ) != "1024x768" && \
											dvarstring( r_mode ) != "1152x864" && \
											dvarstring( r_mode ) != "1280x960" && \
											dvarstring( r_mode ) != "1280x1024" && \
											dvarstring( r_mode ) != "1600x1024" 


// Minimap
menuDef
{
    name			"Compass_other"
    rect			MINIMAP_RECT
    fullScreen		0
    visible			1
    hiddenDuringScope
    hiddenDuringFlashbang
    visible when  ( (dvarBool( compass ) == 1 && dvarBool( hud_missionFailed ) == 0 && !ui_active()) && VIS_NORMAL_COMPASS );
    itemDef
    {
        name			"minimapTickerBorder"
        rect			MINIMAP_X_SP (MINIMAP_Y_SP - 15) MINIMAP_W_SP 14
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         1
        decoration
    }
    itemDef
    {
        name			"minimapTicker"
        rect			MINIMAP_X_SP (MINIMAP_Y_SP - 12) MINIMAP_W_SP 9
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ
        textscale		0.25
		textstyle		ITEM_TEXTSTYLE_SHADOWED
        visible         1
        decoration
    }
    itemDef
    {
        name            "minimap"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compass_map_default"
        ownerdraw		CG_PLAYER_COMPASS_MAP
        visible 		1
        decoration
    }
    // objectives --------------------
    itemDef
    {
        name			"compassplayer"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compassping_player"
        ownerdraw		CG_PLAYER_COMPASS_PLAYER              // bugged
        visible 		1
        decoration
    }
    itemDef
    {
        name			"compassfriendlies"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compassping_friendly"
        ownerdraw		CG_PLAYER_COMPASS_ACTORS
        visible 		1
        decoration
    }
    itemDef
    {
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"objective_line"
        ownerdraw		CG_PLAYER_COMPASS_POINTERS
        visible 		1
        decoration
    }
	itemDef
    {
        name			"minimapBG"
        rect			(MINIMAP_X_SP - 16) (MINIMAP_Y_SP - 7) COMPASS_SIZE_SP COMPASS_SIZE_SP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         1
        decoration
    }
}


// Minimap
menuDef
{
    name			"Compass_4_3"
    rect			MINIMAP_RECT_4_3
    fullScreen		0
    visible			1
    hiddenDuringScope
    hiddenDuringFlashbang
    visible when  ( (dvarBool( compass ) == 1 && dvarBool( hud_missionFailed ) == 0 && !ui_active()) && VIS_4_3_COMPASS );
    itemDef
    {
        name			"minimapTickerBorder"
        rect			MINIMAP_X_SP (MINIMAP_Y_SP - 15) MINIMAP_W_SP 14
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         1
        decoration
    }
    itemDef
    {
        name			"minimapTicker"
        rect			MINIMAP_X_SP (MINIMAP_Y_SP - 12) MINIMAP_W_SP 9
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_tickertape"
        ownerdraw		CG_PLAYER_COMPASS_TICKERTAPE_NO_OBJ
        textscale		0.25
		textstyle		ITEM_TEXTSTYLE_SHADOWED
        visible         1
        decoration
    }
    itemDef
    {
        name            "minimap"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compass_map_default"
        ownerdraw		CG_PLAYER_COMPASS_MAP
        visible 		1
        decoration
    }
    // objectives --------------------
    itemDef
    {
        name			"compassplayer"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compassping_player"
        ownerdraw		CG_PLAYER_COMPASS_PLAYER              // bugged
        visible 		1
        decoration
    }
    itemDef
    {
        name			"compassfriendlies"
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"compassping_friendly"
        ownerdraw		CG_PLAYER_COMPASS_ACTORS
        visible 		1
        decoration
    }
    itemDef
    {
        rect			MINIMAP_X_SP MINIMAP_Y_SP MINIMAP_W_SP MINIMAP_H_SP
	 	origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"objective_line"
        ownerdraw		CG_PLAYER_COMPASS_POINTERS
        visible 		1
        decoration
    }
	itemDef
    {
        name			"minimapBG"
        rect			(MINIMAP_X_SP - 16) (MINIMAP_Y_SP - 7) COMPASS_SIZE_SP COMPASS_SIZE_SP
        origin 			MINIMAP_ORIGIN
        forecolor		1 1 1 1
        background		"minimap_background"
        ownerdraw		CG_PLAYER_COMPASS_BACK
        visible         1
        decoration
    }
}
