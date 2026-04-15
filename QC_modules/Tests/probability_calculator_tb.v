`timescale 1ns/1ps

module tb_probability_calculator;

    // Paramètres
    localparam NUM_QUBITS = 1;
    
    // Entrées
    reg signed [7:0] real_part;
    reg signed [7:0] imag_part;
    
    // Sortie
    wire [15:0] prob_qubit;
    
    // DUT – Device Under Test
    probability_calculator #(
        .NUM_QUBITS(NUM_QUBITS)
    ) dut (
        .real_part(real_part),
        .imag_part(imag_part),
        .prob_qubit(prob_qubit)
    );
    
    // Procédure pour afficher les résultats
    task print_result;
        input signed [7:0] re, im;
        input [15:0] expected;
        begin
            $display("real = %0d (%0h), imag = %0d (%0h) -> prob = %0d (%0h) [expected = %0d (%0h)]",
                     re, re, im, im, prob_qubit, prob_qubit, expected, expected);
            if (prob_qubit !== expected)
                $display("  ERREUR: Résultat incorrect!");
        end
    endtask
    
    // Procédure pour calculer la probabilité attendue
    function [15:0] expected_prob;
        input signed [7:0] re, im;
        reg signed [15:0] re_sq, im_sq;
        begin
            re_sq = re * re;
            im_sq = im * im;
            expected_prob = re_sq + im_sq;
        end
    endfunction
    
    initial begin
        $display("\n===== TEST DU MODULE probability_calculator =====\n");
        
        // Test 1: Partie réelle nulle, partie imaginaire nulle
        $display("Test 1: Cas nul");
        real_part = 0;
        imag_part = 0;
        #10 print_result(real_part, imag_part, 16'd0);
        
        // Test 2: Partie réelle positive, partie imaginaire nulle
        $display("\nTest 2: Partie réelle seulement");
        real_part = 64;
        imag_part = 0;
        #10 print_result(real_part, imag_part, expected_prob(64, 0));
        
        // Test 3: Partie réelle nulle, partie imaginaire positive
        $display("\nTest 3: Partie imaginaire seulement");
        real_part = 0;
        imag_part = 64;
        #10 print_result(real_part, imag_part, expected_prob(0, 64));
        
        // Test 4: Parties réelle et imaginaire positives
        $display("\nTest 4: Parties positives");
        real_part = 50;
        imag_part = 30;
        #10 print_result(real_part, imag_part, expected_prob(50, 30));
        
        // Test 5: Parties réelle et imaginaire négatives
        $display("\nTest 5: Parties négatives");
        real_part = -50;
        imag_part = -30;
        #10 print_result(real_part, imag_part, expected_prob(-50, -30));
        
        // Test 6: Partie réelle négative, partie imaginaire positive
        $display("\nTest 6: Signes mixtes 1");
        real_part = -40;
        imag_part = 60;
        #10 print_result(real_part, imag_part, expected_prob(-40, 60));
        
        // Test 7: Partie réelle positive, partie imaginaire négative
        $display("\nTest 7: Signes mixtes 2");
        real_part = 70;
        imag_part = -20;
        #10 print_result(real_part, imag_part, expected_prob(70, -20));
        
        // Test 8: Valeurs maximales
        $display("\nTest 8: Valeurs maximales");
        real_part = 127;
        imag_part = 127;
        #10 print_result(real_part, imag_part, expected_prob(127, 127));
        
        // Test 9: Valeurs minimales
        $display("\nTest 9: Valeurs minimales");
        real_part = -128;
        imag_part = -128;
        #10 print_result(real_part, imag_part, expected_prob(-128, -128));
        
        // Test 10: Petites valeurs
        $display("\nTest 10: Petites valeurs");
        real_part = 3;
        imag_part = 4;
        #10 print_result(real_part, imag_part, expected_prob(3, 4));
        
        // Test 11: Valeur réelle max, imaginaire nulle
        $display("\nTest 11: Réel max");
        real_part = 127;
        imag_part = 0;
        #10 print_result(real_part, imag_part, expected_prob(127, 0));
        
        // Test 12: Valeur réelle nulle, imaginaire min
        $display("\nTest 12: Imaginaire min");
        real_part = 0;
        imag_part = -128;
        #10 print_result(real_part, imag_part, expected_prob(0, -128));
        
        $display("\n===== FIN DES TESTS =====\n");
        $finish;
    end
    
    // Surveillance des changements
    always @(prob_qubit) begin
        $display("T=%0t: prob_qubit = %0d", $time, prob_qubit);
    end
    
endmodule