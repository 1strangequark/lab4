`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:30:38 03/19/2013 
// Design Name: 
// Module Name:    vga640x480 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga640x480(
	input wire dclk,			//pixel clock: 25MHz
	input wire clr,			//asynchronous reset
input wire [9:0] arrow1_y,
input wire [9:0] arrow1_x,
input wire [9:0] arrow2_y,
input wire [9:0] arrow2_x,
input wire [9:0] arrow3_y,
input wire [9:0] arrow3_x,
input wire [9:0] arrow4_y,
input wire [9:0] arrow4_x,
input wire [9:0] arrow5_y,
input wire [9:0] arrow5_x,
	output wire hsync,		//horizontal sync out
	output wire vsync,		//vertical sync out
	output reg [2:0] red,	//red vga output
	output reg [2:0] green, //green vga output
	output reg [1:0] blue	//blue vga output
	);
  

// video structure constants
//parameter hpixels = 800;// horizontal pixels per line
//parameter vlines = 521; // vertical lines per frame
//parameter hpulse = 96; 	// hsync pulse length
//parameter vpulse = 2; 	// vsync pulse length
//parameter hbp = 144; 	// end of horizontal back porch
//parameter hfp = 784; 	// beginning of horizontal front porch
//parameter vbp = 31; 		// end of vertical back porch
//parameter vfp = 511; 	// beginning of vertical front porch
// active horizontal video is therefore: 784 - 144 = 640
// active vertical video is therefore: 511 - 31 = 480

// parameters for arrow
`include "constants.vh"
//parameter arrow_width = 50;
//parameter arrow_height = 50;
//
//parameter left_arrow_x = 100;
//parameter down_arrow_x = 200;
//parameter up_arrow_x = 300;
//parameter right_arrow_x = 400;
//
//
//parameter hollow_arrow_y = 25 + arrow_height;

`include "arrows.vh"


// registers for storing the horizontal & vertical counters
reg [9:0] hc;
reg [9:0] vc;

// Horizontal & vertical counters --
// this is how we keep track of where we are on the screen.
// ------------------------
// Sequential "always block", which is a block that is
// only triggered on signal transitions or "edges".
// posedge = rising edge  &  negedge = falling edge
// Assignment statements can only be used on type "reg" and need to be of the "non-blocking" type: <=
always @(posedge dclk or posedge clr)
begin
	// reset condition
	if (clr == 1)
	begin
		hc <= 0;
		vc <= 0;
	end
	else
	begin
		// keep counting until the end of the line
		if (hc < hpixels - 1)
			hc <= hc + 1;
		else
		// When we hit the end of the line, reset the horizontal
		// counter and increment the vertical counter.
		// If vertical counter is at the end of the frame, then
		// reset that one too.
		begin
			hc <= 0;
			if (vc < vlines - 1)
				vc <= vc + 1;
			else
				vc <= 0;
		end
		
	end
end

// generate sync pulses (active low)
// ----------------
// "assign" statements are a quick way to
// give values to variables of type: wire
assign hsync = (hc < hpulse) ? 0:1;
assign vsync = (vc < vpulse) ? 0:1;

// display 100% saturation colorbars
// ------------------------
// Combinational "always block", which is a block that is
// triggered when anything in the "sensitivity list" changes.
// The asterisk implies that everything that is capable of triggering the block
// is automatically included in the sensitivty list.  In this case, it would be
// equivalent to the following: always @(hc, vc)
// Assignment statements can only be used on type "reg" and should be of the "blocking" type: =
always @(*)
begin
	// first check if we're within vertical active video range
	if (vc >= vbp && vc < vfp)
	begin
//		// now display different colors every 80 pixels
//		// while we're within the active horizontal range
//		// -----------------
//		// display white bar
//		if (hc >= hbp && hc < (hbp+80))
//		begin
//			red = 3'b111;
//			green = 3'b111;
//			blue = 2'b11;
//		end
//		// display yellow bar
//		else if (hc >= (hbp+80) && hc < (hbp+160))
//		begin
//			red = 3'b111;
//			green = 3'b111;
//			blue = 2'b00;
//		end
//		// display cyan bar
//		else if (hc >= (hbp+160) && hc < (hbp+240))
//		begin
//			red = 3'b000;
//			green = 3'b111;
//			blue = 2'b11;
//		end
//		// display green bar
//		else if (hc >= (hbp+240) && hc < (hbp+320))
//		begin
//			red = 3'b000;
//			green = 3'b111;
//			blue = 2'b00;
//		end
//		// display magenta bar
//		else if (hc >= (hbp+320) && hc < (hbp+400))
//		begin
//			red = 3'b111;
//			green = 3'b000;
//			blue = 2'b11;
//		end
//		// display red bar
//		else if (hc >= (hbp+400) && hc < (hbp+480))
//		begin
//			red = 3'b111;
//			green = 3'b000;
//			blue = 2'b00;
//		end
//		// display blue bar
//		else if (hc >= (hbp+480) && hc < (hbp+560))
//		begin
//			red = 3'b000;
//			green = 3'b000;
//			blue = 2'b11;
//		end
//		// display black bar
//		else if (hc >= (hbp+560) && hc < (hbp+640))
//		begin
//			red = 3'b000;
//			green = 3'b000;
//			blue = 2'b00;
//		end



    // THIS IS FOR THE RISING ARROWS
    if (hc >= arrow1_x+hbp && hc < arrow1_x+hbp+arrow_width && vc < arrow1_y+vbp && vc > arrow1_y+vbp - arrow_height)
    begin
		if (arrow1_x == left_arrow_x)
		begin
			if (right_arrow[vc-arrow1_y-vbp+arrow_height][hc - arrow1_x-hbp] == 1)
			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
			end
			else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			else begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
		else if (arrow1_x == down_arrow_x)
		begin
			if (down_arrow[vc-arrow1_y-vbp+arrow_height][hc - arrow1_x-hbp] == 1)
			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
			end
			else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			else begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
		else if (arrow1_x == up_arrow_x)
		begin
			if (up_arrow[vc-arrow1_y-vbp+arrow_height][hc - arrow1_x-hbp] == 1)
			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
			end
			else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			else begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
		else
		begin
			if (left_arrow[vc-arrow1_y-vbp+arrow_height][hc - arrow1_x-hbp] == 1)
			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
			end
			else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
			begin
				red = 3'b111;
				green = 3'b000;
				blue = 2'b00;
			end
			else begin
				red = 0;
				green = 0;
				blue = 0;
			end
		end
    end
   else if (hc >= arrow2_x+hbp && hc < arrow2_x+hbp+arrow_width && vc < arrow2_y+vbp && vc > arrow2_y+vbp - arrow_height)
    begin
//		if (arrow2_x == left_arrow_x)
//		begin
//			if (right_arrow[vc-arrow2_y-vbp+arrow_height][hc - arrow2_x-hbp] == 1)
//			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
//			end
//			else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow2_x == down_arrow_x)
//		begin
//			if (down_arrow[vc-arrow2_y-vbp+arrow_height][hc - arrow2_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow2_x == up_arrow_x)
//		begin
//			if (up_arrow[vc-arrow2_y-vbp+arrow_height][hc - arrow2_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else
//		begin
//			if (left_arrow[vc-arrow2_y-vbp+arrow_height][hc - arrow2_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
    end
    else if (hc >= arrow3_x+hbp && hc < arrow3_x+hbp+arrow_width && vc < arrow3_y+vbp && vc > arrow3_y+vbp - arrow_height)
    begin
//		if (arrow3_x == left_arrow_x)
//		begin
//			if (right_arrow[vc-arrow3_y-vbp+arrow_height][hc - arrow3_x-hbp] == 1)
//			begin
				red = 3'b100;
				green = 3'b000;
				blue = 2'b11;
//			end
//			else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow3_x == down_arrow_x)
//		begin
//			if (down_arrow[vc-arrow3_y-vbp+arrow_height][hc - arrow3_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow3_x == up_arrow_x)
//		begin
//			if (up_arrow[vc-arrow3_y-vbp+arrow_height][hc - arrow3_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else
//		begin
//			if (left_arrow[vc-arrow3_y-vbp+arrow_height][hc - arrow3_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
    end
    else if (hc >= arrow4_x+hbp && hc < arrow4_x+hbp+arrow_width && vc < arrow4_y+vbp && vc > arrow4_y+vbp - arrow_height)
    begin
//		if (arrow4_x == left_arrow_x)
//		begin
//			if (right_arrow[vc-arrow4_y-vbp+arrow_height][hc - arrow4_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow4_x == down_arrow_x)
//		begin
//			if (down_arrow[vc-arrow4_y-vbp+arrow_height][hc - arrow4_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow4_x == up_arrow_x)
//		begin
//			if (up_arrow[vc-arrow4_y-vbp+arrow_height][hc - arrow4_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else
//		begin
//			if (left_arrow[vc-arrow4_y-vbp+arrow_height][hc - arrow4_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
    end
    else if (hc >= arrow5_x+hbp && hc < arrow5_x+hbp+arrow_width && vc < arrow5_y+vbp && vc > arrow5_y+vbp- arrow_height)
    begin
//		if (arrow5_x == left_arrow_x)
//		begin
//			if (right_arrow[vc-arrow5_y-vbp+arrow_height][hc - arrow5_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow5_x == down_arrow_x)
//		begin
//			if (down_arrow[vc-arrow5_y-vbp+arrow_height][hc - arrow5_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else if (arrow5_x == up_arrow_x)
//		begin
//			if (up_arrow[vc-arrow5_y-vbp+arrow_height][hc - arrow5_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
//		else
//		begin
//			if (left_arrow[vc-arrow5_y-vbp+arrow_height][hc - arrow5_x-hbp] == 1)
//			begin
//				red = 3'b100;
//				green = 3'b000;
//				blue = 2'b11;
//			end
//			else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
//			begin
//				red = 3'b111;
//				green = 3'b000;
//				blue = 2'b00;
//			end
//			else begin
//				red = 0;
//				green = 0;
//				blue = 0;
//			end
//		end
    end
    // THIS IS FOR THE HOLLOW ARROWS
    else if (hc >= left_arrow_x+hbp && hc < left_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
    begin
		if (right_arrow_hollow[vc-hollow_arrow_y-vbp+arrow_height][hc - left_arrow_x-hbp] == 1)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
    end
    else if (hc >= down_arrow_x+hbp && hc < down_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
    begin
		if (down_arrow_hollow[vc-hollow_arrow_y-vbp+arrow_height][hc - down_arrow_x-hbp] == 1)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
    end
  else if (hc >= up_arrow_x+hbp && hc < up_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
    begin
		if (up_arrow_hollow[vc-hollow_arrow_y-vbp+arrow_height][hc - up_arrow_x-hbp] == 1)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
    end
    else if (hc >= right_arrow_x+hbp && hc < right_arrow_x+hbp+arrow_width && vc < hollow_arrow_y+vbp && vc > hollow_arrow_y+vbp - arrow_height)
    begin
		if (left_arrow_hollow[vc-hollow_arrow_y-vbp+arrow_height][hc - right_arrow_x-hbp] == 1)
		begin
			red = 3'b111;
			green = 3'b000;
			blue = 2'b00;
		end
    end
		// we're outside active horizontal range so display black
		else
		begin
			red = 0;
			green = 0;
			blue = 0;
		end
	end
	// we're outside active vertical range so display black
	else
	begin
		red = 0;
		green = 0;
		blue = 0;
	end
end

endmodule
