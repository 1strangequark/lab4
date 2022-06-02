`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:02:31 05/19/2022 
// Design Name: 
// Module Name:    arrow_manager 
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
module arrow_manager(
input wire clk,
input wire arrow_move_clk,
input btnR,
input btnL,
input btnU,
input btnD,
input wire[9:0] move_step,
input wire[27:0] buffer,


output reg [9:0] arrow1_y,
output reg [9:0] arrow1_x,
output reg [9:0] arrow2_y,
output reg [9:0] arrow2_x,
output reg [9:0] arrow3_y,
output reg [9:0] arrow3_x,
output reg [9:0] arrow4_y,
output reg [9:0] arrow4_x,
output reg [9:0] arrow5_y,
output reg [9:0] arrow5_x,
output reg [13:0] score,
output reg [27:0] pause_count
    );
    
    
`include "constants.vh"

reg [8:0] max_arrow_idx = 0;
reg [9:0] max_arrow_y;
reg [9:0] max_arrow_x;
//always @(max_arrow_idx or arrow1_y or arrow2_y or arrow3_y or arrow4_y or arrow5_y)

always @(posedge clk)
begin
  case (max_arrow_idx)
  0: begin
      max_arrow_y = arrow1_y;
      max_arrow_x = arrow1_x;
      end
  1: begin
      max_arrow_y = arrow2_y;
      max_arrow_x = arrow2_x;
      end
  2: begin
      max_arrow_y = arrow3_y;
      max_arrow_x = arrow3_x;
      end
  3: begin
      max_arrow_y = arrow4_y;
      max_arrow_x = arrow4_x;
      end
  4: begin
      max_arrow_y = arrow5_y;
      max_arrow_x = arrow5_x;
      end
  endcase
end

initial
begin
  arrow1_y = reset_y;
  arrow2_y = arrow1_y + arrow_spacing;
  arrow3_y = arrow2_y + arrow_spacing;
  arrow4_y = arrow3_y + arrow_spacing;
  arrow5_y = arrow4_y + arrow_spacing;

  arrow1_x = left_arrow_x;
  arrow2_x = down_arrow_x;
  arrow3_x = up_arrow_x;
  arrow4_x = right_arrow_x;
  arrow5_x = left_arrow_x;
  score = 0;
  pause_count = 0;
end

reg [9:0] next_rand_x;
always @(*)
begin
  // fix randomness
  case(max_arrow_y % 4)
    0: next_rand_x = left_arrow_x;
    1: next_rand_x = down_arrow_x;
    2: next_rand_x = up_arrow_x;
    3: next_rand_x = right_arrow_x;
  endcase
end

always @(posedge clk)
begin
  if (pause_count == 100)
  begin
      arrow1_y <= reset_y;
      arrow2_y <= reset_y + arrow_spacing;
      arrow3_y <= reset_y + 2 * arrow_spacing;
      arrow4_y <= reset_y + 3 * arrow_spacing;
      arrow5_y <= reset_y + 4 * arrow_spacing;

      arrow1_x <= left_arrow_x;
      arrow2_x <= down_arrow_x;
      arrow3_x <= up_arrow_x;
      arrow4_x <= right_arrow_x;
      arrow5_x <= left_arrow_x;
      score <= 0;
      max_arrow_idx <= 0;
      
    pause_count <= 0;
  end
  else if (pause_count > 0)
    pause_count <= pause_count + 1;
  else if (((btnR || btnL || btnD || btnU) && max_arrow_y > hollow_arrow_y + arrow_match_margin)
      ||
      max_arrow_y < hollow_arrow_y - arrow_match_margin
      ||
      (btnL && max_arrow_x != left_arrow_x)
      ||
      (btnD && max_arrow_x != down_arrow_x)
      ||
      (btnU && max_arrow_x != up_arrow_x)
      ||
      (btnR && max_arrow_x != right_arrow_x)
      )
      // FAILURE
      begin
        pause_count <= 1;
      end
   else if (btnR || btnL || btnD || btnU)
   begin
    score <= score + 1;
    if(max_arrow_idx == 0) begin
          arrow1_y <= max_arrow_y + success_jump_y;
          arrow1_x <= next_rand_x;
          max_arrow_idx <= 1;
    end else if (max_arrow_idx == 1) begin
           arrow2_y <= max_arrow_y + success_jump_y;
          arrow2_x <= next_rand_x;
          max_arrow_idx <= 2;
    end else if (max_arrow_idx == 2) begin
          arrow3_y <= max_arrow_y + success_jump_y;
          arrow3_x <= next_rand_x;
          max_arrow_idx <= 3;
    end else if(max_arrow_idx == 3) begin
          arrow4_y <= max_arrow_y + success_jump_y;
          arrow4_x <= next_rand_x;
          max_arrow_idx <= 4;
    end else if(max_arrow_idx == 4) begin
              arrow5_y <= max_arrow_y + success_jump_y;
          arrow5_x <= next_rand_x;
          max_arrow_idx <= 0;
    end
  end
  else
  begin
    arrow1_y <= arrow1_y - move_step;
    arrow2_y <= arrow2_y - move_step;
    arrow3_y <= arrow3_y - move_step;
    arrow4_y <= arrow4_y - move_step;
    arrow5_y <= arrow5_y - move_step;
  end
//    case (max_arrow_idx)
//      0: begin
//          arrow1_y <= max_arrow_y + success_jump_y;
//          arrow1_x <= next_rand_x;
//          end
//      1: begin
//          arrow2_y <= max_arrow_y + success_jump_y;
//          arrow2_x <= next_rand_x;
//          end
//      2: begin
//          arrow3_y <= max_arrow_y + success_jump_y;
//          arrow3_x <= next_rand_x;
//          end
//      3: begin
//          arrow4_y <= max_arrow_y + success_jump_y;
//          arrow4_x <= next_rand_x;
//          end
//      4: begin
//          arrow5_y <= max_arrow_y + success_jump_y;
//          arrow5_x <= next_rand_x;
//          end
//      endcase
//    max_arrow_idx <= (max_arrow_idx + 1)% num_arrows;
    
//   end
//  if (btnR)
//  begin
//    if (btnR &&
//        max_arrow_x == right_arrow_x &&
//        max_arrow_y <= hollow_arrow_y + arrow_match_margin &&
//        max_arrow_y >= hollow_arrow_y - arrow_match_margin)
//        // success
//    else
//        // failure
//  end
//  if (arrow_move_clk)
//  begin

//  end
end

endmodule
