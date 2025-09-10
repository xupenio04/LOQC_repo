module lfsr (
    input wire clk,
    input wire reset,
    output reg [15:0] next_lfsr
);

    
    reg [15:0] lfsr_reg;
    
    always @(posedge clk) begin
        if (reset) begin
            lfsr_reg <= 16'hACE1; 
        end else begin
            lfsr_reg <= {lfsr_reg[14:0], 
                        lfsr_reg[15] ^ lfsr_reg[14] ^ lfsr_reg[12] ^ lfsr_reg[3] };
        end
    end
    
    assign next_lfsr = lfsr_reg;

endmodule
