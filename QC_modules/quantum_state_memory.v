module quantum_state_memory #(
    parameter N_QUBITS = 2,
    parameter STATE_SIZE = 2**N_QUBITS,
    parameter WIDTH = 8
) (
    input wire clk,
    input wire reset,        
    input wire write_en,
    input wire [STATE_SIZE*WIDTH*2-1:0] state_in,
    output reg [STATE_SIZE*WIDTH*2-1:0] state_out
);
    
    always @(posedge clk or negedge reset) begin  
        if (!reset) begin                        
            state_out <= 0; 
        end
        else if (write_en) begin
            state_out <= state_in; 
        end
    end
endmodule