module instruction_memory #(
    parameter ADDR_WIDTH  = 8,        // Memory address width
    parameter INSTR_WIDTH = 1,        // Instruction width    
    parameter OP_COMPUTE  = 1'b0,     // Compute operation
    parameter OP_MEASURE  = 1'b1      // Measurement
)(
    input  wire clk,
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [INSTR_WIDTH-1:0] instruction
);
    // Memory for instructions
    reg [INSTR_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    // Initialize with sample quantum program
    initial begin
        mem[0] = OP_COMPUTE;
        mem[1] = OP_COMPUTE;
        mem[2] = OP_MEASURE; // Measure operation
    end

    // Read instruction synchronously
    always @(posedge clk) begin
        instruction <= mem[addr];
    end
endmodule
