module measure_qubit (
    input wire clk,
    input wire reset,
    input wire measure_en,
    input wire [31:0] state_in,  // [31:24] imag1, [23:16] real1, [15:8] imag0, [7:0] real0
    output reg measured_value,
    output reg measurement_done
);
    
    reg [15:0] lfsr;
    reg [7:0] real0_reg, real1_reg;
    reg [31:0] prob0, prob1;  // Aumentado para 32 bits
    reg [31:0] total_prob;
    reg [31:0] random_scaled;
    reg [2:0] state;
    
    localparam IDLE = 0;
    localparam CALC_PROB = 1;
    localparam GEN_RANDOM = 2;
    localparam DECIDE = 3;
    localparam DONE = 4;
    
    // LFSR polynomial: x^16 + x^14 + x^13 + x^11 + 1
    function [15:0] next_lfsr;
        input [15:0] current;
        begin
            next_lfsr = {current[14:0], current[15] ^ current[13] ^ current[12] ^ current[10]};
        end
    endfunction
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            lfsr <= 16'h00AB;
            measured_value <= 0;
            measurement_done <= 0;
            real0_reg <= 0;
            real1_reg <= 0;
            prob0 <= 0;
            prob1 <= 0;
            total_prob <= 0;
            random_scaled <= 0;
            state <= IDLE;
        end else begin
            measurement_done <= 0;
            
            case (state)
                IDLE: begin
                    if (measure_en) begin
                        // Extrair partes reais (valores signed)
                        real0_reg <= state_in[7:0];
                        real1_reg <= state_in[23:16];
                        state <= CALC_PROB;
                    end
                end
                
                CALC_PROB: begin
                    // Calcular probabilidades (quadrados) - CORREÇÃO CRÍTICA
                    // Usando 32 bits para evitar overflow
                    prob0 <= real0_reg * real0_reg;
                    prob1 <= real1_reg * real1_reg;
                    state <= GEN_RANDOM;
                end
                
                GEN_RANDOM: begin
                    total_prob <= prob0 + prob1;
                    lfsr <= next_lfsr(lfsr);
                    state <= DECIDE;
                end
                
                DECIDE: begin
                    // Escalar corretamente - CORREÇÃO CRÍTICA
                    // random_scaled está no range [0, total_prob-1]
                    random_scaled <= (lfsr * total_prob) >> 16;
                    
                    // Decisão baseada na probabilidade
                    if (random_scaled < prob0) begin
                        measured_value <= 0;  // Medir |0⟩
                    end else begin
                        measured_value <= 1;  // Medir |1⟩
                    end
                    state <= DONE;
                end
                
                DONE: begin
                    measurement_done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule