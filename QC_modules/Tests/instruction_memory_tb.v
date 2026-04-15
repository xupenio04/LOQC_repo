`timescale 1ns/1ps

module instruction_memory_tb;

    // Parameters
    parameter ADDR_WIDTH = 8;
    parameter INSTR_WIDTH = 1;
    parameter OP_COMPUTE = 1'b0;
    parameter OP_MEASURE = 1'b1;
    
    // Signals
    reg clk;
    reg [ADDR_WIDTH-1:0] addr;
    wire [INSTR_WIDTH-1:0] instruction;
    
    // Instantiate DUT
    instruction_memory #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .INSTR_WIDTH(INSTR_WIDTH),
        .OP_COMPUTE(OP_COMPUTE),
        .OP_MEASURE(OP_MEASURE)
    ) dut (
        .clk(clk),
        .addr(addr),
        .instruction(instruction)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test sequence
    initial begin
        // Initialize
        $dumpfile("instruction_memory_tb.vcd");
        $dumpvars(0, instruction_memory_tb);
        
        clk = 0;
        addr = 0;
        
        $display("Time\tAddress\tInstruction");
        $display("----------------------------");
        
      
        #10;
        addr = 0;
        #10;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        addr = 1;
        #10;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        addr = 2;
        #10;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        
        addr = 3;
        #10;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        addr = 255;
        #10;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        
        addr = 0;
        #2; 
        addr = 1;
        #8;
        $display("%0t\t%0d\t%b", $time, addr, instruction);
        
        $display("----------------------------");
        $display("Simulation completed!");
        $finish;
    end
    
endmodule