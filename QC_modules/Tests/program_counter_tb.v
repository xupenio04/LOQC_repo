`timescale 1ns/1ps

module program_counter_tb;

    // Parameters
    parameter ADDR_WIDTH = 8;
    
    // Signals
    reg clk;
    reg reset;
    wire [ADDR_WIDTH-1:0] pc;
    
    // Expected values
    reg [ADDR_WIDTH-1:0] expected_pc;
    
    // Instantiate DUT
    program_counter #(
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .pc(pc)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Test sequence with automatic verification
    initial begin
        $dumpfile("program_counter_tb.vcd");
        $dumpvars(0, program_counter_tb);
        
        clk = 0;
        reset = 0;
        expected_pc = 0;
        
        $display("Testing Program Counter...");
        $display("Time\tReset\tPC\tExpected\tStatus");
        $display("---------------------------------------------");
        
        // Test 1: Reset behavior (PC should be 0)
        #10;
        check_result("Reset active");
        
        // Test 2: Release reset - PC increments on same clock edge!
        reset = 1;
        #10; // Wait for clock edge - PC increments immediately
        expected_pc = 1; // Increments on same edge when reset is released
        check_result("First clock after reset release");
        
        // Test 3: Next clock cycle - PC should increment to 2
        #10;
        expected_pc = 2;
        check_result("Second count");
        
        // Test 4: Another clock cycle - PC should increment to 3
        #10;
        expected_pc = 3;
        check_result("Third count");
        
        // Test 5: Reset during operation - should reset immediately
        reset = 0;
        #2; // Check async reset works immediately
        expected_pc = 0;
        check_result("Reset asserted");
        
        #8; // Complete the clock cycle
        check_result("Reset still active");
        
        // Test 6: Release reset and check behavior - increments immediately
        reset = 1;
        #10; // Wait for clock edge
        expected_pc = 1; // Increments immediately when reset released
        check_result("After reset release");
        
        #10; // Next clock cycle
        expected_pc = 2;
        check_result("Count after reset");
        
        $display("---------------------------------------------");
        $display("All tests completed!");
        $finish;
    end
    
    // Task to check results
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