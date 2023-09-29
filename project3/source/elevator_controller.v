`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Yihui Wang
// Elevator controller module
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module elevator_controller (
  input clk,
  input rstn,
  input floor_1_up_button,
  input floor_2_up_button,
  input floor_2_down_button,
  input floor_3_down_button,
  input elevator_floor_1_button,
  input elevator_floor_2_button,
  input elevator_floor_3_button,

  output reg floor_1 = 1'b1,
  output reg floor_2 = 1'b0,
  output reg floor_3 = 1'b0,
  output reg elevator_door_open = 1'b0,
  output reg floor_1_up_button_clear = 1'b0,
  output reg floor_2_up_button_clear = 1'b0,
  output reg floor_2_down_button_clear = 1'b0,
  output reg floor_3_down_button_clear = 1'b0,
  output reg elevator_floor_1_button_clear = 1'b0,
  output reg elevator_floor_2_button_clear = 1'b0,
  output reg elevator_floor_3_button_clear = 1'b0
);

  // State defination
  parameter wait_at_floor_1 = 10'b0000000001;
  parameter open_door_at_floor_1 = 10'b0000000010;
  parameter moving_1_to_2 = 10'b0000000100;
  parameter moving_2_to_1 = 10'b0000001000;
  parameter wait_at_floor_2 = 10'b0000010000;
  parameter open_door_at_floor_2 = 10'b0000100000;
  parameter moving_2_to_3 = 10'b0001000000;
  parameter moving_3_to_2 = 10'b0010000000;
  parameter wait_at_floor_3 = 10'b0100000000;
  parameter open_door_at_floor_3 = 10'b1000000000;

  // State register
  reg [9:0] state = wait_at_floor_1;
  reg [9:0] next = 10'd0;

  // Counter register
  reg [3:0] count = 4'd0;
  reg [3:0] count_next = 4'd0;

  // Elevator direction register 
  reg elevator_direction = 1'b0;
  reg elevator_direction_next = 1'b0;

  // Elevator direction logic
  always @(posedge clk, negedge rstn) begin
    if (rstn == 1'b0) begin
      elevator_direction <= 1'b0;
    end 
    else begin
      elevator_direction <= elevator_direction_next;
    end
  end

  always @(*) begin
    elevator_direction_next <= (next[2]|next[6])? 1'b1: ((next[3]|next[7])? 1'b0: elevator_direction);
  end

  // counter
  always @(posedge clk, negedge rstn) begin
    if (rstn == 1'b0) begin
      count <= 4'd0;
    end
    else begin
      count <= count_next;
    end
  end

  always @(*) begin
    if ((state==open_door_at_floor_1)|(state==open_door_at_floor_2)|(state==open_door_at_floor_3)) begin
      if (count == 4'd4) count_next <= 4'd0;
      else count_next <= count + 4'd1;
    end
    else if ((state==moving_1_to_2)|(state==moving_2_to_1)|(state==moving_2_to_3)|(state==moving_3_to_2)) begin
      if (count == 4'd9) count_next <= 4'd0;
      else count_next <= count + 4'd1;
    end 
    else count_next <= 4'd0;
  end

  // Sequential logic for state 
  always @(posedge clk, negedge rstn) begin

    if (rstn == 1'b0) begin
      state <= wait_at_floor_1;
    end else begin
      state <= next;
    end

  end

  // Combination state transition logic
  always @(*) begin
    case (state)
      wait_at_floor_1: begin
        if (elevator_floor_1_button | floor_1_up_button) begin
          next = open_door_at_floor_1;
        end
                else if (elevator_floor_2_button|elevator_floor_3_button|floor_2_down_button|floor_2_down_button|floor_3_down_button) begin
          next = moving_1_to_2;
        end else next = wait_at_floor_1;
      end

      open_door_at_floor_1: begin
        if (count == 4'd4) next = wait_at_floor_1;
        else next = open_door_at_floor_1;
      end

      moving_1_to_2: begin
        if (count == 4'd9) begin
          if (elevator_floor_2_button | floor_2_up_button) begin
            next = open_door_at_floor_2;
          end else if (elevator_floor_3_button | floor_3_down_button) begin
            next = moving_2_to_3;
          end
        end else next = moving_1_to_2;
      end

      open_door_at_floor_2: begin
        if (count == 4'd4) next = wait_at_floor_2;
        else next = open_door_at_floor_2;
      end

      wait_at_floor_2: begin
        if (elevator_floor_2_button | floor_2_up_button | floor_2_down_button) begin
          next = open_door_at_floor_2;
        end else if ((elevator_floor_3_button | floor_3_down_button) & elevator_direction) begin
          next = moving_2_to_3;
        end else if ((elevator_floor_1_button | floor_1_up_button) & ~elevator_direction) begin
          next = moving_2_to_1;
        end else if (floor_1_up_button | elevator_floor_1_button) begin
          next = moving_2_to_1;
        end else if (floor_3_down_button | elevator_floor_3_button) begin
          next = moving_2_to_3;
        end else next = wait_at_floor_2;
      end

      moving_2_to_3: begin
        if (count == 4'd9) begin
          next = open_door_at_floor_3;
        end else next = moving_2_to_3;
      end

      open_door_at_floor_3: begin
        if (count == 4'd4) next = wait_at_floor_3;
        else next = open_door_at_floor_3;
      end

      wait_at_floor_3: begin
        if (elevator_floor_3_button | floor_3_down_button) begin
          next = open_door_at_floor_3;
        end
                else if (elevator_floor_2_button|elevator_floor_1_button|floor_2_down_button|floor_2_up_button|floor_1_up_button) begin
          next = moving_3_to_2;
        end else next = wait_at_floor_3;
      end

      moving_3_to_2: begin
        if (count == 4'd9) begin
          if (elevator_floor_2_button | floor_2_down_button) begin
            next = open_door_at_floor_2;
          end else if (elevator_floor_1_button | floor_1_up_button) begin
            next = moving_2_to_1;
          end
        end else next = moving_3_to_2;
      end

      moving_2_to_1: begin
        if (count == 4'd9) begin
          next = open_door_at_floor_1;
        end else next = moving_2_to_1;
      end
    endcase
  end

  // Output logic
  always @(*) begin

    floor_1 = |state[2:0];
    floor_2 = |state[6:3];
    floor_3 = |state[9:7];
    elevator_door_open = state[1] | state[5] | state[9];
    floor_1_up_button_clear = state[1];
    floor_2_up_button_clear = state[5];
    floor_2_down_button_clear = state[5];
    floor_3_down_button_clear = state[9];
    elevator_floor_1_button_clear = state[1];
    elevator_floor_2_button_clear = state[5];
    elevator_floor_3_button_clear = state[9];

  end

endmodule
