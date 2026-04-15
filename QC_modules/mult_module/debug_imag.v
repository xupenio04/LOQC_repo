module complex_mult # ( INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8, MULTIPLY_BITS=1
 ) (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [7:0] res_real, res_imag
);

    wire signed [15:0] ac;
    wire signed [15:0] bd;
    wire signed [15:0] ad;
    wire signed [15:0] bc;

    ac_mult #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        .SHIFT_BITS(SHIFT_BITS),
        .MULTIPLY_BITS(MULTIPLY_BITS)
    ) ac_mult_inst (
        .a_real(a_real),
        .b_real(b_real),
        .ac(ac)
    );

    bd_mult #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        .SHIFT_BITS(SHIFT_BITS),
        .MULTIPLY_BITS(MULTIPLY_BITS)
    ) bd_mult_inst (
        .a_imag(a_imag),
        .b_imag(b_imag),
        .bd(bd)
    );

    ad_mult #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        .SHIFT_BITS(SHIFT_BITS),
        .MULTIPLY_BITS(MULTIPLY_BITS)
    ) ad_mult_inst (
        .a_real(a_real),
        .b_imag(b_imag),
        .ad(ad)
    );

    bc_mult #(
        .INT_BITS(INT_BITS),
        .FRAC_BITS(FRAC_BITS),
        .SHIFT_BITS(SHIFT_BITS),
        .MULTIPLY_BITS(MULTIPLY_BITS)
    ) bc_mult_inst (
        .a_imag(a_imag),
        .b_real(b_real),
        .bc(bc)
    );

    wire [15:0] res_real_full = ac - bd;
    wire [15:0] res_imag_full = ad + bc;
    assign res_real = res_real_full >>> SHIFT_BITS;
    assign res_imag = res_imag_full >>> SHIFT_BITS;


endmodule

module ac_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8, MULTIPLY_BITS=1)
(input signed [7:0] a_real,
 input signed [7:0] b_real,
 output signed [15:0] ac
 );

    wire signed [15:0] mult;

   assign mult =
    (a_real == 8'b00000000 || b_real == 8'b00000000) ? 16'b0 :
    (a_real == 8'b01111111 && b_real != 8'b10000000 && b_real != 8'b00000000)     ? {b_real-1'b1, 8'b0} :
    ((a_real == 8'b01111111 && b_real == 8'b10000000))     ? {~a_real + 1'b1, 8'b0}    :
    ((a_real == 8'b10000000 && b_real == 8'b01111111))     ? {~b_real + 1'b1, 8'b0}    :
    (a_real == 8'b10000000 && b_real != 8'b00000000 && b_real != 8'b10000000)    ? {~b_real + 1'b1, 8'b0} :
    (a_real == 8'b10000000 && b_real == 8'b10000000)     ? {~b_real, 8'b0} :
    (a_real != 8'b01111111 && a_real != 8'b10000000 && b_real == 8'b01111111) ? {a_real-1'b1
    , 8'b0}:
    (a_real != 8'b01111111 && a_real != 8'b10000000 && b_real == 8'b10000000 && a_real != 8'b00000000) ? {~a_real + 1'b1, 8'b0}:
    (a_real[7] == 1'b1 && b_real[7] == 1'b1) ? ({8'b0,(~a_real +1'b1)} * {8'b0,(~b_real +1'b1)})  <<< MULTIPLY_BITS :
    (a_real[7] == 1'b1 && b_real[7] == 1'b0) ? ~(({8'b0,(~a_real +1'b1)} * {8'b0,b_real})) + 1'b1 <<< MULTIPLY_BITS :
    (a_real[7] == 1'b0 && b_real[7] == 1'b1) ? ~(({8'b0,a_real} * {8'b0,(~b_real +1'b1)})) + 1'b1 <<< MULTIPLY_BITS :
    (({8'b0,a_real} * {8'b0,b_real})) <<< MULTIPLY_BITS;
    
    assign ac = mult ;


endmodule


module ad_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8, MULTIPLY_BITS=1)
(input signed [7:0] a_real,
 input signed [7:0] b_imag,
 output signed [15:0] ad
 );

    wire signed [15:0] mult;

   assign mult =
    (a_real == 8'b00000000 || b_imag == 8'b00000000) ? 16'b0 :
    (a_real == 8'b01111111 && b_imag != 8'b10000000 && b_imag != 8'b00000000)     ? {b_imag-1'b1, 8'b0} :
    ((a_real == 8'b01111111 && b_imag == 8'b10000000))     ? {~a_real + 1'b1, 8'b0}    :
    ((a_real == 8'b10000000 && b_imag == 8'b01111111))     ? {~b_imag + 1'b1, 8'b0}    :
    (a_real == 8'b10000000 && b_imag != 8'b00000000 && b_imag != 8'b10000000)    ? {~b_imag + 1'b1, 8'b0} :
    (a_real == 8'b10000000 && b_imag == 8'b10000000)     ? {~b_imag, 8'b0} :
    (a_real != 8'b01111111 && a_real != 8'b10000000 && b_imag == 8'b01111111) ? {a_real-1'b1
    , 8'b0}:
    (a_real != 8'b01111111 && a_real != 8'b10000000 && b_imag == 8'b10000000 && a_real != 8'b00000000) ? {~a_real + 1'b1, 8'b0}:
    (a_real[7] == 1'b1 && b_imag[7] == 1'b1) ? (({8'b0,(~a_real +1'b1)} * {8'b0,(~b_imag +1'b1)}))  <<< MULTIPLY_BITS :
    (a_real[7] == 1'b1 && b_imag[7] == 1'b0) ? ~(({8'b0,(~a_real +1'b1)} * {8'b0,b_imag})) + 1'b1 <<< MULTIPLY_BITS :
    (a_real[7] == 1'b0 && b_imag[7] == 1'b1) ? ~(({8'b0,a_real} * {8'b0,(~b_imag +1'b1)})) + 1'b1 <<< MULTIPLY_BITS :
    ((({8'b0,a_real} * {8'b0,b_imag})) <<< MULTIPLY_BITS);
    
    assign ad = mult;
    



endmodule

module bc_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8, MULTIPLY_BITS=1)
(input signed [7:0] a_imag,
 input signed [7:0] b_real,
 output signed [15:0] bc
 );

    wire signed [15:0] mult;

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
    (a_imag[7] == 1'b1 && b_real[7] == 1'b1) ? (({8'b0,(~a_imag +1'b1)} * {8'b0,(~b_real +1'b1)}))  <<< MULTIPLY_BITS :
    (a_imag[7] == 1'b1 && b_real[7] == 1'b0) ? ~(({8'b0,(~a_imag +1'b1)} * {8'b0,b_real})) + 1'b1 <<< MULTIPLY_BITS :
    (a_imag[7] == 1'b0 && b_real[7] == 1'b1) ? ~(({8'b0,a_imag} * {8'b0,(~b_real +1'b1)})) + 1'b1 <<< MULTIPLY_BITS :
    ((({8'b0,a_imag} * {8'b0,b_real})) <<< MULTIPLY_BITS);
    
    assign bc = mult;

endmodule


module bd_mult #(
INT_BITS =8, FRAC_BITS=8, SHIFT_BITS=8, MULTIPLY_BITS=1)
(input signed [7:0] a_imag,
 input signed [7:0] b_imag,
 output signed [15:0] bd
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
    (a_imag[7] == 1'b1 && b_imag[7] == 1'b1) ? (({8'b0,(~a_imag +1'b1)} * {8'b0,(~b_imag +1'b1)}))  <<< MULTIPLY_BITS :
    (a_imag[7] == 1'b1 && b_imag[7] == 1'b0) ? ~(({8'b0,(~a_imag +1'b1)} * {8'b0,b_imag})) + 1'b1 <<< MULTIPLY_BITS :
    (a_imag[7] == 1'b0 && b_imag[7] == 1'b1) ? ~(({8'b0,a_imag} * {8'b0,(~b_imag +1'b1)})) + 1'b1 <<< MULTIPLY_BITS :
    (({8'b0,a_imag} * {8'b0,b_imag})) <<< MULTIPLY_BITS;
    
    assign bd = mult ;


endmodule