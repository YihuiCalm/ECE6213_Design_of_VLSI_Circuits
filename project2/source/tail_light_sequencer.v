`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE4150/6250
// Yihui Wang 
// Taillight sequencer for Mustang
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module tail_light_sequencer (
    input wire clk,
    input wire rst_n,
    input wire brake,
    input wire turn_right,
    input wire turn_left,

    output reg [2:0] right_tail_light_controll = 0,
    output reg [2:0] left_tail_light_controll = 0
);

    

    // State defination
    parameter idle = 5'b00000;
    parameter brake_only = 5'b00001;
    parameter right_only = 5'b00010;
    parameter left_only = 5'b00100;
    parameter brake_right = 5'b01000;
    parameter brake_left = 5'b10000;

    // State register
    reg [4:0] state = 0, next = 0;

    always @(posedge clk or negedge rst_n) begin
        if (rst_n == 1'b0) begin
            state <= idle;
        end
        else state <= next;
    end

    // State transition logic
    always @(*) begin
        case ({brake,turn_left,turn_right})
            3'b001: next = right_only;
            3'b010: next = left_only;
            3'b100: next = brake_only;
            3'b101: next = brake_right;
            3'b110: next = brake_left;
            default: next = idle;
        endcase
    end

    // Stage cycle counter
    wire next_stage;
    reg [4:0] counter = 5'b00001;

    always @(posedge clk or negedge rst_n) begin
        if ((rst_n == 1'b0) | (next != state)) begin
            counter <= 5'b00001;
        end
        else begin
            if (counter == 5'b10000) begin
                counter <= 5'b00001;
            end
            else begin
                counter <= counter << 1;
            end
        end
    end

    assign next_stage = (counter == 5'b10000);

    // Light output controll
    reg [2:0] right_tail_light_controll_next = 0;
    reg [2:0] left_tail_light_controll_next = 0;

    always @(posedge clk, negedge rst_n) begin
        if (rst_n == 1'b0) begin
            right_tail_light_controll <= 3'b0;
            left_tail_light_controll <= 3'b0;
        end
        else begin
            right_tail_light_controll <= right_tail_light_controll_next;
            left_tail_light_controll <= left_tail_light_controll_next;
        end
    end

    // Light output transition logic
    always @(*) begin
        
        case (next)

            brake_only: begin
                right_tail_light_controll_next <= 3'b111;
                left_tail_light_controll_next <= 3'b111;
            end

            right_only: begin
                if (state == right_only) begin
                    if (next_stage) begin
                        right_tail_light_controll_next <= {right_tail_light_controll[1:0],right_tail_light_controll[2]} + 3'd1;
                    end
                    else begin
                        right_tail_light_controll_next <= right_tail_light_controll;                           
                    end 
                    left_tail_light_controll_next <= 3'b0;
                end
                else begin
                    right_tail_light_controll_next <= 3'b001;
                    left_tail_light_controll_next <= 3'b0;
                end
            end

            left_only: begin
                if (state == left_only) begin
                    if (next_stage) begin
                        left_tail_light_controll_next <= {left_tail_light_controll[1:0],left_tail_light_controll[2]} + 3'd1;
                    end
                    else begin
                        left_tail_light_controll_next <= left_tail_light_controll;
                    end 
                    right_tail_light_controll_next <= 3'b0;
                end
                else begin
                    left_tail_light_controll_next <= 3'b001;
                    right_tail_light_controll_next <= 3'b0;
                end
            end

            brake_right: begin
                if (state == brake_right) begin
                    if (next_stage) begin
                        right_tail_light_controll_next <= {right_tail_light_controll[1:0],right_tail_light_controll[2]} - 3'd1;
                    end
                    else begin
                        right_tail_light_controll_next <= right_tail_light_controll;                           
                    end 
                    left_tail_light_controll_next <= 3'b111;
                end
                else begin
                    right_tail_light_controll_next <= 3'b111;
                    left_tail_light_controll_next <= 3'b111;
                end
            end

            brake_left: begin
                if (state == brake_left) begin
                    if (next_stage) begin
                        left_tail_light_controll_next <= {left_tail_light_controll[1:0],left_tail_light_controll[2]} - 3'd1;
                    end
                    else begin
                        left_tail_light_controll_next <= left_tail_light_controll;
                    end 
                    right_tail_light_controll_next <= 3'b111;
                end
                else begin
                    left_tail_light_controll_next <= 3'b111;
                    right_tail_light_controll_next <= 3'b111;
                end
            end

            default: begin
                right_tail_light_controll_next <= 3'b0;
                left_tail_light_controll_next <= 3'b0;
            end
            
        endcase
    end

endmodule
