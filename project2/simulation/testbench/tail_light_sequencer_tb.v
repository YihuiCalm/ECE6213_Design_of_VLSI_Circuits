`timescale 1ns / 1ps

module tail_light_sequencer_tb ();

    initial begin
		$dumpfile("tail_light_sequencer_tb.vcd");
		$dumpvars(0,tail_light_sequencer_tb);
	end

    reg clk = 0;
    reg rst_n = 0;
    reg brake = 0;
    reg turn_left = 0;
    reg turn_right = 0;

    wire [2:0] right_tail_light_controll;
    wire [2:0] left_tail_light_controll;

    tail_light_sequencer sequencer(
        .clk(clk),
        .rst_n(rst_n),
        .brake(brake),
        .turn_right(turn_right),
        .turn_left(turn_left),
        .right_tail_light_controll(right_tail_light_controll),
        .left_tail_light_controll(left_tail_light_controll)
    );

    always begin
        #1 
        clk = ~clk;
        $display ( "Brake = %b, turn_right = %b, turn_left = %b, right_tail_light = %b, left_tail_light = %b, Time %d" , brake, turn_right, turn_left, right_tail_light_controll, left_tail_light_controll, $time);
    end

    initial begin
        #10
        rst_n = 1;

        #100 
        brake = 1;
        turn_left = 0;
        turn_right = 0;
        
        #100 
        brake = 0;
        turn_left = 1;
        turn_right = 0;

        #100 
        brake = 0;
        turn_left = 0;
        turn_right = 1;

        #100 
        brake = 1;
        turn_left = 1;
        turn_right = 0;

        #100 
        brake = 1;
        turn_left = 0;
        turn_right = 1;

        #100 
        brake = 0;
        turn_left = 1;
        turn_right = 0;

        #3 
        brake = 1;
        turn_left = 1;
        turn_right = 0;

        #100 
        brake = 0;
        turn_left = 0;
        turn_right = 1;

        #3 
        brake = 1;
        turn_left = 0;
        turn_right = 1;

        #100
        $finish;
    
    end

    endmodule
