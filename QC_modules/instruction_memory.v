module instruction_memory #(
    parameter ADDR_WIDTH  = 8,        
    parameter INSTR_WIDTH = 1,       
    parameter OP_COMPUTE  = 1'b0,    
    parameter OP_MEASURE  = 1'b1      
)(
    input  wire clk,
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg  [INSTR_WIDTH-1:0] instruction
);
    
    reg [INSTR_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];

    
    initial begin
        mem[0] = OP_COMPUTE;
        mem[1] = OP_COMPUTE;
        mem[2] = OP_MEASURE; 
    end

    
    always @(posedge clk) begin
        instruction <= mem[addr];
    end
endmodule
