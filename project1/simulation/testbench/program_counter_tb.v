`timescale 1ns / 1ps

module program_counter_tb(
    );

    initial begin
		$dumpfile("program_counter.vcd");
		$dumpvars(0,program_counter_tb);
	end

    // string to display section labels on waveforms, change its radix 
    //      to ASCII in the waveform to view correctly
    reg     [(20*8)-1:0] str1;      
       
    reg     clk;
    reg     rst_n;
    reg     update_msbs;
    reg     update_lsbs;
    reg     jump;
    reg     [5:0] jump_destination;
    reg     branch;
    reg     [5:0] branch_offset;
    wire    [7:0] mem_addr;
      
    program_counter DUT(
    .clk(clk),
    .rst_n(rst_n),
    .update_msbs(update_msbs),
    .update_lsbs(update_lsbs),
    .jump(jump),
    .jump_destination(jump_destination),
    .branch(branch),
    .branch_offset(branch_offset),
    .mem_addr(mem_addr)
    );
    
        always #5 clk = ~clk;
    
    initial begin
        // initial values
        clk             = 0;
        rst_n           = 1;
        update_msbs     = 0;
        update_lsbs     = 0;
        jump            = 0;
        jump_destination = 6'h00;
        branch          = 0;
        branch_offset   = 6'h00;
        str1            = "Reset_Checks";
        
        // check that reset works
        #12  
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'hXX, mem_addr, $time);
        // activate reset and check
        rst_n       = 0;
        #1
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h00, mem_addr, $time);
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h00, mem_addr, $time);
        // release reset and check
        rst_n       = 1;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h00, mem_addr, $time);
        
        // check updating program counter LSBs for normal operation
        str1            = "LSBs_update";
        update_lsbs     = 1;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h01, mem_addr, $time);
        update_lsbs     = 0;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h01, mem_addr, $time);
        update_lsbs     = 1;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h02, mem_addr, $time);
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h03, mem_addr, $time);
        #10
        // update lsbs only iterates bottom two bits, count should loop back arount to 00
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h00, mem_addr, $time);
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h01, mem_addr, $time);
        // stop update lsbs, check that it retains value
        update_lsbs     = 0;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h01, mem_addr, $time);

        // check updating program counter MSBs for normal operation        
        str1            = "MSBs_update";
        update_msbs     = 1;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h04, mem_addr, $time);
        update_msbs     = 0;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h04, mem_addr, $time);
        update_msbs     = 1;       
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h08, mem_addr, $time);
        update_msbs     = 0;   
        update_lsbs     = 1;     
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h09, mem_addr, $time);      
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h0A, mem_addr, $time);
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h0B, mem_addr, $time);
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h08, mem_addr, $time);
        update_msbs     = 1;   
        update_lsbs     = 0;     
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h0C, mem_addr, $time);  
        update_msbs     = 0;
        
        // check jump mode      
        str1            = "Jump"; 
        jump             = 1;
        jump_destination = 6'h0F;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h3C, mem_addr, $time); 
        jump_destination = 6'h0A;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h28, mem_addr, $time); 
        jump             = 0;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h28, mem_addr, $time);
        
        // check branch
        str1            = "Banch"; 
        branch          = 1;
        branch_offset   = 6'h3F;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h24, mem_addr, $time); 
        branch_offset   = 6'h04;
        #10
        $display ( " mem_addr: Expected %h, Read %h, Time %d" , 8'h34, mem_addr, $time);
        branch          = 0;



        #30 
        $finish;         
    end  
    
endmodule
