`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Yihui Wang
// Elevator controller testbench
// 
// 
//////////////////////////////////////////////////////////////////////////////////

module elevator_top_tb;
  reg  clk = 0;
  reg  rstn = 0;
  reg  floor_1_up_button_pressed = 0;
  reg  floor_2_up_button_pressed = 0;
  reg  floor_2_down_button_pressed = 0;
  reg  floor_3_down_button_pressed = 0;
  reg  elevator_floor_1_button_pressed = 0;
  reg  elevator_floor_2_button_pressed = 0;
  reg  elevator_floor_3_button_pressed = 0;
  wire floor_1_out;
  wire floor_2_out;
  wire floor_3_out;
  wire elevator_door_open_out;
  wire floor_1_up_button_out;
  wire floor_2_up_button_out;
  wire floor_2_down_button_out;
  wire floor_3_down_button_out;
  wire elevator_floor_1_button_out;
  wire elevator_floor_2_button_out;
  wire elevator_floor_3_button_out;

  reg [7:0] error_count;
  reg [8*58:0] testcase;


  elevator_top DUT (
      .clk(clk),
      .rstn(rstn),
      .floor_1_up_button_pressed(floor_1_up_button_pressed),
      .floor_2_up_button_pressed(floor_2_up_button_pressed),
      .floor_2_down_button_pressed(floor_2_down_button_pressed),
      .floor_3_down_button_pressed(floor_3_down_button_pressed),
      .elevator_floor_1_button_pressed(elevator_floor_1_button_pressed),
      .elevator_floor_2_button_pressed(elevator_floor_2_button_pressed),
      .elevator_floor_3_button_pressed(elevator_floor_3_button_pressed),
      .floor_1_out(floor_1_out),
      .floor_2_out(floor_2_out),
      .floor_3_out(floor_3_out),
      .elevator_door_open_out(elevator_door_open_out),
      .floor_1_up_button_out(floor_1_up_button_out),
      .floor_2_up_button_out(floor_2_up_button_out),
      .floor_2_down_button_out(floor_2_down_button_out),
      .floor_3_down_button_out(floor_3_down_button_out),
      .elevator_floor_1_button_out(elevator_floor_1_button_out),
      .elevator_floor_2_button_out(elevator_floor_2_button_out),
      .elevator_floor_3_button_out(elevator_floor_3_button_out)
  );

  always #1 clk = ~clk;

  initial begin
    #10 rstn = 1;
  end

  always @(posedge elevator_door_open_out) begin
    
    case ({floor_3_out,floor_2_out,floor_1_out})
      3'b001: begin
        if (floor_1_up_button_out) begin
          $display("  Elevator opened at Floor 1 due to Floor 1 UP button         @Time %7t", $time);
        end
        else if (elevator_floor_1_button_out) begin
          $display("  Elevator opened at Floor 1 due to Elevator Floor 1 button   @Time %7t", $time);
        end
      end
      3'b010: begin
        if (floor_2_up_button_out) begin
          $display("  Elevator opened at Floor 2 due to Floor 2 UP button         @Time %7t", $time);
        end
        else if (floor_2_down_button_out) begin
          $display("  Elevator opened at Floor 2 due to Floor 2 down button       @Time %7t", $time);
        end
        else if (elevator_floor_2_button_out) begin
          $display("  Elevator opened at Floor 2 due to Elevator Floor 2 button   @Time %7t", $time);
        end
      end
      3'b100: begin
        if (floor_3_down_button_out) begin
          $display("  Elevator opened at Floor 3 due to Floor 3 down button       @Time %7t", $time);
        end
        else if (elevator_floor_3_button_out) begin
          $display("  Elevator opened at Floor 3 due to Elevator Floor 3 button   @Time %7t", $time);
        end
      end
      default:;
    endcase
    
  end

  initial begin

    $display("\n===============================================TESTBENCH===========================================");

    testcase = "#0 Initializing                                           ";
    error_count = 8'd0;

    $monitor("---------------------------------------------------------------------------------------------------\nTestcase: %s  Time = %t\n---------------------------------------------------------------------------------------------------", testcase, $time);

    #10 rstn = 1;


    // test case #1
    testcase = "#1 Floor 1 -> Floor 2                                     ";
    #1     
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    #10 
    floor_1_up_button_pressed = 1'b1;
    #2 
    floor_1_up_button_pressed = 1'b0;

    #10 
    elevator_floor_2_button_pressed = 1'b1;
    #2 
    elevator_floor_2_button_pressed = 1'b0;

    // back to floor 1 for test case #2
    #80 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    elevator_floor_1_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;

    // test case #2
    
    #80 
    if (floor_1_out) begin
      testcase = "#2 Floor 1 -> Floor 3                                     ";
    end
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    floor_1_up_button_pressed = 1'b1;
    #2 
    floor_1_up_button_pressed = 1'b0;

    #10 
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    // back to floor 2 for test case #3
    #80 
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    elevator_floor_2_button_pressed = 1'b1;
    #2 
    elevator_floor_2_button_pressed = 1'b0;

    // test case #3
    #80 
    if (floor_2_out) begin
      testcase = "#3 Floor 2 -> Floor 3                                     ";
    end
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    floor_2_up_button_pressed = 1'b1;
    #2 
    floor_2_up_button_pressed = 1'b0;

    #10 
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    // back to floor 2 for test case #4
    #80 
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    elevator_floor_2_button_pressed = 1'b1;
    #2 
    elevator_floor_2_button_pressed = 1'b0;

    // test case #4
    #80 
    if (floor_2_out) begin
      testcase =  "#4 Floor 2 -> Floor 1                                     ";
    end
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    floor_2_down_button_pressed = 1'b1;
    #2 
    floor_2_down_button_pressed = 1'b0;

    #10 
    elevator_floor_1_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;

    // back to floor 3 for test case #5
    #80 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    // test case #5
    
    #80 
    if (floor_3_out) begin
      testcase = "#5 Floor 3 -> Floor 2                                     ";
    end
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    floor_3_down_button_pressed = 1'b1;
    #2 
    floor_3_down_button_pressed = 1'b0;

    #10 
    elevator_floor_2_button_pressed = 1'b1;
    #2 
    elevator_floor_2_button_pressed = 1'b0;

    // back to floor 3 for test case #6
    #80 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    // test case #6
    
    #80 
    if (floor_3_out) begin
      testcase = "#6 Floor 3 -> Floor 1                                     ";
    end
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    floor_3_down_button_pressed = 1'b1;
    #2 
    floor_3_down_button_pressed = 1'b0;

    #10 
    elevator_floor_1_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;

    #60 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);

    // test case #7
    testcase = "#7 Floor 1 -> Floor 3 / Pickup on Floor 2                 ";
    #20 
    if (floor_1_out) begin
      testcase = "#7 Floor 1 -> Floor 3 / Pickup on Floor 2                 ";
    end
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    floor_1_up_button_pressed = 1'b1;
    #2 
    floor_1_up_button_pressed = 1'b0;

    #10 
    elevator_floor_3_button_pressed = 1'b1;
    floor_2_up_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;
    floor_2_up_button_pressed = 1'b0;

    #30 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    error_count = compare_outputs(1'b1, elevator_door_open_out, "Door open output", error_count);
    #30 
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);

    // test case #8
    
    #20 
    if (floor_3_out) begin
      testcase = "#8 Floor 3 -> Floor 1 / Pickup on Floor 2                 ";
    end
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    floor_3_down_button_pressed = 1'b1;
    #2 
    floor_3_down_button_pressed = 1'b0;

    #10 
    elevator_floor_1_button_pressed = 1'b1;
    floor_2_down_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;
    floor_2_down_button_pressed = 1'b0;

    #30 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    error_count = compare_outputs(1'b1, elevator_door_open_out, "Door open output", error_count);
    #30 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);

    // test case #9a
    #20 
    if (floor_1_out) begin
      testcase = "#9a Floor 1 -> Floor 3 / Pickup on Floor 2 pressed Floor 1";
    end
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    floor_1_up_button_pressed = 1'b1;
    #2 
    floor_1_up_button_pressed = 1'b0;

    #10 
    elevator_floor_3_button_pressed = 1'b1;
    floor_2_up_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;
    floor_2_up_button_pressed = 1'b0;

    #30 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    error_count = compare_outputs(1'b1, elevator_door_open_out, "Door open output", error_count);

    #10 
    elevator_floor_1_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;

    #20 
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);
    #50 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);

    // back to floor 3 for test case #9b
    #10 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    // test case #9b
    #80 
    if (floor_3_out) begin
      testcase = "#9b Floor 3 -> Floor 1 / Pickup on Floor 2 pressed Floor 3";
    end
    floor_3_down_button_pressed = 1'b1;
    #2 
    floor_3_down_button_pressed = 1'b0;

    #10 
    elevator_floor_1_button_pressed = 1'b1;
    floor_2_down_button_pressed = 1'b1;
    #2 
    elevator_floor_1_button_pressed = 1'b0;
    floor_2_down_button_pressed = 1'b0;

    #30 
    error_count = compare_outputs(1'b1, floor_2_out, "Floor 2 output", error_count);
    error_count = compare_outputs(1'b1, elevator_door_open_out, "Door open output", error_count);

    #10 
    elevator_floor_3_button_pressed = 1'b1;
    #2 
    elevator_floor_3_button_pressed = 1'b0;

    #20 
    error_count = compare_outputs(1'b1, floor_1_out, "Floor 1 output", error_count);
    #50 
    error_count = compare_outputs(1'b1, floor_3_out, "Floor 3 output", error_count);

    $display("\n***************************\nFINAL ERROR COUNT: %8d\n***************************", error_count);

    $display("===============================================FINISH==============================================\n");

    $finish;
  end

  function [7:0] compare_outputs (
		input	    expected_value, 
    input	    actual_value,
		input [8*19:0] signal_name,
    input [7:0] error_count);
    if ( expected_value == actual_value ) begin
      compare_outputs = error_count;	 
    end 
    else begin
      $display("    FAIL** %s: Expected = %b, Actual = %b, Time = %t", signal_name, expected_value, actual_value, $time);
      compare_outputs = error_count + 1;
    end
  endfunction // compare_outputs

endmodule
