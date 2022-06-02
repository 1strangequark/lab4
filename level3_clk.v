module level1_clk(clk, clk_divided
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
