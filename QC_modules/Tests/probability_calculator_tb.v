`timescale 1ns/1ps

module tb_probability_basic;
    reg signed [15:0] q0_real, q0_imag, q1_real, q1_imag;
    wire [31:0] prob0;
    
    probability_calculator dut (
        .q0_real(q0_real),
        .q0_imag(q0_imag),
        .q1_real(q1_real),
        .q1_imag(q1_imag),
        .prob0(prob0)
    );
    
    // Converter para valor real (0.0 a 1.0)
    real prob0_real;
    assign prob0_real = $itor(prob0) / 65536.0;
    
    initial begin
        $display("=== Testbench Probability Calculator ===");
        $display("Time | Q0 | Q1 | Prob0 | Real");
        $display("----------------------------------------");

        $dumpvars(1, tb_probability_basic);
        
        // Teste 1: Estado |0⟩ puro (100%)
        q0_real = 16'd10000; q0_imag = 16'd0;
        q1_real = 16'd0; q1_imag = 16'd0;
        #10;
        $display("%t | %d+%di | %d+%di | %d | %.4f", 
                $time, q0_real, q0_imag, q1_real, q1_imag, 
                prob0, prob0_real);
        
        // Teste 2: Estado |1⟩ puro (0%)
        q0_real = 16'd0; q0_imag = 16'd0;
        q1_real = 16'd10000; q1_imag = 16'd0;
        #10;
        $display("%t | %d+%di | %d+%di | %d | %.4f", 
                $time, q0_real, q0_imag, q1_real, q1_imag, 
                prob0, prob0_real);
        
        // Teste 3: Superposição 50/50
        q0_real = 16'd7071; q0_imag = 16'd0;
        q1_real = 16'd7071; q1_imag = 16'd0;
        #10;
        $display("%t | %d+%di | %d+%di | %d | %.4f", 
                $time, q0_real, q0_imag, q1_real, q1_imag, 
                prob0, prob0_real);
        
        $finish;
    end

endmodule