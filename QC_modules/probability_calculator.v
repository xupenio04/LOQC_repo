module probability_calculator #( NUM_QUBITS = 1)(
    input wire [7:0] real_part,
    input wire [7:0] imag_part,
    output wire [15:0] prob_qubit

);
    wire signed [15:0] square_real;
    wire signed [15:0] square_imag;

    ac_mult ac_mult_real (
        .a_real(real_part),
        .b_real(real_part),
        .ac(square_real)
    );

    ac_mult ac_mult_imag (
        .a_real(imag_part),
        .b_real(imag_part),
        .ac(square_imag)
    );


    wire signed [15:0] sum_squares = square_real + square_imag;

    round round_inst (
        .in(sum_squares),
        .out(prob_qubit)
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
