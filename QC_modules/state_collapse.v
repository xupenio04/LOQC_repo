module state_collapse (
    input signed [15:0] q0_real,
    input signed [15:0] q0_imag,
    input signed [15:0] q1_real,
    input signed [15:0] q1_imag,
    input wire measured_value,
    output reg [31:0] collapsed_q0,
    output reg [31:0] collapsed_q1
);

    always @(*) begin
        if (measured_value == 1'b0) begin
            collapsed_q0 = {q0_imag[15:0], q0_real[15:0]};
            collapsed_q1 = 32'd0;
        end else begin
            collapsed_q0 = 32'd0;
            collapsed_q1 = {q1_imag[15:0], q1_real[15:0]};
        end
    end

endmodule