module quantum_state_memory_tb();
    parameter N_QUBITS = 2;
    parameter STATE_SIZE = 2**N_QUBITS;
    parameter WIDTH = 8;
    
    reg clk, reset, write_en;
    reg [STATE_SIZE*WIDTH*2-1:0] state_in;
    wire [STATE_SIZE*WIDTH*2-1:0] state_out;
    
    // Instância do módulo
    quantum_state_memory #(
        .N_QUBITS(N_QUBITS),
        .WIDTH(WIDTH)
    ) dut (
        .clk(clk),
        .reset(reset),
        .write_en(write_en),
        .state_in(state_in),
        .state_out(state_out)
    );
    
    // Geração de clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Task para formatar estado complexo
    task display_state;
        input [STATE_SIZE*WIDTH*2-1:0] state;
        integer i;
        reg [WIDTH-1:0] real_part, imag_part;
        begin
            for (i = 0; i < STATE_SIZE; i = i + 1) begin
                real_part = state[i * WIDTH * 2 +: WIDTH];
                imag_part = state[i * WIDTH * 2 + WIDTH +: WIDTH];
                $write("|%0d> = %0d + %0di, ", i, $signed(real_part), $signed(imag_part));
            end
            $display("");
        end
    endtask
    
    // Testes
    initial begin
        $display("=== TESTBENCH PARA QUANTUM STATE MEMORY ===");
        $display("N_QUBITS: %0d, STATE_SIZE: %0d, WIDTH: %0d", N_QUBITS, STATE_SIZE, WIDTH);
        $display("Tamanho do barramento: %0d bits", STATE_SIZE*WIDTH*2);
        
        // Inicialização
        reset = 1;  // Reset inativo (nível alto)
        write_en = 0;
        state_in = 0;
        #10;
        
        // Teste 1: Reset
        $display("\n1. Teste de Reset");
        reset = 0;  // Ativar reset (nível baixo)
        #10;
        reset = 1;  // Desativar reset
        #10;
        $write("Estado após reset: ");
        display_state(state_out);
        
        // Teste 2: Escrita simples
        $display("\n2. Teste de Escrita Simples");
        state_in = 64'h0102_0304_0506_0708; // Estado de teste
        write_en = 1;
        #10;
        write_en = 0;
        $write("Estado escrito: ");
        display_state(state_in);
        $write("Estado lido:    ");
        display_state(state_out);
        
        // Teste 3: Escrita com números negativos
        $display("\n3. Teste com Números Negativos");
        state_in = 64'hFFFE_FDFC_FBFA_F9F8; // Todos negativos
        write_en = 1;
        #10;
        write_en = 0;
        $write("Estado escrito: ");
        display_state(state_in);
        $write("Estado lido:    ");
        display_state(state_out);
        
        // Teste 4: Escrita com write_en desabilitado
        $display("\n4. Teste com Write Enable Desabilitado");
        state_in = 64'h1111_2222_3333_4444; // Novo estado
        write_en = 0; // Não deve escrever
        #10;
        $write("Tentativa de escrever: ");
        display_state(state_in);
        $write("Estado mantido:        ");
        display_state(state_out);
        
        // Teste 5: Reset durante operação
        $display("\n5. Teste de Reset Durante Operação");
        state_in = 64'hAAAA_BBBB_CCCC_DDDD;
        write_en = 1;
        #5;
        reset = 0; // Reset durante escrita (nível baixo)
        #5;
        reset = 1;
        #10;
        $write("Estado após reset: ");
        display_state(state_out);
        
        // Teste 6: Estado quântico realista
        $display("\n6. Teste com Estado Quântico Realista");
        // |00> = 0.707 + 0i, |01> = 0 + 0.707i, |10> = 0.707 + 0i, |11> = 0 + 0.707i
        // 0.707 ≈ 181/256 ≈ 0xB5
        state_in = {8'h00, 8'hB5, 8'hB5, 8'h00, 8'h00, 8'hB5, 8'hB5, 8'h00};
        write_en = 1;
        #10;
        write_en = 0;
        $display("Estado de Bell realista escrito");
        $write("Estado: ");
        display_state(state_out);
        
        $display("\n=== TODOS OS TESTES CONCLUÍDOS ===");
        #10;
        $finish;
    end
endmodule