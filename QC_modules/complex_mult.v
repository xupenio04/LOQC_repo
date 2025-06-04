module complex_mult #(
    parameter INT_BITS = 0,
    parameter FRAC_BITS = 16,
    parameter WIDTH = INT_BITS + FRAC_BITS
)(
    input wire signed [WIDTH-1:0] a_real, a_imag,
    input wire signed [WIDTH-1:0] b_real, b_imag,
    output wire signed [WIDTH-1:0] res_real, res_imag
);
   
    wire signed [2*WIDTH-1:0] ac = a_real * b_real;
    wire signed [2*WIDTH-1:0] bd = a_imag * b_imag;
    wire signed [2*WIDTH-1:0] ad = a_real * b_imag;
    wire signed [2*WIDTH-1:0] bc = a_imag * b_real;
    
    assign res_real = (ac - bd) >>> FRAC_BITS;
    assign res_imag = (ad + bc) >>> FRAC_BITS;
endmodule
