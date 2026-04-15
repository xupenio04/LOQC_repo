`timescale 1ns/1ps

module tb_complex_mult;

    // Entradas
    reg  signed [7:0] a_real, a_imag;
    reg  signed [7:0] b_real, b_imag;

    // Saídas
    wire signed [7:0] res_real, res_imag;

    // DUT – Device Under Test
    complex_mult dut (
        .a_real(a_real),
        .a_imag(a_imag),
        .b_real(b_real),
        .b_imag(b_imag),
        .res_real(res_real),
        .res_imag(res_imag)
    );

    // Procedimento para printar resultados
    task print_result;
        input signed [7:0] ar, ai, br, bi;
        begin
            $display("a = (%0d + %0dj), b = (%0d + %0dj)  ->  res = (%0d + %0dj)",
                     ar, ai, br, bi, res_real, res_imag);
        end
    endtask


    initial begin
        $display("\n===== TESTANDO complex_mult =====\n");

        $display("Teste básico 0:");
        a_real = 0;  a_imag = 0;
        b_real = 0;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 0j\n");


        $display("Teste básico 1:");
        a_real = -64;  a_imag = 0;
        b_real = -64;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 32 + 0j\n");

        $display("Teste básico 2:");
        a_real = 64;  a_imag = 64;
        b_real = 64;  b_imag = 64;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 64j\n");

        $display("Teste básico 3:");
        a_real = 64;  a_imag = 64;
        b_real = -128;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 - 128j\n");


        $display("Teste básico 4:");
        a_real =  0;  a_imag = 127;
        b_real = -128;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 - 127j\n");

        $display("Teste básico 5:");
        a_real = -128;  a_imag = 0;
        b_real = -128;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 127 + 0j\n");

        $display("Teste básico 6:");
        a_real = -128;  a_imag = 0;
        b_real = 0;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 127j\n");

        $display("Teste básico 7:");
        a_real = 0 ;  a_imag = -128;
        b_real = -128;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 127j\n");

         $display("Teste básico 8:");
        a_real = 0;  a_imag = -128;
        b_real = -128;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -127 + 127j\n");

         $display("Teste básico 9:");
        a_real = -128;  a_imag = 0;
        b_real = -128;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 127 + 127j\n");

          $display("Teste básico 10:");
        a_real = -128;  a_imag = -128;
        b_real = 0;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -127 + 127j\n");

          $display("Teste básico 11:");
        a_real = -128;  a_imag = -128;
        b_real = -128;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 127 + 127j\n");

        $display("Teste básico 12:");
        a_real = -128;  a_imag = -128;
        b_real = 127;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 - 2j\n");

        $display("Teste básico 13:");
        a_real = 127;  a_imag = -128;
        b_real = -128;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 2j\n");

        $display("Teste básico 14:");
        a_real = 127;  a_imag = -128;
        b_real = 127;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 - 2j\n");

        $display("Teste básico 15:");
        a_real = -128;  a_imag = 127;
        b_real = -128;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 - 2j\n");

        $display("Teste básico 16:");
        a_real = 127;  a_imag = 127;
        b_real = 0;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 0j\n");

        $display("Teste básico 17:");
        a_real = 127;  a_imag = 0;
        b_real = 127;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 126 + 0j\n");

        $display("Teste básico 18:");
        a_real = 127;  a_imag = 0;
        b_real = 0;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 126j\n");

        $display("Teste básico 19:");
        a_real = 0;  a_imag = 127;
        b_real = 127;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 126j\n");

        $display("Teste básico 20:");
        a_real = 0;  a_imag = 127;
        b_real = 0;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -126 + 0j\n");

        $display("Teste básico 21:");
        a_real = 0;  a_imag = 0;
        b_real = 127;  b_imag = 127;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 0j\n");

        $display("Teste básico 22:");
        a_real = 10;  a_imag = 30;
        b_real = 20;  b_imag = 40;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -8 + 8j\n");

        $display("Teste básico 23:");
        a_real = 10;  a_imag = 0;
        b_real = 20;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 2 + 0j\n");


        $display("Teste básico 24:");
        a_real = 100;  a_imag = 0;
        b_real = 50;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 39 + 0j\n");

        $display("Teste básico 25:");
        a_real = 0;  a_imag = 10;
        b_real = 0;  b_imag = 20;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -2 + 0j\n");

        $display("Teste básico 26:");
        a_real = 10;  a_imag = 10;
        b_real = 10;  b_imag = 20;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -1 + 2j\n");

        $display("Teste básico 27:");
        a_real = 10;  a_imag = 10;
        b_real = 40;  b_imag = 20;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 2 + 5j\n");

        $display("Teste básico 28:");
        a_real = 30;  a_imag = 20;
        b_real = 30;  b_imag = 20;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 4 + 9j\n");

         $display("Teste básico 29:");
        a_real = 50;  a_imag = 40;
        b_real = 30;  b_imag = 10;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 9 + 13j\n");

        $display("Teste básico 30:");
        a_real = 0;  a_imag = -30;
        b_real = 0;  b_imag = -40;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -9 + 0j\n");

        $display("Teste básico 31:");
        a_real = -10;  a_imag = -30;
        b_real = -20;  b_imag = -40;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -8 + 8j\n");

        $display("Teste básico 32:");
        a_real = -10;  a_imag = 0;
        b_real = 0;  b_imag = -40;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 3j\n");

        $display("Teste básico 33:");
        a_real = 0;  a_imag = -30;
        b_real = -20;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 5j\n");

        $display("Teste básico 34:");
        a_real = -10;  a_imag = 0;
        b_real = -20;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 2 + 0j\n");

        $display("Teste básico 35:");
        a_real = 0;  a_imag = -30;
        b_real = 0;  b_imag = -40;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -9 + 0j\n");

        $display("Teste básico 36:");
        a_real = 40;  a_imag = 0;
        b_real = 10;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 3 + 0j\n");

        $display("\n===== FIM DOS TESTES =====\n");
        $finish;
    end

endmodule
