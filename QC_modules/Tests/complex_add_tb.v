`timescale 1ns/1ps

module complex_add_tb;

    reg signed [7:0] a_real, a_imag;
    reg signed [7:0] b_real, b_imag;
    wire signed [7:0] res_real, res_imag;
    
    complex_add uut (
        .a_real(a_real),
        .a_imag(a_imag),
        .b_real(b_real),
        .b_imag(b_imag),
        .res_real(res_real),
        .res_imag(res_imag)
    );


    task print_result;
        input signed [7:0] ar, ai, br, bi;
        begin
            $display("a = (%0d + %0dj), b = (%0d + %0dj)  ->  res = (%0d + %0dj)",
                     ar, ai, br, bi, res_real, res_imag);
        end
    endtask

    initial begin


        $display("\n===== TESTANDO complex_add =====\n");

        $display("Teste básico 0:");
        a_real = 0;  a_imag = 0;
        b_real = 0;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: 0 + 0j\n");

        $display("Teste básico 1:");
        a_real = -64;  a_imag = 0;
        b_real = -64;  b_imag = 0;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -128 + 0j\n");

        $display("Teste básico 3:");
        a_real = 64;  a_imag = -64;
        b_real = 128;  b_imag = -128;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -64 + -192j\n");

        $display("Teste básico 5:");
        a_real = -128;  a_imag = 126;
        b_real = 127;  b_imag = -126;
        #10 print_result(a_real, a_imag, b_real, b_imag);
        $display("Resultado esperado: -1 + 0j\n");
       
        
        
    end
    
endmodule
