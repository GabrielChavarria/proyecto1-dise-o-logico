// ============================================================
// Testbench: secded_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Verifica la clasificación de error_type:
//   00 = sin error
//   01 = 1 error corregible
//   10 = doble error no corregible
//   11 = error solo en bit de paridad global
// ============================================================

`timescale 1ns/1ps

module secded_tb;

    // ----------------------------------------------------------
    // Señales del DUT
    // ----------------------------------------------------------
    reg  [7:0] rx_ext;
    reg  [2:0] syndrome;
    wire [1:0] error_type;

    // ----------------------------------------------------------
    // Instancia del DUT
    // ----------------------------------------------------------
    secded_detector DUT (
        .rx_ext    (rx_ext),
        .syndrome  (syndrome),
        .error_type(error_type)
    );

    // ----------------------------------------------------------
    // Tarea de verificación
    // ----------------------------------------------------------
    task verificar;
        input [7:0]  rx_in;
        input [2:0]  syn_in;
        input [1:0]  tipo_esperado;
        input [31:0] num_caso;
        begin
            rx_ext   = rx_in;
            syndrome = syn_in;
            #10;
            $write("[CASO %0d] rx_ext=%b syn=%b | error_type=%b | esperado=%b | ",
                    num_caso, rx_in, syn_in, error_type, tipo_esperado);
            if (error_type === tipo_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ----------------------------------------------------------
    // Estímulos
    // ============================================================
    // Palabra base: datos=1011, rx=7'b0110011
    // parity_global = 0^1^1^0^0^1^1 = 0
    // rx_ext = {0, 7'b0110011} = 8'b00110011
    // ----------------------------------------------------------
    initial begin

        $dumpfile("secded_tb.vcd");
        $dumpvars(0, secded_tb);

        $display("============================================");
        $display("  TESTBENCH: secded_detector");
        $display("  rx base = 7'b0110011 (datos=1011)");
        $display("  parity_global = 0");
        $display("  rx_ext = 8'b00110011");
        $display("============================================");

        // CASO 1: sin error → parity=0, syndrome=000 → error_type=00
        verificar(8'b00110011, 3'b000, 2'b00, 1);

        // CASO 2: 1 error en rx[0] → parity_calc=1, syndrome=001 → error_type=01
        // rx con error = 7'b0110010, parity_global=0 (sin cambio) → rx_ext=8'b00110010
        verificar(8'b00110010, 3'b001, 2'b01, 2);

        // CASO 3: 1 error en rx[4] → parity_calc=1, syndrome=101 → error_type=01
        // rx con error = 7'b0100011, parity_global=0 (sin cambio) → rx_ext=8'b00100011
        verificar(8'b00100011, 3'b101, 2'b01, 3);

        // CASO 4: doble error en rx[0] y rx[1]
        // rx=7'b0110000, parity=0, syndrome≠0 → error_type=10
        verificar(8'b00110000, 3'b011, 2'b10, 4);

        // CASO 5: doble error en rx[2] y rx[4]
        // rx=7'b0100111, parity=0, syndrome≠0 → error_type=10
        verificar(8'b00100111, 3'b110, 2'b10, 5);

        // CASO 6: error solo en bit de paridad global
        // rx correcto pero parity_global invertido → parity=1, syndrome=000
        // rx_ext = {1, 7'b0110011} = 8'b10110011
        verificar(8'b10110011, 3'b000, 2'b11, 6);

        // ----------------------------------------------------------
        // Palabra: datos=0000, rx=7'b0000000
        // parity_global=0, rx_ext=8'b00000000
        // ----------------------------------------------------------
        $display("\n  rx base = 7'b0000000 (datos=0000)");
        $display("  parity_global = 0");
        $display("--------------------------------------------");

        // sin error
        verificar(8'b00000000, 3'b000, 2'b00, 7);

        // 1 error en rx[0] → rx=7'b0000001, parity_global=0 (sin cambio) → rx_ext=8'b00000001
        verificar(8'b00000001, 3'b001, 2'b01, 8);

        // doble error rx[0] y rx[1] → rx=7'b0000011, parity=0
        verificar(8'b00000011, 3'b011, 2'b10, 9);

        // error solo en parity global
        verificar(8'b10000000, 3'b000, 2'b11, 10);

        // ----------------------------------------------------------
        // Palabra: datos=1111, rx=7'b1111111
        // parity_global=1, rx_ext=8'b11111111
        // ----------------------------------------------------------
        $display("\n  rx base = 7'b1111111 (datos=1111)");
        $display("  parity_global = 1");
        $display("--------------------------------------------");

        // sin error
        verificar(8'b11111111, 3'b000, 2'b00, 11);

        // 1 error en rx[0] → rx=7'b1111110, parity_global=1 (sin cambio) → rx_ext=8'b11111110
        verificar(8'b11111110, 3'b001, 2'b01, 12);

        // doble error rx[0] y rx[1] → rx=7'b1111100, parity=1 → rx_ext=8'b11111100
        verificar(8'b11111100, 3'b011, 2'b10, 13);

        // error solo en parity global → rx_ext=8'b01111111
        verificar(8'b01111111, 3'b000, 2'b11, 14);

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule