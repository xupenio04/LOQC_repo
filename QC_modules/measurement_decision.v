`timescale 1ns/1ps

module measurement_decision (
    input wire clk,
    input wire reset,
    input wire [31:0] prob0,        
    input wire [15:0] random_number, 
    output reg measured_value
);

    wire [15:0] threshold = prob0[31:16];

    always @(posedge clk) begin
        if (reset) begin
            measured_value <= 1'b0;
        end else begin
            if (random_number < threshold) begin
                measured_value <= 1'b0;  
            end else begin
                measured_value <= 1'b1;  
            end
        end
    end

endmodule