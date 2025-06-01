module quantum_state #(
    parameter N_QUBITS = 2,
    parameter STATE_SIZE = 2**N_QUBITS,
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS
)(
    input wire clk,
    input wire reset,
    input wire write_en,
    input wire [STATE_SIZE-1:0][WIDTH-1:0] state_in,
    output reg [STATE_SIZE-1:0][WIDTH-1:0] state_out
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize to |00...0⟩
            for (int i = 0; i < STATE_SIZE; i = i + 1)
                state_out[i] <= (i == 0) ? {WIDTH{1'b0}} + (1 << FRAC_BITS) : 0;
        end
        else if (write_en) begin
            state_out <= state_in;
        end
    end
endmodule