module to_frac #(
    parameter INT_BITS   = 8,
    parameter FRAC_BITS  = 8,
    parameter SHIFT_BITS = 8
) (
    input  signed [INT_BITS-1:0] in,
    output signed [INT_BITS-1] out_interger,
    output signed [FRAC_BITS-1] out_fraction;
);

    wire signed [FRAC_BITS+INT_BITS-1:0] shifted = {in, {FRAC_BITS{1'b0}}};
    wire signed [FRAC_BITS+INT_BITS-1:0] out = shifted >> SHIFT_BITS;

    assign out_interger = out[FRAC_BITS+INT_BITS-1:FRAC_BITS];
    assign out_fraction = out[FRAC_BITS-1:0];

endmodule
