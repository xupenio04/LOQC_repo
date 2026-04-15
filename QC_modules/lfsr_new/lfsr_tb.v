// Modified testbench to show initial state
`default_nettype none
`timescale 1ns / 1ps

module lfsr_tb;

    parameter LEN = 8;
    parameter TAPS = 8'b10111000;
    
    reg clk;
    reg rst;
    reg en;
    reg [LEN-1:0] seed;
    wire [LEN-1:0] sreg;
    
    lfsr #(
        .LEN(LEN),
        .TAPS(TAPS)
    ) uut (
        .clk(clk),
        .rst(rst),
        .en(en),
        .seed(seed),
        .sreg(sreg)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        $dumpfile("lfsr_tb.vcd");
        $dumpvars(0, lfsr_tb);
        
        // Initialize
        rst = 1;
        en = 0;
        seed = 0;
        
        // Show state during reset
        #10;
        $display("After reset (en=0): sreg = %h", sreg);
        
        // Release reset
        rst = 0;
        #10;
        $display("After reset released (en=0): sreg = %h", sreg);
        
        // Enable LFSR
        en = 1;
        $display("\nLFSR running (en=1):");
        
        // Run for 20 cycles and print values
        repeat(20) begin
            #10;
            $display("sreg = %h", sreg);
        end
        
        $finish;
    end
    
endmodule