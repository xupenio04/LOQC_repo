module sqrt_int #(parameter WIDTH=8) (      // width of radicand
    input wire clk,
    input wire start,             // start signal
    output reg busy,              // calculation in progress
    output reg valid,             // root and rem are valid
    input wire [WIDTH-1:0] rad,   // radicand
    output reg [WIDTH-1:0] root,  // root
    output reg [WIDTH-1:0] rem    // remainder
);

    reg [WIDTH-1:0] x, x_next;    
    reg [WIDTH-1:0] q, q_next;    
    reg [WIDTH+1:0] ac, ac_next;  
    reg [WIDTH+1:0] test_res;     

    localparam ITER = WIDTH >> 1;
    reg [$clog2(ITER)-1:0] i;     // NOTE: requires Verilog-2005+

    // Combinational logic
    always @(*) begin
        test_res = ac - {q, 2'b01};

        if (test_res[WIDTH+1] == 0) begin
            {ac_next, x_next} = {test_res[WIDTH-1:0], x, 2'b0};
            q_next = {q[WIDTH-2:0], 1'b1};
        end else begin
            {ac_next, x_next} = {ac[WIDTH-1:0], x, 2'b0};
            q_next = q << 1;
        end
    end

    // Sequential logic
    always @(posedge clk) begin
        if (start) begin
            busy <= 1'b1;
            valid <= 1'b0;
            i <= 0;
            q <= 0;
            {ac, x} <= {{WIDTH{1'b0}}, rad, 2'b0};
        end 
        else if (busy) begin
            if (i == ITER-1) begin
                busy <= 1'b0;
                valid <= 1'b1;
                root <= q_next;
                rem <= ac_next[WIDTH+1:2];
            end 
            else begin
                i <= i + 1;
                x <= x_next;
                ac <= ac_next;
                q <= q_next;
            end
        end
    end

endmodule