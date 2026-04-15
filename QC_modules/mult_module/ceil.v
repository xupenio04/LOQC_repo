module ceil
(
    input signed [15:0] in,
    output signed [7:0] out
    );
    
    localparam SHIFT_BITS = 8;
    assign out = (in >>> SHIFT_BITS) + ((in & ((1 << SHIFT_BITS) - 1)) != 0 ? 1 : 0);

endmodule