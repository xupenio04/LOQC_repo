module bd_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8)
(input signed [7:0] a_imag,
 input signed [7:0] b_imag,
 output signed [7:0] bd
 );

    wire signed [15:0] mult;

    assign mult =
    (a_imag == 8'b00000000 || b_imag == 8'b00000000) ? 16'b0 :
    (a_imag == 8'b01111111 && b_imag != 8'b10000000 && b_imag != 8'b00000000)     ? {b_imag-1'b1, 8'b0} :
    ((a_imag == 8'b01111111 && b_imag == 8'b10000000))     ? {~a_imag + 1'b1, 8'b0}    :
    ((a_imag == 8'b10000000 && b_imag == 8'b01111111))     ? {~b_imag + 1'b1, 8'b0}    :
    (a_imag == 8'b10000000 && b_imag != 8'b00000000 && b_imag != 8'b10000000)    ? {~b_imag + 1'b1, 8'b0} :
    (a_imag == 8'b10000000 && b_imag == 8'b10000000)     ? {~b_imag, 8'b0} :
    (a_imag != 8'b01111111 && a_imag != 8'b10000000 && b_imag == 8'b01111111) ? {a_imag-1'b1
    , 8'b0}:
    (a_imag != 8'b01111111 && a_imag != 8'b10000000 && b_imag == 8'b10000000 && a_imag != 8'b00000000) ? {~a_imag + 1'b1, 8'b0}:
    (a_imag[7] == 1'b1 && b_imag[7] == 1'b1) ? ({8'b0,(~a_imag +1'b1)} * {8'b0,(~b_imag +1'b1)})  :
    (a_imag[7] == 1'b1 && b_imag[7] == 1'b0) ? -({8'b0,(~a_imag +1'b1)} * {8'b0,b_imag}) :
    (a_imag[7] == 1'b0 && b_imag[7] == 1'b1) ? -({8'b0,a_imag} * {8'b0,(~b_imag +1'b1)}) :
    ({8'b0,a_imag} * {8'b0,b_imag});
    
    assign bd = mult >>> SHIFT_BITS;


endmodule