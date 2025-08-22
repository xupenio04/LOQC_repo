`timescale 1ns/1ps

module complex_add_tb;

    // Signals
    reg signed [7:0] a_real, a_imag;
    reg signed [7:0] b_real, b_imag;
    wire signed [7:0] res_real, res_imag;
    
    complex_add uut (
        .a_real(a_real),
        .a_imag(a_imag),
        .b_real(b_real),
        .b_imag(b_imag),
        .res_real(res_real),
        .res_imag(res_imag)
    );

    initial begin
        $dumpfile("complex_add_tb.vcd");
        $dumpvars(0, complex_add_tb);
        
        $display("Time\tA_real\tA_imag\tB_real\tB_imag\tResult_real\tResult_imag");
        $display("----------------------------------------------------------------");

        // Test case 1
        a_real = 8'h20; // 0.5
        a_imag = 8'h10; // 0.25
        b_real = 8'h30; // 0.75
        b_imag = 8'hE0; // -0.5
        #10;
        $display("%0t\t%h\t%h\t%h\t%h\t%h\t\t%h", $time, a_real, a_imag, b_real, b_imag, res_real, res_imag);

        // Test case 2
        a_real = 8'h40; // 1.0
        a_imag = 8'h40; // 1.0
        b_real = 8'h40; // 1.0
        b_imag = 8'hC0; // -1.0
        #10;
        $display("%0t\t%h\t%h\t%h\t%h\t%h\t\t%h", $time, a_real, a_imag, b_real, b_imag, res_real, res_imag);

        // Test case 3
        a_real = 8'hC0; // -1.0
        a_imag = 8'h40; // 1.0
        b_real = 8'h40; // 1.0
        b_imag = 8'h40; // 1.0
        #10;
        $display("%0t\t%h\t%h\t%h\t%h\t%h\t\t%h", $time, a_real, a_imag, b_real, b_imag, res_real, res_imag);

        // Test case 4
        a_real = 8'h00; // 0.0
        a_imag = 8'h40; // 1.0
        b_real = 8'h00; // 0.0 
        b_imag = 8'h40; // 1.0
        #10;
        $display("%0t\t%h\t%h\t%h\t%h\t%h\t\t%h", $time, a_real, a_imag, b_real, b_imag, res_real, res_imag);
        
        $display("----------------------------------------------------------------");
        $display("Simulation completed!");
    end
    
endmodule