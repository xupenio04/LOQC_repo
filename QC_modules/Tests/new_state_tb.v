`timescale 1ns/1ps

module tb_new_state();

    localparam NUM_QUBITS = 1;
    localparam VECTOR_SIZE = 2**NUM_QUBITS;
    
    reg [15:0] unitary_matrix [0:VECTOR_SIZE-1][0:VECTOR_SIZE-1];
    reg [15:0] state_in [0:VECTOR_SIZE-1];
    wire [15:0] state_out [0:VECTOR_SIZE-1];
    
    // Instantiate the module under test
    new_state #(
        .NUM_QUBITS(NUM_QUBITS)
    ) dut (
        .unitary_matrix(unitary_matrix),
        .state_in(state_in),
        .state_out(state_out)
    );
    
    // Helper function to create complex numbers
    function [15:0] make_complex;
        input signed [7:0] real_part;
        input signed [7:0] imag_part;
        begin
            make_complex = {real_part, imag_part};
        end
    endfunction
    
    // Helper task to display state vector
    task display_state;
        input [127:0] test_name;
        integer k;
        begin
            $display("--- %s ---", test_name);
            for (k = 0; k < VECTOR_SIZE; k = k + 1) begin
                $display("state_out[%0d] = %0d + %0di", 
                        k, 
                        $signed(state_out[k][15:8]), 
                        $signed(state_out[k][7:0]));
            end
            $display("");
        end
    endtask
    
    // Test procedure
    initial begin
        integer i, j;
        reg [15:0] temp_state [0:1];
        
        $display("========================================");
        $display("Starting 1-Qubit Matrix-Vector Testbench");
        $display("========================================\n");
        
        // Test 1: Apply X gate then Z gate to |0> state
        // Expected: X|0> = |1>, then Z|1> = -|1>
        $display("=== Test 1: Sequential X then Z on |0> ===");
        
        // Step 1: Apply X gate to |0>
        $display("Step 1: Applying X gate to |0>");
        unitary_matrix[0][0] = make_complex(8'd0, 8'd0);
        unitary_matrix[0][1] = make_complex(8'd127, 8'd0);  // 1 + 0i
        unitary_matrix[1][0] = make_complex(8'd127, 8'd0);  // 1 + 0i
        unitary_matrix[1][1] = make_complex(8'd0, 8'd0);
        
        state_in[0] = make_complex(8'd127, 8'd0);  // |0>
        state_in[1] = make_complex(8'd0, 8'd0);
        
        #10;
        $display("Result after X gate:");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        
        // Store the result
        temp_state[0] = state_out[0];
        temp_state[1] = state_out[1];
        
        // Step 2: Apply Z gate to the result
        $display("\nStep 2: Applying Z gate to the result");
        unitary_matrix[0][0] = make_complex(8'd127, 8'd0);   // 1 + 0i
        unitary_matrix[0][1] = make_complex(8'd0, 8'd0);     // 0 + 0i
        unitary_matrix[1][0] = make_complex(8'd0, 8'd0);     // 0 + 0i
        unitary_matrix[1][1] = make_complex(-8'd128, 8'd0);  // -1 + 0i
        
        state_in[0] = temp_state[0];
        state_in[1] = temp_state[1];
        
        #10;
        $display("Result after Z gate:");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        $display("Expected: state_out[0]=0, state_out[1]=-1\n");
        
        // Test 2: Apply Z gate then X gate to |0> state
        // Expected: Z|0> = |0>, then X|0> = |1>
        $display("=== Test 2: Sequential Z then X on |0> ===");
        
        // Step 1: Apply Z gate to |0>
        $display("Step 1: Applying Z gate to |0>");
        unitary_matrix[0][0] = make_complex(8'd127, 8'd0);   // 1 + 0i
        unitary_matrix[0][1] = make_complex(8'd0, 8'd0);     // 0 + 0i
        unitary_matrix[1][0] = make_complex(8'd0, 8'd0);     // 0 + 0i
        unitary_matrix[1][1] = make_complex(-8'd128, 8'd0);  // -1 + 0i
        
        state_in[0] = make_complex(8'd127, 8'd0);  // |0>
        state_in[1] = make_complex(8'd0, 8'd0);
        
        #10;
        $display("Result after Z gate:");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        
        // Store the result
        temp_state[0] = state_out[0];
        temp_state[1] = state_out[1];
        
        // Step 2: Apply X gate to the result
        $display("\nStep 2: Applying X gate to the result");
        unitary_matrix[0][0] = make_complex(8'd0, 8'd0);
        unitary_matrix[0][1] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][0] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][1] = make_complex(8'd0, 8'd0);
        
        state_in[0] = temp_state[0];
        state_in[1] = temp_state[1];
        
        #10;
        $display("Result after X gate:");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        $display("Expected: state_out[0]=1, state_out[1]=0\n");
        
        // Test 3: Apply X then Z to |+> state (superposition)
        $display("=== Test 3: X then Z on |+> state ===");
        $display("|+> = (|0> + |1>)/√2");
        $display("Expected: X|+> = |+>, then Z|+> = |-> = (|0> - |1>)/√2\n");
        
        // Step 1: Apply X gate to |+>
        $display("Step 1: Applying X gate to |+>");
        unitary_matrix[0][0] = make_complex(8'd0, 8'd0);
        unitary_matrix[0][1] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][0] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][1] = make_complex(8'd0, 8'd0);
        
        // Create |+> = (1/√2)|0> + (1/√2)|1> (scaled by 127 for 1.0)
        // 0.707 * 127 ≈ 90
        state_in[0] = make_complex(8'd90, 8'd0);  // ~0.707
        state_in[1] = make_complex(8'd90, 8'd0);  // ~0.707
        
        #10;
        $display("Result after X gate on |+> (should still be |+>):");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        
        // Store the result
        temp_state[0] = state_out[0];
        temp_state[1] = state_out[1];
        
        // Step 2: Apply Z gate to the result
        $display("\nStep 2: Applying Z gate to the result (should give |->)");
        unitary_matrix[0][0] = make_complex(8'd127, 8'd0);
        unitary_matrix[0][1] = make_complex(8'd0, 8'd0);
        unitary_matrix[1][0] = make_complex(8'd0, 8'd0);
        unitary_matrix[1][1] = make_complex(-8'd128, 8'd0);
        
        state_in[0] = temp_state[0];
        state_in[1] = temp_state[1];
        
        #10;
        $display("Result after Z gate:");
        $display("state_out[0] = %0d + %0di", $signed(state_out[0][15:8]), $signed(state_out[0][7:0]));
        $display("state_out[1] = %0d + %0di", $signed(state_out[1][15:8]), $signed(state_out[1][7:0]));
        $display("Expected: state_out[0]=90, state_out[1]=-90 (|-> state)\n");
        
        // Test 4: Identity matrix with |0> state
        $display("=== Test 4: Identity matrix ===");
        unitary_matrix[0][0] = make_complex(8'd127, 8'd0);  // 1 + 0i
        unitary_matrix[0][1] = make_complex(8'd0, 8'd0);    // 0 + 0i
        unitary_matrix[1][0] = make_complex(8'd0, 8'd0);    // 0 + 0i
        unitary_matrix[1][1] = make_complex(8'd127, 8'd0);  // 1 + 0i
        
        state_in[0] = make_complex(8'd127, 8'd0);  // |0>
        state_in[1] = make_complex(8'd0, 8'd0);
        
        #10;
        display_state("Identity * |0> (Expected: state_out[0]=1, state_out[1]=0)");
        
        // Test 5: Pauli-X gate with |0> state
        $display("=== Test 5: Pauli-X gate ===");
        unitary_matrix[0][0] = make_complex(8'd0, 8'd0);
        unitary_matrix[0][1] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][0] = make_complex(8'd127, 8'd0);
        unitary_matrix[1][1] = make_complex(8'd0, 8'd0);
        
        state_in[0] = make_complex(8'd127, 8'd0);  // |0>
        state_in[1] = make_complex(8'd0, 8'd0);
        
        #10;
        display_state("Pauli-X * |0> (Expected: state_out[0]=0, state_out[1]=1)");
        
        // Test 6: Hadamard gate with |0> state
        $display("=== Test 6: Hadamard gate ===");
        unitary_matrix[0][0] = make_complex(8'd91, 8'd0);   // ~0.707
        unitary_matrix[0][1] = make_complex(8'd91, 8'd0);
        unitary_matrix[1][0] = make_complex(8'd91, 8'd0);
        unitary_matrix[1][1] = make_complex(-8'd91, 8'd0);
        
        state_in[0] = make_complex(8'd127, 8'd0);
        state_in[1] = make_complex(8'd0, 8'd0);
        
        #10;
        display_state("Hadamard * |0> (Expected: both outputs ≈ 90-91)");
        
        $display("========================================");
        $display("Testbench completed");
        $display("========================================");
        #10 $finish;
    end
    
endmodule