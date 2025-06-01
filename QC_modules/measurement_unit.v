module measurement_unit #(
    parameter N_QUBITS = 2,
    parameter STATE_SIZE = 2**N_QUBITS,
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS,
    parameter RAND_WIDTH = 32
)(
    input wire clk,
    input wire start_meas,
    input wire [N_QUBITS-1:0] qubit_to_measure,
    input wire [STATE_SIZE-1:0][WIDTH-1:0] state_in,
    output reg [N_QUBITS-1:0] measured_value,
    output reg [STATE_SIZE-1:0][WIDTH-1:0] collapsed_state,
    output reg meas_done
);
    // Probability calculation wires
    wire [WIDTH-1:0] prob_0[N_QUBITS-1:0];
    wire [WIDTH-1:0] prob_1[N_QUBITS-1:0];
    
    // Random number generator
    reg [RAND_WIDTH-1:0] lfsr = RAND_WIDTH'hACE1;
    
    // Generate probability calculation units
    genvar q, i;
    generate
        for (q = 0; q < N_QUBITS; q = q + 1) begin : qubit_prob
            wire [WIDTH-1:0] p0_acc = 0;
            wire [WIDTH-1:0] p1_acc = 0;
            
            for (i = 0; i < STATE_SIZE; i = i + 1) begin : state_prob
                wire [WIDTH-1:0] prob;
                
                complex_prob #(INT_BITS, FRAC_BITS) prob_calc (
                    .real_part(state_in[i][WIDTH-1:0]),
                    .imag_part(state_in[i][2*WIDTH-1:WIDTH]),
                    .prob_sq(prob)
                );
                
                assign p0_acc = p0_acc + (i[q] ? 0 : prob);
                assign p1_acc = p1_acc + (i[q] ? prob : 0);
            end
            
            assign prob_0[q] = p0_acc;
            assign prob_1[q] = p1_acc;
        end
    endgenerate
    
    // Collapsed state calculation
    always @(posedge clk) begin
        if (start_meas) begin
            // Update LFSR
            lfsr <= {lfsr[RAND_WIDTH-2:0], lfsr[RAND_WIDTH-1] ^ lfsr[RAND_WIDTH-2]};
            
            // Perform measurement
            for (int q = 0; q < N_QUBITS; q = q + 1) begin
                if (qubit_to_measure[q]) begin
                    measured_value[q] <= (lfsr[WIDTH-1:0] < prob_0[q]) ? 0 : 1;
                    
                    // Collapse state
                    for (int i = 0; i < STATE_SIZE; i = i + 1) begin
                        if ((i[q] && measured_value[q] == 0) || (!i[q] && measured_value[q] == 1)) begin
                            collapsed_state[i] <= 0;
                        end else begin
                            collapsed_state[i] <= state_in[i];
                        end
                    end
                end
            end
            
            meas_done <= 1;
        end else begin
            meas_done <= 0;
        end
    end
endmodule