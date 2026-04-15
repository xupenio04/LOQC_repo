module probability_calculator #( NUM_QUBITS = 1)(
    input wire [7:0] real_part,
    input wire [7:0] imag_part,
    output wire [15:0] prob_qubit

);
    

    wire signed [15:0] square_real;
    wire signed [15:0] square_imag;


    assign prob_qubit = square_real + square_imag; 
    
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