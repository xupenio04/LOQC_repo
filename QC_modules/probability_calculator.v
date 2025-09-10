
module probability_calculator (
    input signed [15:0] q0_real,
    input signed [15:0] q0_imag,
    input signed [15:0] q1_real,
    input signed [15:0] q1_imag,
    output wire [31:0] prob0
);

    wire [31:0] mag0_squared = (q0_real * q0_real) + (q0_imag * q0_imag);
    wire [31:0] mag1_squared = (q1_real * q1_real) + (q1_imag * q1_imag);
    
    wire [31:0] total_prob = mag0_squared + mag1_squared;

    wire [63:0] scaled_prob = {32'd0, mag0_squared} << 16;
    assign prob0 = (total_prob == 0) ? 32'd32768 : scaled_prob / total_prob;

endmodule