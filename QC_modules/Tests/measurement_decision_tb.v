`timescale 1ns/1ps

module tb_measurement_decision_corrected;
    reg clk;
    reg reset;
    reg [31:0] prob0;
    reg [15:0] random_number;
    wire measured_value;
    
    measurement_decision dut (
        .clk(clk),
        .reset(reset),
        .prob0(prob0),
        .random_number(random_number),
        .measured_value(measured_value)
    );
    
    // Geração de clock
    always #5 clk = ~clk;
    
    initial begin

        $dumpvars(1, tb_measurement_decision_corrected);
        clk = 0;
        reset = 1;
        prob0 = 32'd0;
        random_number = 16'd0;
        
        $display("=== Testbench Corrigido ===");
        $display("Time | Prob0 | Threshold | Random | Measured");
        $display("---------------------------------------------");
        
        // Reset inicial
        #10 reset = 0;
        
        // Teste 1: Probabilidade 100% (threshold = 65535)
        prob0 = 32'hFFFF0000; // 65535.0 em Q16.16
        random_number = 16'd0;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        random_number = 16'd65534;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        // Teste 2: Probabilidade 0% (threshold = 0)
        prob0 = 32'd0;
        random_number = 16'd0;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        random_number = 16'd1;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        // Teste 3: Probabilidade 50% (threshold = 32768)
        prob0 = 32'h80000000; // 32768.0 em Q16.16
        random_number = 16'd32767;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        random_number = 16'd32768;
        #10;
        $display("%4t | %8X | %6d | %6d | %1d", 
                $time, prob0, prob0[31:16], random_number, measured_value);
        
        $finish;
    end
    
    initial begin
        $dumpfile("tb_measurement_decision_corrected.vcd");
        $dumpvars(0, tb_measurement_decision_corrected);
    end

endmodule