module complex_add (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [7:0] res_real, res_imag
);

    wire signed [7:0] sum_real;
    wire signed [7:0] sum_imag;

    assign sum_real = //(a_real[7] == 1'b1 && b_real[7] == 1'b1) ? ((~a_real +1'b1) + (~b_real + 1'b1))  :
               //(a_real[7] == 1'b1 && b_real[7] == 1'b0) ? ((~a_real +1'b1) + b_real) :
               //(a_real[7] == 1'b0 && b_real[7] == 1'b1) ? (a_real + (~b_real +1'b1)) :
               (a_real + b_real);
    assign sum_imag = //(a_imag[7] == 1'b1 && b_imag[7] == 1'b1) ? ((~a_imag +1'b1) + (~b_imag +1'b1))  :
               //(a_imag[7] == 1'b1 && b_imag[7] == 1'b0) ? ((~a_imag +1'b1) + b_imag) :
               //(a_imag[7] == 1'b0 && b_imag[7] == 1'b1) ? (a_imag + (~b_imag +1'b1)) :
               (a_imag + b_imag);

    assign res_real = sum_real;
    assign res_imag = sum_imag;

endmodule