module rand_num (
  input wire clk,
  input wire reset,
  output reg [7:0] rand_num
);


initial begin
  rand_num = 8'b10000000;
end

always@(posedge clk) begin
            
                rand_num <= {rand_num[6:0], rand_num[7] ^ rand_num[5] ^ rand_num[4] ^ rand_num[3]};      
end

endmodule