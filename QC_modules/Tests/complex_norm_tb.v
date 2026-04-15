`timescale 1ns / 1ps

module test_norm_complex;

    // Paramètres de test
    localparam NUM_TESTS = 100;
    
    // Signaux de test
    reg signed [7:0] real_in;
    reg signed [7:0] imag_in;
    wire [15:0] norm_squared;
    
    // Variables pour la vérification
    integer passed_tests;
    integer failed_tests;
    integer expected_norm;
    
    // Instanciation du module à tester
    norm_complex uut (
        .real_in(real_in),
        .imag_in(imag_in),
        .norm_squared(norm_squared)
    );
    
    // Fonction pour calculer la norme au carrée attendue
    function integer compute_norm;
        input signed [7:0] real_val;
        input signed [7:0] imag_val;
        integer r, i;
    begin
        // Conversion en entier pour le calcul
        r = real_val;
        i = imag_val;
        
        // Calcul de la norme au carrée
        compute_norm = (r * r) + (i * i);
        
        // S'assurer que le résultat est non-négatif
        if (compute_norm < 0)
            compute_norm = 0;
    end
    endfunction
    
    // Fonction pour afficher les valeurs en binaire et décimal
    task display_values;
        input signed [7:0] r;
        input signed [7:0] i;
        input [15:0] result;
        input integer expected;
    begin
        $display("Real: %4d (0x%02h), Imag: %4d (0x%02h) -> Norm^2: %5d (0x%04h), Expected: %5d",
                 r, r, i, i, result, result, expected);
    end
    endtask
    
    initial begin
        passed_tests = 0;
        failed_tests = 0;
        
        $display("=== Début des tests pour norm_complex ===");
        $display("Plage de valeurs: [-128, 127]");
        $display("==========================================\n");
        
        // Test 1: Valeurs zéro
        real_in = 8'd0;
        imag_in = 8'd0;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 1 PASSÉ: Zéro");
            passed_tests++;
        end else begin
            $display("✗ Test 1 ÉCHOUÉ: Zéro");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 2: Nombre réel seulement (positif)
        real_in = 8'd42;
        imag_in = 8'd0;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 2 PASSÉ: Réel seulement positif");
            passed_tests++;
        end else begin
            $display("✗ Test 2 ÉCHOUÉ: Réel seulement positif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 3: Nombre réel seulement (négatif)
        real_in = -8'd42;
        imag_in = 8'd0;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 3 PASSÉ: Réel seulement négatif");
            passed_tests++;
        end else begin
            $display("✗ Test 3 ÉCHOUÉ: Réel seulement négatif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 4: Nombre imaginaire seulement (positif)
        real_in = 8'd0;
        imag_in = 8'd42;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 4 PASSÉ: Imaginaire seulement positif");
            passed_tests++;
        end else begin
            $display("✗ Test 4 ÉCHOUÉ: Imaginaire seulement positif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 5: Nombre imaginaire seulement (négatif)
        real_in = 8'd0;
        imag_in = -8'd42;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 5 PASSÉ: Imaginaire seulement négatif");
            passed_tests++;
        end else begin
            $display("✗ Test 5 ÉCHOUÉ: Imaginaire seulement négatif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 6: Partie réelle et imaginaire positives
        real_in = 8'd42;
        imag_in = 8'd53;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 6 PASSÉ: Réel et imaginaire positifs");
            passed_tests++;
        end else begin
            $display("✗ Test 6 ÉCHOUÉ: Réel et imaginaire positifs");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 7: Partie réelle positive, imaginaire négative
        real_in = 8'd42;
        imag_in = -8'd53;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 7 PASSÉ: Réel positif, imaginaire négatif");
            passed_tests++;
        end else begin
            $display("✗ Test 7 ÉCHOUÉ: Réel positif, imaginaire négatif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 8: Partie réelle négative, imaginaire positive
        real_in = -8'd42;
        imag_in = 8'd53;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 8 PASSÉ: Réel négatif, imaginaire positif");
            passed_tests++;
        end else begin
            $display("✗ Test 8 ÉCHOUÉ: Réel négatif, imaginaire positif");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 9: Partie réelle et imaginaire négatives
        real_in = -8'd42;
        imag_in = -8'd53;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 9 PASSÉ: Réel et imaginaire négatifs");
            passed_tests++;
        end else begin
            $display("✗ Test 9 ÉCHOUÉ: Réel et imaginaire négatifs");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 10: Valeurs extrêmes positives
        real_in = 8'd127;
        imag_in = 8'd127;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 10 PASSÉ: Valeurs extrêmes positives");
            passed_tests++;
        end else begin
            $display("✗ Test 10 ÉCHOUÉ: Valeurs extrêmes positives");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 11: Valeurs extrêmes négatives
        real_in = -8'd128;
        imag_in = -8'd128;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 11 PASSÉ: Valeurs extrêmes négatives");
            passed_tests++;
        end else begin
            $display("✗ Test 11 ÉCHOUÉ: Valeurs extrêmes négatives");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Test 12: Valeurs mixtes extrêmes
        real_in = 8'd127;
        imag_in = -8'd128;
        #10;
        expected_norm = compute_norm(real_in, imag_in);
        if (norm_squared == expected_norm) begin
            $display("✓ Test 12 PASSÉ: Valeurs mixtes extrêmes");
            passed_tests++;
        end else begin
            $display("✗ Test 12 ÉCHOUÉ: Valeurs mixtes extrêmes");
            display_values(real_in, imag_in, norm_squared, expected_norm);
            failed_tests++;
        end
        
        // Tests aléatoires
        $display("\n=== Tests aléatoires ===");
        for (integer i = 0; i < NUM_TESTS; i++) begin
            // Génération de valeurs aléatoires dans la plage [-128, 127]
            real_in = $random % 256 - 128;
            imag_in = $random % 256 - 128;
            #10;
            
            expected_norm = compute_norm(real_in, imag_in);
            
            if (norm_squared == expected_norm) begin
                passed_tests++;
                if (i < 10) // Afficher seulement les 10 premiers tests aléatoires
                    $display("✓ Test aléatoire %0d PASSÉ: real=%0d, imag=%0d", i+13, real_in, imag_in);
            end else begin
                $display("✗ Test aléatoire %0d ÉCHOUÉ: real=%0d, imag=%0d", i+13, real_in, imag_in);
                display_values(real_in, imag_in, norm_squared, expected_norm);
                failed_tests++;
            end
        end
        
        // Résumé final
        $display("\n==========================================");
        $display("=== RÉSUMÉ DES TESTS ===");
        $display("Tests passés: %0d", passed_tests);
        $display("Tests échoués: %0d", failed_tests);
        $display("Total: %0d", passed_tests + failed_tests);
        $display("==========================================");
        
        if (failed_tests == 0) begin
            $display("✓ TOUS LES TESTS ONT RÉUSSI !");
        end else begin
            $display("✗ DES TESTS ONT ÉCHOUÉ !");
        end
        
        $finish;
    end
    
    // Monitoring pour débogage (optionnel)
    initial begin
        $monitor("Time=%0t, real=%0d, imag=%0d, norm_squared=%0d", 
                 $time, real_in, imag_in, norm_squared);
    end
    
endmodule