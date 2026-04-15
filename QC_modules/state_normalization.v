module hybrid_normalization (
    input wire clk,
    input wire reset,
    input wire [31:0] collapsed_q0,
    input wire [31:0] collapsed_q1,
    output wire [31:0] normalized_q0,
    output wire [31:0] normalized_q1
);

    wire signed [15:0] col_q0_real = collapsed_q0[15:0];
    wire signed [15:0] col_q0_imag = collapsed_q0[31:16];
    wire signed [15:0] col_q1_real = collapsed_q1[15:0];
    wire signed [15:0] col_q1_imag = collapsed_q1[31:16];

    wire [31:0] mag0_squared = (col_q0_real * col_q0_real) + (col_q0_imag * col_q0_imag);
    wire [31:0] mag1_squared = (col_q1_real * col_q1_real) + (col_q1_imag * col_q1_imag);
    wire [31:0] norm_squared = mag0_squared + mag1_squared;

    wire [31:0] inv_sqrt;
    sqrt_reciprocal_improved sqrt_recip (
        .norm_squared(norm_squared),
        .inv_sqrt(inv_sqrt)
    );

    wire signed [31:0] nq0_real_raw = col_q0_real * inv_sqrt;
    wire signed [31:0] nq0_imag_raw = col_q0_imag * inv_sqrt;
    wire signed [31:0] nq1_real_raw = col_q1_real * inv_sqrt;
    wire signed [31:0] nq1_imag_raw = col_q1_imag * inv_sqrt;

  
    wire signed [15:0] nq0_real = nq0_real_raw[30:15]; 
    wire signed [15:0] nq0_imag = nq0_imag_raw[30:15];
    wire signed [15:0] nq1_real = nq1_real_raw[30:15];
    wire signed [15:0] nq1_imag = nq1_imag_raw[30:15];

    assign normalized_q0 = {nq0_imag, nq0_real};
    assign normalized_q1 = {nq1_imag, nq1_real};

endmodule

module sqrt_reciprocal_improved (
    input wire [31:0] norm_squared,
    output wire [31:0] inv_sqrt
);

assign inv_sqrt = 1/$sqrt(norm_squared);

   

endmodule