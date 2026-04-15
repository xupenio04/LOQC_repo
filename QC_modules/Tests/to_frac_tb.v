`timescale 1ns/1ps

module tb_to_frac;

  // Parâmetros
  localparam INT_BITS   = 8;
  localparam FRAC_BITS  = 8;
  localparam SHIFT_BITS = 8;

  // Sinais
  reg  signed [INT_BITS-1:0] in;
  wire signed [FRAC_BITS+INT_BITS-1:0] out;

  // Instancia o módulo
  to_frac #(
    .INT_BITS(INT_BITS),
    .FRAC_BITS(FRAC_BITS),
    .SHIFT_BITS(SHIFT_BITS)
  ) uut (
    .in(in),
    .out(out)
  );

  integer i;
  real frac_value;

  initial begin
    $display("==============================================");
    $display("       Teste do módulo to_frac (1/128 steps)  ");
    $display("==============================================");
    $display("   in (decimal) | in/128 (real) | out (binário) | out (decimal signed)");
    $display("----------------------------------------------");

    for (i = -128; i < 128; i = i + 1) begin
      in = i;
      #1;
      frac_value = i / 128.0;
      $display("%4d | %8.6f | %b | %d", in, frac_value, out, out);
    end

    $display("==============================================");
    $finish;
  end

endmodule
