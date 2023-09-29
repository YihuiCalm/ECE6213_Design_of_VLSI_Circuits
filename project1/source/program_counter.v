`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ECE4150/6250
// Matthew LaRue 
// Program Counter for MIPS processor
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module program_counter(
    clk,
    rst_n,
    update_msbs,
    update_lsbs,
    jump,
    jump_destination,
    branch,
    branch_offset,
    mem_addr
    );
    
    // declare port directions
    input clk;
    input rst_n;
    input update_msbs;
    input update_lsbs;
    input jump;
    input jump_destination;
    input branch;
    input branch_offset;
    output mem_addr;
    
    // declare port types/sizes
    wire clk;
    wire rst_n;
    wire update_msbs;
    wire update_lsbs;
    wire jump;
    wire [5:0] jump_destination;
    wire branch;
    wire [5:0] branch_offset;
    reg  [7:0] mem_addr;
    
    // internal variables
    reg [7:0] mem_addr_next;
    
    
    // clock iregisters, asynch active-low reset    
    always @(posedge clk or negedge rst_n)
    begin
        if (rst_n == 1'b0) begin
            mem_addr <= 8'h00;
        end else begin
            mem_addr <= mem_addr_next;
        end   
    end
    
    always @(mem_addr, update_msbs, update_lsbs, jump, jump_destination, branch, branch_offset)
    begin
        mem_addr_next = mem_addr;
        
        if (update_msbs == 1'b1) begin
            // use "update_msbs" to progress one instruction, each instruction is 4 memory addresses 
            //    so it counts in increments of 4
            mem_addr_next[7:2] = mem_addr[7:2] + 1'b1;
            mem_addr_next[1:0] = 2'b00;
        end else if (update_lsbs == 1'b1) begin
            // use "update_lsbs" to progress to the next memory address, use it to advance to the next
            //    8 bits of an instruction
            mem_addr_next[1:0] = mem_addr[1:0] + 1'b1;
        end else if (jump == 1'b1) begin
            // use "jump" for the jump command, jumps to the instruction indicated. 
            mem_addr_next[7:2] = jump_destination;
            mem_addr_next[1:0] = 2'b00;
        end else if (branch == 1'b1) begin
            // use "branch" for the "branch if equal" command, branches to 
            //    current instruction number + branch_offset
            mem_addr_next[7:2] = mem_addr[7:2] + branch_offset;
            mem_addr_next[1:0] = 2'b00;
        end
     end
       
endmodule
