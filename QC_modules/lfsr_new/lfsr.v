// Project F Library - Galois Linear-Feedback Shift Register
// (C)2022 Will Green, open source hardware released under the MIT License
// Learn more at https://projectf.io

`default_nettype none
`timescale 1ns / 1ps

// NB. Ensure reset is asserted for one or more cycles before enable

module lfsr #(
    parameter LEN=8,                   // shift register length
    parameter TAPS=8'b10111000         // XOR taps
    ) (
    input  wire clk,                   // clock
    input  wire rst,                   // reset
    input  wire en,                    // enable
    input  wire [LEN-1:0] seed,        // seed (uses default seed if zero)
    output reg  [LEN-1:0] sreg         // lfsr output
    );

    always @(posedge clk) begin
        if (rst) begin
            if (seed != 0)
                sreg <= seed;
            else
                sreg <= {LEN{1'b1}};
        end
        else if (en) begin
            sreg <= {1'b0, sreg[LEN-1:1]} ^ (sreg[0] ? TAPS : {LEN{1'b0}});
        end
    end

endmodule