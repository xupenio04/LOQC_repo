module complex_prob #(
    parameter WIDTH = 8
)(
    input wire signed [WIDTH-1:0] real_part,
    input wire signed [WIDTH-1:0] imag_part,
    output wire signed [2*WIDTH-1:0] prob_sq // Saída de 16 bits com valor verdadeiro
);
    
    wire signed [2*WIDTH-1:0] real_sq = real_part * real_part;
    wire signed [2*WIDTH-1:0] imag_sq = imag_part * imag_part;
    
    assign prob_sq = real_sq + imag_sq;  // Valor verdadeiro em Q2.12
    
endmodule