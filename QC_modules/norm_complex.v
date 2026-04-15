module norm_complex(
    input signed [7:0] real_in,
    input signed [7:0] imag_in,
    output reg [15:0] norm_squared
);


    wire signed [15:0] mult;

   assign mult =
    (real_in == 8'b00000000 && imag_in == 8'b00000000) ? 16'b0 :
    (real_in == 8'b00000000 && imag_in != 8'b00000000 && imag_in[7]==1'b0) ? {{1'b0, imag_in}*{8'b0, imag_in}} :
    ((real_in == 8'b00000000 && imag_in != 8'b00000000 && imag_in[7]==1'b1)) ? {{1'b0, ~imag_in + 1'b1}*{8'b0, ~imag_in + 1'b1}} :
    (real_in != 8'b00000000 && imag_in == 8'b00000000 && real_in[7]==1'b0) ? {{1'b0, real_in}*{8'b0, real_in}}  :
    ((real_in != 8'b00000000 && imag_in == 8'b00000000 && real_in[7]==1'b1)) ? {{1'b0, ~real_in + 1'b1}*{8'b0, ~real_in + 1'b1}}  :
    (real_in[7] == 1'b0 && imag_in[7] == 1'b1) ? (({8'b0, real_in}*{8'b0, real_in}) + ({8'b0, ~imag_in + 1'b1}*{8'b0, ~imag_in + 1'b1})) :
    (real_in[7] == 1'b1 && imag_in[7] == 1'b0) ? (({8'b0, ~real_in + 1'b1}*{8'b0, ~real_in + 1'b1}) + ({8'b0, imag_in}*{8'b0, imag_in}))  :
    (real_in[7] == 1'b1 && imag_in[7] == 1'b1) ? (({8'b0, ~real_in + 1'b1}*{8'b0, ~real_in + 1'b1}) + ({8'b0, ~imag_in + 1'b1}*{8'b0, ~imag_in + 1'b1}))  :
    (({8'b0, real_in}*{8'b0, real_in}) + ({8'b0, imag_in}*{8'b0, imag_in})) ;


    assign norm_squared = mult ;

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