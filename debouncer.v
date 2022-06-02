`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:41:09 05/4/2022 
// Design Name: 
// Module Name:    debouncer 
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
//debouncer module

module dff(input slow_clk, input in, output out);
    reg out = 1'b0;
    always @ (posedge slow_clk) begin
        out <= in;
    end
endmodule

module debouncer(
    input clk,
    input slow_clk,
    input btn_in,
    output btn_out
    );

    wire s1, s2, s3; // samples
    dff d1(.slow_clk(slow_clk), .in(btn_in), .out(s1));
    dff d2(.slow_clk(slow_clk), .in(s1), .out(s2));
    dff d3(.slow_clk(slow_clk), .in(s2), .out(s3));
    assign btn_out = s2 & ~s3;
    //    reg btn_out = 0;
//    always @(posedge clk)
//    begin
//      if (!btn_out)
//        btn_out <= s2 & ~s3;
//      else
//        btn_out <= 0;
//    end
endmodule