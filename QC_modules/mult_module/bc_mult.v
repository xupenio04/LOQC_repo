module bc_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8)
(input signed [7:0] a_imag,
 input signed [7:0] b_real,
 output signed [7:0] bc
 );

    wire signed [15:0] mult;

   assign mult =

   assign mult =
    (a_imag == 8'b00000000 || b_real == 8'b00000000) ? 16'b0 :
    (a_imag == 8'b01111111 && b_real != 8'b10000000 && b_real != 8'b00000000)     ? {b_real-1'b1, 8'b0} :
    ((a_imag == 8'b01111111 && b_real == 8'b10000000))     ? {~a_imag + 1'b1, 8'b0}    :
    ((a_imag == 8'b10000000 && b_real == 8'b01111111))     ? {~b_real + 1'b1, 8'b0}    :
    (a_imag == 8'b10000000 && b_real != 8'b00000000 && b_real != 8'b10000000)    ? {~b_real + 1'b1, 8'b0} :
    (a_imag == 8'b10000000 && b_real == 8'b10000000)     ? {~b_real, 8'b0} :
    (a_imag != 8'b01111111 && a_imag != 8'b10000000 && b_real == 8'b01111111) ? {a_imag-1'b1
    , 8'b0}:
    (a_imag != 8'b01111111 && a_imag != 8'b10000000 && b_real == 8'b10000000 && a_imag != 8'b00000000) ? {~a_imag + 1'b1, 8'b0}:
    (a_imag[7] == 1'b1 && b_real[7] == 1'b1) ? ({8'b0,(~a_imag +1'b1)} * {8'b0,(~b_real +1'b1)})  :
    (a_imag[7] == 1'b1 && b_real[7] == 1'b0) ? -({8'b0,(~a_imag +1'b1)} * {8'b0,b_real}) :
    (a_imag[7] == 1'b0 && b_real[7] == 1'b1) ? -({8'b0,a_imag} * {8'b0,(~b_real +1'b1)}) :
    ({8'b0,a_imag} * {8'b0,b_real});
    
    assign bc = mult >>> SHIFT_BITS;

endmodule