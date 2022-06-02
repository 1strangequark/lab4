`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:28:25 03/19/2013 
// Design Name: 
// Module Name:    NERP_demo_top 
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
module lab4_top(
	input wire clk,			//master clock = 50MHz
	input wire clr,			//right-most pushbutton for reset
  input wire btnL,
  input wire btnD,
  input wire btnU,
  input wire btnR,
  input wire swL1,
  input wire swL2,
  input wire swL3,
  input wire swL4,
  input wire swL5,
	output wire [6:0] seg,	//7-segment display LEDs
	output reg [3:0] an,	//7-segment display anode enable
	output wire dp,			//7-segment display decimal point
	output wire [2:0] red,	//red vga output - 3 bits
	output wire [2:0] green,//green vga output - 3 bits
	output wire [1:0] blue,	//blue vga output - 2 bits
	output wire hsync,		//horizontal sync out
	output wire vsync			//vertical sync out
	);

`include "constants.vh"

reg [9:0] move_step;
//always @(*)
//begin
//  if (swL5)
//    move_step = 12;
//  else if (swL4)
//    move_step = 10;
//    else if (swL3)
//    move_step = 8;
//  else if (swL2)
//    move_step = 6;
//  else if (swL1)
//    move_step = 4;
//  else
//    move_step = 2;
//end

always @(*)
begin
  if (swL5)
    move_step = 11;
  else if (swL4)
    move_step = 9;
    else if (swL3)
    move_step = 7;
  else if (swL2)
    move_step = 5;
  else if (swL1)
    move_step = 3;
  else
    move_step = 1;
end

// generate 7-segment clock & display clock
wire lvl1_clk;
level1_clk CLK1(
	.clk(clk),
	.clk_divided(lvl1_clk)
	);
  

// slow clock for debouncer
wire clock_20_hz;
clock_20hz clk_20_hz (.clk(clk), .clk_divided(clock_20_hz));

// clock for seven seg display
wire clk_500hz;
clock_500hz clock_500hz_ (
    .clk(clk), 
    .clk_divided(clk_500hz)
    );
    
// debounced arrow button inputs
wire right_debounced;
debouncer debR (.clk(clk), .slow_clk(clock_20_hz), .btn_in(btnR), .btn_out(right_debounced));

wire left_debounced;
debouncer debL (.clk(clk), .slow_clk(clock_20_hz), .btn_in(btnL), .btn_out(left_debounced));

wire down_debounced;
debouncer debD (.clk(clk), .slow_clk(clock_20_hz), .btn_in(btnD), .btn_out(down_debounced));

wire up_debounced;
debouncer debU (.clk(clk), .slow_clk(clock_20_hz), .btn_in(btnU), .btn_out(up_debounced));
  
  
// arrow manager
wire [9:0] arrow1_y;
wire [9:0] arrow1_x;
wire [9:0] arrow2_y;
wire [9:0] arrow2_x;
wire [9:0] arrow3_y;
wire [9:0] arrow3_x;
wire [9:0] arrow4_y;
wire [9:0] arrow4_x;
wire [9:0] arrow5_y;
wire [9:0] arrow5_x;
wire [13:0] current_score;
wire [27:0] pause_count;

wire [27:0] buffer;
arrow_manager am (
.move_step(move_step),
      .clk(clock_20_hz),
//    .clk(clk),
    .arrow_move_clk(lvl1_clk), 
    .arrow1_y(arrow1_y), 
    .arrow1_x(arrow1_x), 
    .arrow2_y(arrow2_y), 
    .arrow2_x(arrow2_x), 
    .arrow3_y(arrow3_y), 
    .arrow3_x(arrow3_x), 
    .arrow4_y(arrow4_y), 
    .arrow4_x(arrow4_x), 
    .arrow5_y(arrow5_y), 
    .arrow5_x(arrow5_x),
    .btnR(right_debounced),
    .btnL(left_debounced),
    .btnU(up_debounced),
    .btnD(down_debounced),
    .score(current_score),
    .pause_count(pause_count),
    .buffer(buffer)
    );

wire [3:0] digit1;
wire [3:0] digit2;
wire [3:0] digit3;
wire [3:0] digit4;
reg [3:0] digit;
reg [1:0] cur_displayed_digit;

digit_handler score_handler (
    .clk(clk), 
    .score(current_score), 
    .digit1(digit1), 
    .digit2(digit2), 
    .digit3(digit3), 
    .digit4(digit4)
    );
 
sevenseg seg_handler (
    .clk(clk), 
    .digit(digit), 
    .encoding(seg)
    );
    
wire clk_4hz;
clock_4hz clock_4hz_ (
    .clk(clk),
    .clk_divided(clk_4hz),
    .buffer(buffer)
    );



// 7-segment clock interconnect
wire segclk;

// VGA display clock interconnect
wire dclk;

// disable the 7-segment decimal points
assign dp = 1;

// generate 7-segment clock & display clock
clockdiv U1(
	.clk(clk),
	.clr(clr),
	.segclk(segclk),
	.dclk(dclk)
	);
  
// VGA controller
vga640x480 U3(
	.dclk(dclk),
	.clr(clr),
	.hsync(hsync),
	.vsync(vsync),
	.red(red),
	.green(green),
	.blue(blue),
  .arrow1_y(arrow1_y), 
  .arrow1_x(arrow1_x), 
  .arrow2_y(arrow2_y), 
  .arrow2_x(arrow2_x), 
  .arrow3_y(arrow3_y), 
  .arrow3_x(arrow3_x), 
  .arrow4_y(arrow4_y), 
  .arrow4_x(arrow4_x), 
  .arrow5_y(arrow5_y), 
  .arrow5_x(arrow5_x)
	);
  
always @(posedge clk_500hz) begin
  if (cur_displayed_digit == 0) begin
    if (pause_count > 0 && pause_count < 100 && clk_4hz)
      an <= 4'b1111;
    else
      an <= 4'b0111;
    digit <= digit1;
    cur_displayed_digit <= 1;
  end
  else if (cur_displayed_digit == 1) begin
    if (pause_count > 0 && pause_count < 100 && clk_4hz)
      an <= 4'b1111;
    else
      an <= 4'b1011;
    digit <= digit2;
    cur_displayed_digit <= 2;
  end
  else if (cur_displayed_digit == 2) begin
    if (pause_count > 0 && pause_count < 100 && clk_4hz)
      an <= 4'b1111;
    else
      an <= 4'b1101;
    digit <= digit3;
    cur_displayed_digit <= 3;
  end
  else if (cur_displayed_digit == 3) begin
    if (pause_count > 0 && pause_count < 100 && clk_4hz)
      an <= 4'b1111;
    else
      an <= 4'b1110;
    digit <= digit4;
    cur_displayed_digit <= 0;
  end
end

endmodule
