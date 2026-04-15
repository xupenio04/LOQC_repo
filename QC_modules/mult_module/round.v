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

module ceil
(
    input signed [15:0] in,
    output signed [7:0] out
    );
    
    localparam SHIFT_BITS = 8;
    assign out = (in >>> SHIFT_BITS) + ((in & ((1 << SHIFT_BITS) - 1)) != 0 ? 1 : 0);

endmodule

module floor 
(
    input signed [15:0] in,
    output signed [7:0] out
);
    localparam SHIFT_BITS = 8;
    assign out = in >>> SHIFT_BITS;


endmodule
