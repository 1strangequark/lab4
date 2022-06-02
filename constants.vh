parameter hpixels = 800;// horizontal pixels per line
parameter vlines = 521; // vertical lines per frame
parameter hpulse = 96; 	// hsync pulse length
parameter vpulse = 2; 	// vsync pulse length
parameter hbp = 144; 	// end of horizontal back porch
parameter hfp = 784; 	// beginning of horizontal front porch
parameter vbp = 31; 		// end of vertical back porch
parameter vfp = 511; 	// beginning of vertical front porch

parameter num_arrows = 5;

parameter arrow_width = 50;
parameter arrow_height = 50;

parameter reset_y = 600;

parameter arrow_spacing = 50 + arrow_height;

parameter success_jump_y = arrow_spacing * num_arrows;

parameter left_arrow_x = 100;
parameter down_arrow_x = 200;
parameter up_arrow_x = 300;
parameter right_arrow_x = 400;

parameter hollow_arrow_y = 25 + arrow_height;

parameter arrow_match_margin = 25;

parameter pause_ticks = 10000;