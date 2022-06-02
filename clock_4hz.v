`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:41:09 04/28/2022 
// Design Name: 
// Module Name:    clock_4hz
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
module clock_4hz(clk, clk_divided, buffer
    );
    input clk;
    output clk_divided;
    
    output reg [27:0] buffer = 1;
    
    assign clk_divided = buffer > 12500000;
    
    always @(posedge clk)
      if (buffer == 25000000)
        buffer <= 1;
      else
        buffer <= buffer+1;
endmodule
