module new_state(
  //  input wire clk,
    //input wire reset,
    input wire [63:0] unitary_matrix,  
    input wire [31:0] state_in,        
    output wire [31:0] qubit0_out,     // Primeiro qubit de saída
    output wire [31:0] qubit1_out      // Segundo qubit de saída  
);
    
    localparam WIDTH = 8; 
    
   
    wire signed [WIDTH-1:0] u00_real = unitary_matrix[7:0];
    wire signed [WIDTH-1:0] u00_imag = unitary_matrix[15:8];
    wire signed [WIDTH-1:0] u01_real = unitary_matrix[23:16];
    wire signed [WIDTH-1:0] u01_imag = unitary_matrix[31:24];
    wire signed [WIDTH-1:0] u10_real = unitary_matrix[39:32];
    wire signed [WIDTH-1:0] u10_imag = unitary_matrix[47:40];
    wire signed [WIDTH-1:0] u11_real = unitary_matrix[55:48];
    wire signed [WIDTH-1:0] u11_imag = unitary_matrix[63:56];
   
    wire signed [WIDTH-1:0] in00_real = state_in[7:0];
    wire signed [WIDTH-1:0] in00_imag = state_in[15:8];
    wire signed [WIDTH-1:0] in01_real = state_in[23:16];
    wire signed [WIDTH-1:0] in01_imag = state_in[31:24];
    
   
    wire [31:0] debug_u = {u01_imag, u01_real, u00_imag, u00_real};
    wire [31:0] debug_in = {in01_imag, in01_real, in00_imag, in00_real};
    
   
    wire signed [15:0] m0_real, m0_imag;
    wire signed [15:0] m1_real, m1_imag;
    wire signed [15:0] m2_real, m2_imag;
    wire signed [15:0] m3_real, m3_imag;
    
  wire signed [15:0] out0_real, out0_imag;
  wire signed [15:0] out1_real, out1_imag;
    
    
    complex_mult cmult0 (.a_real(u00_real), .a_imag(u00_imag),
                        .b_real(in00_real), .b_imag(in00_imag),
                        .res_real(m0_real), .res_imag(m0_imag));
    
    complex_mult cmult1 (.a_real(u01_real), .a_imag(u01_imag),
                        .b_real(in01_real), .b_imag(in01_imag),
                        .res_real(m1_real), .res_imag(m1_imag));
    
   complex_mult cmult2 (.a_real(u10_real), .a_imag(u10_imag),
                        .b_real(in00_real), .b_imag(in00_imag),
                        .res_real(m2_real), .res_imag(m2_imag));

    complex_mult cmult3 (.a_real(u11_real), .a_imag(u11_imag),
                        .b_real(in01_real), .b_imag(in01_imag),
                        .res_real(m3_real), .res_imag(m3_imag));
    
    complex_add cadd0 (.a_real(m0_real), .a_imag(m0_imag),
                      .b_real(m1_real), .b_imag(m1_imag),
                      .res_real(out0_real), .res_imag(out0_imag));
    
    complex_add cadd1 (.a_real(m2_real), .a_imag(m2_imag),
                      .b_real(m3_real), .b_imag(m3_imag),
                      .res_real(out1_real), .res_imag(out1_imag));


    assign qubit0_out = {out0_imag[15:0], out0_real[15:0]};
    assign qubit1_out = {out1_imag[15:0], out1_real[15:0]};

endmodule

module complex_add (
    input signed [15:0] a_real, a_imag,
    input signed [15:0] b_real, b_imag,
    output signed [15:0] res_real, res_imag
);
    assign res_real = a_real + b_real;
    assign res_imag = a_imag + b_imag;
endmodule

module complex_mult (
    input signed [7:0] a_real, a_imag,
    input signed [7:0] b_real, b_imag,
    output signed [15:0] res_real, res_imag
);
    wire signed [15:0] ac = a_real * b_real;
    wire signed [15:0] bd = a_imag * b_imag;
    wire signed [15:0] ad = a_real * b_imag;
    wire signed [15:0] bc = a_imag * b_real;
    
    assign res_real = ac - bd;
    assign res_imag = ad + bc;
endmodule