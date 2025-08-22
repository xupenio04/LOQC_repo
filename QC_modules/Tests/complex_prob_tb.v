`timescale 1ns/1ps

module complex_prob_tb;

    // Parameters
    parameter WIDTH = 8;
    
    // Signals
    reg signed [WIDTH-1:0] real_part;
    reg signed [WIDTH-1:0] imag_part;
  wire signed [2*WIDTH-1:0] prob_sq;
    
    // Instantiate DUT
    complex_prob #(
        .WIDTH(WIDTH)
    ) dut (
        .real_part(real_part),
        .imag_part(imag_part),
        .prob_sq(prob_sq)
    );
    
    // Test sequence
    initial begin
        $dumpfile("complex_prob_tb.vcd");
        $dumpvars(0, complex_prob_tb);
        
        $display("Time\tReal\tImag\tProb_sq\tExpected");
        $display("----------------------------------------");
        
        // Test case 1: (0.5 + 0.25i)
        real_part = 8'h40; // 1.0 in Q1.6
        imag_part = 8'h20; // 0.5 in Q1.6
        #10;
        // Expected: (1.0² + 0.5²) = (1.0 + 0.25) = 1.25 → 1.25 >> 6 = 0.0195
        $display("%0t\t%h\t%h\t%h\t1.25", $time, real_part, imag_part, prob_sq);
        
        // Test case 2: (1.0 + 1.0i)
        real_part = 8'h40; // 1.0
        imag_part = 8'h40; // 1.0
        #10;
        // Expected: (1.0² + 1.0²) = (1.0 + 1.0) = 2.0 → 2.0 >> 6 = 0.03125
        $display("%0t\t%h\t%h\t%h\t2.0", $time, real_part, imag_part, prob_sq);
        
        // Test case 3: (0.0 + 1.0i)
        real_part = 8'h00; // 0.0
        imag_part = 8'h40; // 1.0
        #10;
        // Expected: (0.0² + 1.0²) = (0.0 + 1.0) = 1.0 → 1.0 >> 6 = 0.015625
        $display("%0t\t%h\t%h\t%h\t1.0", $time, real_part, imag_part, prob_sq);
        
        // Test case 4: (-1.0 + 0.0i)
        real_part = 8'hC0; // -1.0
        imag_part = 8'h00; // 0.0
        #10;
        // Expected: ((-1.0)² + 0.0²) = (1.0 + 0.0) = 1.0 → 1.0 >> 6 = 0.015625
        $display("%0t\t%h\t%h\t%h\t1.0", $time, real_part, imag_part, prob_sq);
        
        // Test case 5: (0.5 + 0.0i)
        real_part = 8'h20; // 0.5
        imag_part = 8'h00; // 0.0
        #10;
        // Expected: (0.5² + 0.0²) = (0.25 + 0.0) = 0.25 → 0.25 >> 6 = 0.0039
        $display("%0t\t%h\t%h\t%h\t0.25", $time, real_part, imag_part, prob_sq);
        
        // Test case 6: Maximum values
        real_part = 8'h7F; // 1.984375 (max positive)
        imag_part = 8'h7F; // 1.984375 (max positive)
        #10;
        // Expected: (1.984375² + 1.984375²) ≈ (3.937 + 3.937) = 7.874 → 7.874 >> 6 = 0.123
        $display("%0t\t%h\t%h\t%h\t~7.87", $time, real_part, imag_part, prob_sq);
        
        $display("----------------------------------------");
        $display("Simulation completed!");
        $finish;
    end
    
endmodule