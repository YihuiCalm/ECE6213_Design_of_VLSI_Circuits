`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE6213
// Yihui Wang
// Elevator top module
//
//
//////////////////////////////////////////////////////////////////////////////////

module elevator_top (input clk,
                            input rstn,
                            input floor_1_up_button_pressed,
                            input floor_2_up_button_pressed,
                            input floor_2_down_button_pressed,
                            input floor_3_down_button_pressed,
                            input elevator_floor_1_button_pressed,
                            input elevator_floor_2_button_pressed,
                            input elevator_floor_3_button_pressed,
                            output floor_1_out,
                            output floor_2_out,
                            output floor_3_out,
                            output elevator_door_open_out,
                            output floor_1_up_button_out,
                            output floor_2_up_button_out,
                            output floor_2_down_button_out,
                            output floor_3_down_button_out,
                            output elevator_floor_1_button_out,
                            output elevator_floor_2_button_out,
                            output elevator_floor_3_button_out);
    
    wire floor_1_up_button_clear;
    wire floor_2_up_button_clear;
    wire floor_2_down_button_clear;
    wire floor_3_down_button_clear;
    wire elevator_floor_1_button_clear;
    wire elevator_floor_2_button_clear;
    wire elevator_floor_3_button_clear;
    
    elevator_controller elevator_controller_inst (
    .clk                          (clk),
    .rstn                         (rstn),
    .floor_1_up_button            (floor_1_up_button_out),
    .floor_2_up_button            (floor_2_up_button_out),
    .floor_2_down_button          (floor_2_down_button_out),
    .floor_3_down_button          (floor_3_down_button_out),
    .elevator_floor_1_button      (elevator_floor_1_button_out),
    .elevator_floor_2_button      (elevator_floor_2_button_out),
    .elevator_floor_3_button      (elevator_floor_3_button_out),
    .floor_1                      (floor_1_out),
    .floor_2                      (floor_2_out),
    .floor_3                      (floor_3_out),
    .elevator_door_open           (elevator_door_open_out),
    .floor_1_up_button_clear      (floor_1_up_button_clear),
    .floor_2_up_button_clear      (floor_2_up_button_clear),
    .floor_2_down_button_clear    (floor_2_down_button_clear),
    .floor_3_down_button_clear    (floor_3_down_button_clear),
    .elevator_floor_1_button_clear(elevator_floor_1_button_clear),
    .elevator_floor_2_button_clear(elevator_floor_2_button_clear),
    .elevator_floor_3_button_clear(elevator_floor_3_button_clear)
    );
    
    elevator_button floor_1_up_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(floor_1_up_button_pressed),
    .clear         (floor_1_up_button_clear),
    .button_out    (floor_1_up_button_out)
    );
    
    elevator_button floor_2_up_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(floor_2_up_button_pressed),
    .clear         (floor_2_up_button_clear),
    .button_out    (floor_2_up_button_out)
    );
    
    elevator_button floor_2_down_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(floor_2_down_button_pressed),
    .clear         (floor_2_down_button_clear),
    .button_out    (floor_2_down_button_out)
    );
    
    elevator_button floor_3_down_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(floor_3_down_button_pressed),
    .clear         (floor_3_down_button_clear),
    .button_out    (floor_3_down_button_out)
    );
    
    elevator_button elevator_floor_1_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(elevator_floor_1_button_pressed),
    .clear         (elevator_floor_1_button_clear),
    .button_out    (elevator_floor_1_button_out)
    );
    
    elevator_button elevator_floor_2_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(elevator_floor_2_button_pressed),
    .clear         (elevator_floor_2_button_clear),
    .button_out    (elevator_floor_2_button_out)
    );
    
    elevator_button elevator_floor_3_button (
    .clk           (clk),
    .rst_n         (rstn),
    .button_pressed(elevator_floor_3_button_pressed),
    .clear         (elevator_floor_3_button_clear),
    .button_out    (elevator_floor_3_button_out)
    );
    
    
endmodule
