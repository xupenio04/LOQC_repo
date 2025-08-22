module new_state_tb();
    reg clk, reset;
    reg [63:0] unitary_matrix;
    reg [63:0] state_in;
    wire [15:0] state_out;
    
    new_state dut (
        .clk(clk),
        .reset(reset),
        .unitary_matrix(unitary_matrix),
        .state_in(state_in),
        .state_out(state_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $display("=== TESTE PARTE IMAGINÁRIA CORRIGIDO ===");
        $display("Formato: [63:56]=u11_imag, [55:48]=u11_real, [47:40]=u10_imag, [39:32]=u10_real");
        $display("         [31:24]=u01_imag, [23:16]=u01_real, [15:8]=u00_imag, [7:0]=u00_real");
        
        // Teste 1: Reset
        reset = 1;
        unitary_matrix = 64'h0;
        state_in = 64'h0;
        #10;
        reset = 0;
        
        // Teste 2: Apenas parte imaginária (2i * 3i = -6 + 0i)
        // u00_imag=2, in00_imag=3
        unitary_matrix = 64'h0000_0000_0000_0200; // u00_imag=2 (byte 15:8)
        state_in = 64'h0000_0000_0000_0300;       // in00_imag=3 (byte 15:8)
        #20;
        $display("(2i)*(3i) = -6 + 0i");
        $display("Resultado: %04h (real: %02h, imag: %02h)", 
                state_out, state_out[7:0], state_out[15:8]);
        
        // Teste 3: (1+2i) * (3+4i) = (-5+10i)
        unitary_matrix = 64'h0000_0000_0000_0201; // u00_real=1, u00_imag=2
        state_in = 64'h0000_0000_0000_0403;       // in00_real=3, in00_imag=4
        #20;
        $display("(1+2i)*(3+4i) = (-5+10i)");
        $display("Resultado: %04h (real: %02h, imag: %02h)", 
                state_out, state_out[7:0], state_out[15:8]);
        
        // Teste 4: Parte real apenas (2 * 3 = 6)
        unitary_matrix = 64'h0000_0000_0000_0002; // u00_real=2
        state_in = 64'h0000_0000_0000_0003;       // in00_real=3
        #20;
        $display("(2)*(3) = 6");
        $display("Resultado: %04h (real: %02h, imag: %02h)", 
                state_out, state_out[7:0], state_out[15:8]);
        
        #10;
        $finish;
    end
endmodule