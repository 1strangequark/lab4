`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:40:38 04/26/2022 
// Design Name: 
// Module Name:    sevenseg 
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
module sevenseg(clk, digit, encoding);

input clk;
input [3:0] digit;
output reg [7:0] encoding;

always @(*)
  case (digit)
    0: encoding = 8'b11000000;
    1: encoding = 8'b11111001;
    2: encoding = 8'b10100100;
    3: encoding = 8'b10110000;
    4: encoding = 8'b10011001;
    5: encoding = 8'b10010010;
    6: encoding = 8'b10000010;
    7: encoding = 8'b11111000;
    8: encoding = 8'b10000000;
    9: encoding = 8'b10010000;
    10: encoding = 8'b11111111;
    default: encoding = 8'b10000110; // error state E
  endcase
endmodule
