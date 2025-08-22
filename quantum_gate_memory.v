module quantum_gate_memory #(
    parameter N_QUBITS = 2,
    parameter GATE_SIZE = 2**N_QUBITS,
    parameter INT_BITS = 0,
    parameter FRAC_BITS = 8,
    parameter WIDTH = INT_BITS + FRAC_BITS
) (
    input wire clk,
    input wire reset,
    input wire [7:0] gate_addr,
    input wire write_en,
    input wire [GATE_SIZE*GATE_SIZE*WIDTH*2-1:0] gate_matrix_in,
    output reg [GATE_SIZE*GATE_SIZE*WIDTH*2-1:0] gate_matrix_out
);
    // Memory for storing multiple gates
    reg [GATE_SIZE*GATE_SIZE*WIDTH*2-1:0] gate_mem [0:255];
    
    // Declare loop variables outside the always block
    integer i, j, k;
    
    always @(posedge clk) begin
        if (reset) begin
            // Initialize with identity matrix
            for (i = 0; i < 256; i = i + 1) begin
                for (j = 0; j < GATE_SIZE; j = j + 1) begin
                    for (k = 0; k < GATE_SIZE; k = k + 1) begin
                        if (j == k) begin
                            // Real part = 1.0, Imaginary part = 0.0
                            gate_mem[i][(j*GATE_SIZE+k)*2*WIDTH +: WIDTH] = {{(WIDTH-1){1'b0}}, 1'b1};
                            gate_mem[i][(j*GATE_SIZE+k)*2*WIDTH + WIDTH +: WIDTH] = {WIDTH{1'b0}};
                        end else begin
                            // Both real and imaginary parts = 0.0
                            gate_mem[i][(j*GATE_SIZE+k)*2*WIDTH +: 2*WIDTH] = {2*WIDTH{1'b0}};
                        end
                    end
                end
            end
        end else if (write_en) begin
            gate_mem[gate_addr] = gate_matrix_in;
        end
        gate_matrix_out <= gate_mem[gate_addr];
    end
endmodule