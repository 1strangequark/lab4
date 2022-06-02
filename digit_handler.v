`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:30:00 05/03/2022 
// Design Name: 
// Module Name:    digit_handler 
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
module digit_handler(clk, score, digit1, digit2, digit3, digit4
    );
  input clk;
  input wire [13:0] score;
  output reg[3:0] digit1;
  output reg[3:0] digit2;
  output reg[3:0] digit3;
  output reg[3:0] digit4;
  reg [13:0] temp_score;

  always @(posedge clk) begin
//    temp_score <= score;
      digit1 <= score / 1000;
//    temp_score <= temp_score - digit1 * 1000 ;
      digit2 <= (score%1000) / 100;
//    temp_score <= temp_score - digit2 * 100 ;
    digit3 <= (score%100) / 10 ;
//    temp_score <= temp_score - digit3 * 10;
    digit4 <= score%10;
//      digit1 <= 1;
//      digit2 <= 2;
//      digit3 <= 3;
//      digit4 <= 4;
  end
endmodule
