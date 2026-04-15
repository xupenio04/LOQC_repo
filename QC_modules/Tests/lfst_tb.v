`timescale 1ns/1ps

module tb_lfsr;

    reg clk;
    reg reset;
    wire [15:0] next_lfsr;

    // Instancia o módulo LFSR
    lfsr uut (
        .clk(clk),
        .reset(reset),
        .next_lfsr(next_lfsr)
    );

    // Gera clock (período de 10 ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Estímulos
    initial begin
        $dumpfile("tb_lfsr.vcd");   // gera waveform para GTKWave
        $dumpvars(0, tb_lfsr);

        // Inicializa
        reset = 1;
        #20;
        reset = 0;

        // Deixa rodar por alguns ciclos
        repeat(20) begin
            #10;
            $display("Tempo=%0t ns | LFSR = %h", $time, next_lfsr);
        end

        $finish;
    end

endmodule
