module sqrt_int_tb;

    parameter CLK_PERIOD = 10;
    parameter WIDTH = 8;

    reg clk;
    reg start;             
    wire busy;              
    wire valid;             
    reg [WIDTH-1:0] rad;   
    wire [WIDTH-1:0] root;  
    wire [WIDTH-1:0] rem;   

    // Explicit port mapping (no .* in Verilog)
    sqrt_int #(WIDTH) sqrt_inst (
        .clk(clk),
        .start(start),
        .busy(busy),
        .valid(valid),
        .rad(rad),
        .root(root),
        .rem(rem)
    );

    // Clock generation
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Monitor
    initial begin
        $monitor("\t%d:\tsqrt(%d) = %d (rem = %d) (V=%b)", 
                  $time, rad, root, rem, valid);
    end

    // Stimulus
    initial begin
        clk = 1'b0;
        start = 1'b0;
        rad = 0;

        #100    rad = 8'b00000000;  // 0
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b00000001;  // 1
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b01111001;  // 121
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b01010001;  // 81
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b01011010;  // 90
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b11111111;  // 255
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b01000000;  // 64
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b00111111;  // 63
                start = 1'b1;
        #10     start = 1'b0;

        #50     rad = 8'b00000010;  // 2
                start = 1'b1;
        #10     start = 1'b0;

        #50     $finish;
    end

endmodule