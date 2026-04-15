`timescale 1ns/1ps

module tb_complex_add;

    // Inputs
    reg signed [7:0] a_real, a_imag;
    reg signed [7:0] b_real, b_imag;

    // Outputs
    wire signed [7:0] res_real, res_imag;

    // Instantiate the module under test (UUT)
    complex_add uut (
        .a_real(a_real),
        .a_imag(a_imag),
        .b_real(b_real),
        .b_imag(b_imag),
        .res_real(res_real),
        .res_imag(res_imag)
    );

    // Test procedure
    initial begin
        $display("=== Complex Add Testbench (Binary Inputs) ===");
        $display("Time | a_real a_imag | b_real b_imag | res_real res_imag | Decimal Results");

        // Test 1: Simple addition
        a_real = 8'b00001010; a_imag = 8'b00000101;   // +10, +5
        b_real = 8'b00000011; b_imag = 8'b00000111;   // +3, +7
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        // Test 2: Negative + positive
        a_real = 8'b11101100; a_imag = 8'b00001111;   // -20, +15
        b_real = 8'b00011001; b_imag = 8'b11111011;   // +25, -5
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        // Test 3: Both negative
        a_real = 8'b11001110; a_imag = 8'b11000100;   // -50, -60
        b_real = 8'b11110110; b_imag = 8'b11101100;   // -10, -20
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di (expected -60 -80i)",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        // Test 4: Positive overflow (127 + 100)
        a_real = 8'b01111111; a_imag = 8'b01111000;   // +127, +120
        b_real = 8'b01100100; b_imag = 8'b00110010;   // +100, +50
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di (overflow expected)",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        // Test 5: Negative overflow (-128 - 50)
        a_real = 8'b10000000; a_imag = 8'b10011100;   // -128, -100
        b_real = 8'b11001110; b_imag = 8'b11000100;   // -50, -60
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di (neg overflow expected)",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        // Test 6: Mixed signs
        a_real = 8'b10011100; a_imag = 8'b00110010;   // -100, +50
        b_real = 8'b01000110; b_imag = 8'b10011100;   // +70, -100
        #10;
        $display("%4dns | %b %b | %b %b | %b %b | %4d + %4di",
                 $time, a_real, a_imag, b_real, b_imag, res_real, res_imag,
                 res_real, res_imag);

        $display("=== Testbench Finished ===");
        $stop;
    end

endmodule
