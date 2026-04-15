module complex_mult (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [7:0] res_real, res_imag
);

    wire signed [15:0] ac;
    wire signed [15:0] ad;
    wire signed [15:0] bc;
    wire signed [15:0] bd;

    ac_mult ac_mult_inst (
        .a_real(a_real),
        .b_real(b_real),
        .ac(ac)
    );

    ad_mult  ad_mult_inst (
        .a_real(a_real),
        .b_imag(b_imag),
        .ad(ad)
    );

    bc_mult  bc_mult_inst (
        .a_imag(a_imag),
        .b_real(b_real),
        .bc(bc)
    );

    bd_mult bd_mult_inst (
        .a_imag(a_imag),
        .b_imag(b_imag),
        .bd(bd)
    );

    wire [15:0] real_part = ac - bd;
    wire [15:0] imag_part = ad + bc;

    round  round_real_inst (
        .in(real_part),
        .out(res_real)
    );

    round round_imag_inst (
        .in(imag_part),
        .out(res_imag)
    );


endmodule

module ac_mult
(input signed [7:0] a_real,
 input signed [7:0] b_real,
 output signed [15:0] ac
 );

    localparam SHIFT_BITS=8, MULTIPLY_BITS=1;
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


module ad_mult
(input signed [7:0] a_real,
 input signed [7:0] b_imag,
 output signed [15:0] ad
 );
    localparam SHIFT_BITS=8, MULTIPLY_BITS=1;
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

module bc_mult 
(input signed [7:0] a_imag,
 input signed [7:0] b_real,
 output signed [15:0] bc
 );

    localparam SHIFT_BITS=8, MULTIPLY_BITS=1;
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

    wire signed [7:0] bc_rounded;

    assign bc = mult;
endmodule


module bd_mult 
(input signed [7:0] a_imag,
 input signed [7:0] b_imag,
 output signed [15:0] bd
 );

    localparam SHIFT_BITS=8, MULTIPLY_BITS=1;
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

    wire signed [7:0] bd_rounded;

    assign bd = mult;

endmodule


module floor 
(
    input signed [15:0] in,
    output signed [7:0] out
);
    localparam SHIFT_BITS = 8;
    assign out = in >>> SHIFT_BITS;


endmodule

module ceil
(
    input signed [15:0] in,
    output signed [7:0] out
    );
    
    localparam SHIFT_BITS = 8;
    assign out = (in >>> SHIFT_BITS) + ((in & ((1 << SHIFT_BITS) - 1)) != 0 ? 1 : 0);

endmodule


module round (
    input signed [15:0] in,
    output signed [7:0] out
);

    localparam SHIFT_BITS = 8;
    wire signed [7:0] floor_out;
    wire signed [7:0] ceil_out;

    floor floor_inst (
        .in(in),
        .out(floor_out)
    );

    ceil ceil_inst (
        .in(in),
        .out(ceil_out)
    );

    assign out = (in & ((1 << SHIFT_BITS) - 1)) >= (1 << (SHIFT_BITS - 1)) ? ceil_out : floor_out;

endmodule
