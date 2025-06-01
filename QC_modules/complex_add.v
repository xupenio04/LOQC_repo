module complex_add #(
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS
)(
    input wire signed [WIDTH-1:0] a_real, a_imag,
    input wire signed [WIDTH-1:0] b_real, b_imag,
    output wire signed [WIDTH-1:0] res_real, res_imag
);
    assign res_real = a_real + b_real;
    assign res_imag = a_imag + b_imag;
endmodule
