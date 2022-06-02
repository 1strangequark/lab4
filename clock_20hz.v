`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:09 04/28/2022 
// Design Name: 
// Module Name:    clock_20hz
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
module clock_20hz(clk, clk_divided
    );
    input clk;
    output clk_divided;
    
    reg [27:0] buffer = 1;
   
    assign clk_divided = buffer == 1000000;
    
    always @(posedge clk)
      if (buffer == 1000000)
        buffer <= 1;
      else
        buffer <= buffer+1;
endmodule
