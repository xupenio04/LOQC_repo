module tb_state_collapse;

    // Sinais de entrada
    reg signed [15:0] q0_real, q0_imag, q1_real, q1_imag;
    reg measured_value;
    
    // Sinais de saída
    wire [31:0] collapsed_q0, collapsed_q1;
    
    // Instância do módulo
    state_collapse uut (
        .q0_real(q0_real),
        .q0_imag(q0_imag),
        .q1_real(q1_real),
        .q1_imag(q1_imag),
        .measured_value(measured_value),
        .collapsed_q0(collapsed_q0),
        .collapsed_q1(collapsed_q1)
    );
    
    // Tarefa para testar um caso específico
    task test_case;
        input signed [15:0] q0_r, q0_i, q1_r, q1_i;
        input meas_val;
        input [31:0] expected_q0, expected_q1;
        begin
            q0_real = q0_r;
            q0_imag = q0_i;
            q1_real = q1_r;
            q1_imag = q1_i;
            measured_value = meas_val;
            
            #10;
            
            $display("Input: q0=(%d+%di), q1=(%d+%di), measured=%b", 
                     q0_r, q0_i, q1_r, q1_i, meas_val);
            $display("Output: collapsed_q0=%h, collapsed_q1=%h", 
                     collapsed_q0, collapsed_q1);
            $display("Expected: q0=%h, q1=%h", expected_q0, expected_q1);
            
            if (collapsed_q0 === expected_q0 && collapsed_q1 === expected_q1) begin
                $display("✓ PASS");
            end else begin
                $display("✗ FAIL");
            end
            $display("-----------------------------------");
        end
    endtask
    
    initial begin

        $dumpvars(1, tb_state_collapse);
        $display("=== Testbench for state_collapse ===");
        $display("Testing quantum state collapse functionality");
        $display("====================================");
        
        // Teste 1: measured_value = 0
        $display("\n1. measured_value = 0:");
        test_case(16'sd100, 16'sd200, 16'sd300, 16'sd400, 1'b0, 
                 {16'd200, 16'd100}, 32'd0);
        
        // Teste 2: measured_value = 1
        $display("\n2. measured_value = 1:");
        test_case(16'sd100, 16'sd200, 16'sd300, 16'sd400, 1'b1, 
                 32'd0, {16'd400, 16'd300});
        
        // Teste 3: Valores negativos
        $display("\n3. Negative values:");
        test_case(-16'sd100, -16'sd50, 16'sd75, -16'sd25, 1'b0, 
                 {16'hFFCE, 16'hFF9C}, 32'd0); // -50, -100 em complemento de 2
        
        // Teste 4: Valores zero
        $display("\n4. Zero values:");
        test_case(16'sd0, 16'sd0, 16'sd0, 16'sd0, 1'b1, 
                 32'd0, 32'd0);
        
        // Teste 5: Valores máximos positivos
        $display("\n5. Maximum positive values:");
        test_case(16'sd32767, 16'sd32767, 16'sd32767, 16'sd32767, 1'b0, 
                 {16'h7FFF, 16'h7FFF}, 32'd0);
        
        // Teste 6: Valores máximos negativos
        $display("\n6. Maximum negative values:");
        test_case(-16'sd32768, -16'sd32768, -16'sd32768, -16'sd32768, 1'b1, 
                 32'd0, {16'h8000, 16'h8000});
        
        // Teste 7: Alternando measured_value
        $display("\n7. Switching measured_value:");
        
        // Primeiro com measured_value = 0
        q0_real = 16'sd10; q0_imag = 16'sd20;
        q1_real = 16'sd30; q1_imag = 16'sd40;
        measured_value = 1'b0;
        #10;
        $display("measured=0: q0=%h, q1=%h", collapsed_q0, collapsed_q1);
        
        // Depois com measured_value = 1
        measured_value = 1'b1;
        #10;
        $display("measured=1: q0=%h, q1=%h", collapsed_q0, collapsed_q1);
        
        $display("\n=== All tests completed ===");
        $finish;
    end
    
    // Monitor para acompanhar mudanças
    initial begin
        $monitor("Time: %0t | measured=%b | q0=%h | q1=%h", 
                 $time, measured_value, collapsed_q0, collapsed_q1);
    end

endmodule