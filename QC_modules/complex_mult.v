module complex_mult (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [15:0] res_real, res_imag
);
    wire signed [15:0] ac = a_real * b_real;
    wire signed [15:0] bd = a_imag * b_imag;
    wire signed [15:0] ad = a_real * b_imag;
    wire signed [15:0] bc = a_imag * b_real;
    
    assign res_real = ac - bd;
    assign res_imag = ad + bc;
endmodule