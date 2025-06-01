module quantum_emulator #(
    parameter N_QUBITS = 2,
    parameter STATE_SIZE = 2**N_QUBITS,
    parameter INT_BITS = 1,
    parameter FRAC_BITS = 15,
    parameter WIDTH = INT_BITS + FRAC_BITS,
    parameter RAND_WIDTH = 32
)(
    input wire clk,
    input wire reset,
    input wire apply_gate,
    input wire start_meas,
    input wire [N_QUBITS-1:0] qubit_to_measure,
    input wire [STATE_SIZE-1:0][STATE_SIZE-1:0][WIDTH-1:0] gate_matrix,
    output wire [N_QUBITS-1:0] measured_value,
    output wire gate_done,
    output wire meas_done
);
    // State memory signals
    wire [STATE_SIZE-1:0][WIDTH-1:0] current_state;
    wire [STATE_SIZE-1:0][WIDTH-1:0] next_state;
    wire write_en;
    
    // Gate application signals
    wire [STATE_SIZE-1:0][WIDTH-1:0] gate_output;
    
    // Measurement signals
    wire [STATE_SIZE-1:0][WIDTH-1:0] collapsed_state;
    
    // State memory
    quantum_state #(N_QUBITS, STATE_SIZE, INT_BITS, FRAC_BITS) state_reg (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .state_in(next_state),
        .state_out(current_state)
    );
    
    // Gate engine (combinational)
    quantum_gate #(N_QUBITS, STATE_SIZE, INT_BITS, FRAC_BITS) gate_unit (
        .gate_matrix(gate_matrix),
        .state_in(current_state),
        .state_out(gate_output)
    );
    
    // Measurement engine
    measurement_unit #(N_QUBITS, STATE_SIZE, INT_BITS, FRAC_BITS, WIDTH, RAND_WIDTH) meas_unit (
        .clk(clk),
        .start_meas(start_meas),
        .qubit_to_measure(qubit_to_measure),
        .state_in(current_state),
        .measured_value(measured_value),
        .collapsed_state(collapsed_state),
        .meas_done(meas_done)
    );
    
    // Control logic
    assign write_en = apply_gate | meas_done;
    assign next_state = meas_done ? collapsed_state : gate_output;
    assign gate_done = apply_gate; // Combinational operation completes immediately
endmodule