module program_counter #(
    parameter ADDR_WIDTH = 8
) (
    input wire clk,
    input wire reset,
    output reg [ADDR_WIDTH-1:0] pc
);
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            pc <= {ADDR_WIDTH{1'b0}};
        end else begin
            pc <= pc + 1;
        end
    end
endmodule