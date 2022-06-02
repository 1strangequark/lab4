`timescale 1ns / 1ps

module tb;

   reg clk;                  // 100MHz
   reg btnR = 0;
   reg btnL = 0;
      reg btnU = 0;
   reg btnD = 0;
   reg clr = 0;
   wire dp;
   wire [3:0] an;
   wire [7:0] seg;
   

	wire [2:0] red;	//red vga output - 3 bits
	wire [2:0] green;//green vga output - 3 bits
	wire [1:0] blue;	//blue vga output - 2 bits
	wire hsync;		//horizontal sync out
	wire vsync;			//vertical sync out
   
   
   
   integer   i;
   
   initial
     begin
        //$shm_open  ("dump", , ,1);
        //$shm_probe (tb, "ASTF");
        clk = 0;
//        btnS = 0;
//        #500 btnR = 1;
//        #1000 btnR = 0;
        
//        #
//        btnR = 1;
//        btnS = 0;
//        #1000 btnR = 0;
        #30000000;
        
//        btnS = 1;
//        #1000 btnL = 0;
        
//        #10000
//         btnL = 1;
//        #1000 btnL = 0;
        
        #1500000000;
//        
//        tskRunPUSH(0,4);
//        tskRunPUSH(0,0);
//        tskRunPUSH(1,3);
//        tskRunMULT(0,1,2);
//        tskRunADD(2,0,3);
//        tskRunSEND(0);
//        tskRunSEND(1);
//        tskRunSEND(2);
//        tskRunSEND(3);
        
        #1000;        
        $finish;
     end

   always #5 clk = ~clk;





// Instantiate the module
lab4_top uut_ (
    .clk(clk), 
    .clr(clr), 
    .btnL(btnL), 
    .btnD(btnD), 
    .btnU(btnU), 
    .btnR(btnR), 
    .seg(seg), 
    .an(an), 
    .dp(dp), 
    .red(red), 
    .green(green), 
    .blue(blue), 
    .hsync(hsync), 
    .vsync(vsync)
    );

endmodule // tb
// Local Variables:
// verilog-library-flags:("-y ../src/")
// End:
