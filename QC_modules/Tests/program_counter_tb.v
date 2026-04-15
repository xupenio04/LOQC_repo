`timescale 1ns/1ps

module program_counter_tb;

  
    parameter ADDR_WIDTH = 8;
    
    
    reg clk;
    reg reset;
    wire [ADDR_WIDTH-1:0] pc;
    
    
    reg [ADDR_WIDTH-1:0] expected_pc;
    
    // Instantiate DUT
    program_counter #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );
    
    
    always #5 clk = ~clk;
    
    
    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);
        
        clk = 0;
        reset = 0;
        expected_pc = 0;
        
        $display("Testing Program Counter...");
        $display("Time\tReset\tPC\tExpected\tStatus");
        $display("---------------------------------------------");
        
        
        #10;
        check_result("Reset active");
        
        
        reset = 1;
        #10; 
        expected_pc = 1; 
        check_result("First clock after reset release");
        
       
        #10;
        expected_pc = 2;
        check_result("Second count");
        
      
        #10;
        expected_pc = 3;
        check_result("Third count");
        
        
        reset = 0;
        #2; 
        expected_pc = 0;
        check_result("Reset asserted");
        
        #8; 
        check_result("Reset still active");
        
        
        reset = 1;
        #10; 
        expected_pc = 1; 
        check_result("After reset release");
        
        #10; 
        expected_pc = 2;
        check_result("Count after reset");
        
        $display("---------------------------------------------");
        $display("All tests completed!");
        $finish;
    end
    
    
    task check_result;
        input string test_name;
        begin
            if (pc === expected_pc)
                $display("%0t\t%b\t%0d\t%0d\t\tPASS - %s", $time, reset, pc, expected_pc, test_name);
            else
                $display("%0t\t%b\t%0d\t%0d\t\tFAIL - %s", $time, reset, pc, expected_pc, test_name);
        end
    endtask
    
endmodule