module quantum_gate #(
    parameter N_QUBITS = 2,
    parameter STATE_SIZE = 2**N_QUBITS,
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS
)(
    input wire [STATE_SIZE-1:0][STATE_SIZE-1:0][WIDTH-1:0] gate_matrix,
    input wire [STATE_SIZE-1:0][WIDTH-1:0] state_in,
    output wire [STATE_SIZE-1:0][WIDTH-1:0] state_out
);
    genvar i, j;
    generate
        for (i = 0; i < STATE_SIZE; i = i + 1) begin : row_mult
            wire [WIDTH-1:0] row_real_acc = 0;
            wire [WIDTH-1:0] row_imag_acc = 0;
            
            for (j = 0; j < STATE_SIZE; j = j + 1) begin : col_mult
                wire [WIDTH-1:0] mult_real, mult_imag;
                
                complex_mult #(INT_BITS, FRAC_BITS) multiplier (
                    .a_real(gate_matrix[i][j][WIDTH-1:0]),
                    .a_imag(gate_matrix[i][j][2*WIDTH-1:WIDTH]),
                    .b_real(state_in[j][WIDTH-1:0]),
                    .b_imag(state_in[j][2*WIDTH-1:WIDTH]),
                    .res_real(mult_real),
                    .res_imag(mult_imag)
                );
                
                wire [WIDTH-1:0] new_real_acc, new_imag_acc;
                
                complex_add #(INT_BITS, FRAC_BITS) adder (
                    .a_real(row_real_acc),
                    .a_imag(row_imag_acc),
                    .b_real(mult_real),
                    .b_imag(mult_imag),
                    .res_real(new_real_acc),
                    .res_imag(new_imag_acc)
                );
                
                assign row_real_acc = new_real_acc;
                assign row_imag_acc = new_imag_acc;
            end
            
            assign state_out[i] = {row_imag_acc, row_real_acc};
        end
    endgenerate
endmodule