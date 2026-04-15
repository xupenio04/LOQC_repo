module tb_measure_qubit;
    reg clk;
    reg reset;
    reg measure_en;
    reg [31:0] state_in;
    wire measured_value;
    wire measurement_done;
    
    measure_qubit uut (.*);
    
    always #5 clk = ~clk;
    
    integer count_0 = 0, count_1 = 0;
    integer total_tests = 1000;
    
    wire [7:0] real0 = state_in[7:0];
    wire [7:0] real1 = state_in[23:16];
    
    initial begin
        clk = 0; reset = 1; measure_en = 0; state_in = 0;
        #20 reset = 0;
        
        $display("=== Teste 50/50 ===");
        $display("real0 = 128, real1 = 128");
        $display("prob0 = 128^2 = %0d", 128*128);
        $display("prob1 = 128^2 = %0d", 128*128);
        $display("total_prob = %0d", (128*128)*2);
        
        state_in = 32'h00800080; // real0=128, real1=128 (50/50)
        repeat(total_tests) begin
            measure_en = 1; #10; measure_en = 0; #40;
        end
        
        $display("Resultado 50/50: |0⟩=%0d (%.1f%%), |1⟩=%0d (%.1f%%)",
                count_0, (count_0*100.0)/total_tests,
                count_1, (count_1*100.0)/total_tests);
        
        
        count_0 = 0; count_1 = 0;
        
        $display("\n=== Teste 25/75 ===");
        $display("real0 = 64, real1 = 192");
        $display("prob0 = 64^2 = %0d", 64*64);
        $display("prob1 = 192^2 = %0d", 192*192);
        $display("total_prob = %0d", (64*64) + (192*192));
        
     
        repeat(total_tests) begin
            measure_en = 1; #10; measure_en = 0; #40;
        end
        
        $display("Resultado 25/75: |0⟩=%0d (%.1f%%), |1⟩=%0d (%.1f%%)",
                count_0, (count_0*100.0)/total_tests,
                count_1, (count_1*100.0)/total_tests);
        
        $finish;
    end
    
    // Counter
    always @(posedge clk) begin
        if (measurement_done) begin
            if (measured_value == 0) count_0 <= count_0 + 1;
            else count_1 <= count_1 + 1;
        end
    end
endmodule