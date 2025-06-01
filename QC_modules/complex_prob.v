module complex_prob #(
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS
)(
    input wire signed [WIDTH-1:0] real_part,
    input wire signed [WIDTH-1:0] imag_part,
    output wire signed [WIDTH-1:0] prob_sq
);
    // |a+bi|² = a² + b²
    wire signed [2*WIDTH-1:0] real_sq = real_part * real_part;
    wire signed [2*WIDTH-1:0] imag_sq = imag_part * imag_part;
    
    assign prob_sq = (real_sq + imag_sq) >>> FRAC_BITS;
endmodule