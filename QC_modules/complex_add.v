module complex_add (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [7:0] res_real, res_imag
);
    assign res_real = a_real + b_real;
    assign res_imag = a_imag + b_imag;
endmodule


