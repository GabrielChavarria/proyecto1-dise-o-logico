// ============================================================
// Testbench unificado: receptor_top_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
//
// Incluye pruebas de:
//   7.1 — detector_error
//   7.2 — corrector_error
//   7.4 — decodificador_7seg
//   7.5 — selector
//
// CORRECCIONES aplicadas respecto a los TBs originales:
//   - selector_tb: $dumpvars referenciaba "selector_top_tb" (nombre
//     incorrecto); corregido a "receptor_top_tb".
//   - selector_tb: agregada tarea verificar() con chequeo automático
//     OK/ERROR, igual que los demás módulos.
//   - decodificador_7seg_tb: especificador "%H" no estándar en iVerilog;
//     reemplazado por "%0h".
//   - Un solo $dumpfile/dumpvars para todo el testbench unificado.
// ============================================================

`timescale 1ns/1ps

module receptor_top_tb;

    // ============================================================
    // ── SEÑALES ─────────────────────────────────────────────────
    // ============================================================

    // 7.1 — detector_error
    reg  [6:0] rx_det;
    wire [2:0] ep_det;

    // 7.2 — corrector_error
    reg  [6:0] rx_cor;
    reg  [2:0] ep_cor;
    wire [3:0] corrected;

    // 7.4 — decodificador_7seg
    reg  [3:0] bin_in;
    wire [6:0] seg_dec;

    // 7.5 — selector
    reg  [3:0] dato_corregido;
    reg  [2:0] pos_error;
    reg        switch_selector;
    wire [3:0] salida_selector;
    wire [6:0] seg_sel;
    wire [3:0] led_out;

    // ============================================================
    // ── INSTANCIAS DUT ──────────────────────────────────────────
    // ============================================================

    detector_error U_det (
        .rx       (rx_det),
        .error_pos(ep_det)
    );

    corrector_error U_cor (
        .rx       (rx_cor),
        .error_pos(ep_cor),
        .corrected(corrected)
    );

    decodificador_7seg U_dec (
        .bin_in (bin_in),
        .seg_out(seg_dec)
    );

    selector U_sel (
        .dato_corregido (dato_corregido),
        .pos_error      (pos_error),
        .switch_selector(switch_selector),
        .salida_selector(salida_selector),
        .seg_out        (seg_sel),
        .led_out        (led_out)
    );

    // ============================================================
    // ── TAREAS DE VERIFICACIÓN ──────────────────────────────────
    // ============================================================

    // --- 7.1 ---
    task verificar_det;
        input [6:0] entrada;
        input [2:0] sindrome_esperado;
        input [31:0] num_caso;
        begin
            rx_det = entrada;
            #10;
            $write("[DET CASO %0d] rx=%b | sindrome=%b (%0d) | esperado=%b (%0d) | ",
                    num_caso, entrada, ep_det, ep_det,
                    sindrome_esperado, sindrome_esperado);
            if (ep_det === sindrome_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // --- 7.2 ---
    task verificar_cor;
        input [6:0]  entrada;
        input [2:0]  pos;
        input [3:0]  dato_esperado;
        input [31:0] num_caso;
        begin
            rx_cor    = entrada;
            ep_cor    = pos;
            #10;
            $write("[COR CASO %0d] rx=%b pos=%b | corrected=%b | esperado=%b | ",
                    num_caso, entrada, pos, corrected, dato_esperado);
            if (corrected === dato_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // --- 7.4 ---
    task verificar_dec;
        input [3:0] entrada;
        input [6:0] seg_esperado;
        begin
            bin_in = entrada;
            #10;
            // CORRECCIÓN: "%H" no es estándar en iVerilog → reemplazado por "%0h"
            $write("[DEC %0h] bin_in=%b | seg_out=%b | esperado=%b | ",
                    entrada, entrada, seg_dec, seg_esperado);
            if (seg_dec === seg_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // --- 7.5 ---
    task verificar_sel;
        input [3:0] dato;
        input [2:0] pos;
        input       sw;
        input [3:0] salida_esperada;
        input [3:0] led_esperado;
        input [31:0] num_caso;
        begin
            dato_corregido  = dato;
            pos_error       = pos;
            switch_selector = sw;
            #10;
            $write("[SEL CASO %0d] sw=%b dato=%h pos=%b | salida=%h leds=%b seg=%b | esp_salida=%h esp_led=%b | ",
                    num_caso, sw, dato, pos,
                    salida_selector, led_out, seg_sel,
                    salida_esperada, led_esperado);
            if (salida_selector === salida_esperada && led_out === led_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ============================================================
    // ── ESTÍMULOS ───────────────────────────────────────────────
    // ============================================================
    initial begin

        $dumpfile("receptor_top_tb.vcd");
        // CORRECCIÓN: nombre corregido de "selector_top_tb" a "receptor_top_tb"
        $dumpvars(0, receptor_top_tb);

        // --------------------------------------------------------
        // SECCIÓN 7.1 — detector_error
        // --------------------------------------------------------
        $display("\n============================================================");
        $display("  TESTBENCH 7.1: detector_error");
        $display("============================================================");

        // Palabra base: datos=1011 → rx=7'b0110011
        $display("  datos base = 1011  |  rx correcto = 7'b0110011");
        $display("------------------------------------------------------------");
        verificar_det(7'b0110011, 3'b000,  1); // sin error
        verificar_det(7'b0110010, 3'b111,  2); // error rx[0]=d1
        verificar_det(7'b0110001, 3'b110,  3); // error rx[1]=d2
        verificar_det(7'b0110111, 3'b101,  4); // error rx[2]=d3
        verificar_det(7'b0111011, 3'b100,  5); // error rx[3]=p4
        verificar_det(7'b0100011, 3'b011,  6); // error rx[4]=d4
        verificar_det(7'b0010011, 3'b010,  7); // error rx[5]=p2
        verificar_det(7'b1110011, 3'b001,  8); // error rx[6]=p1

        // Palabra base: datos=0000 → rx=7'b0000000
        $display("\n  datos base = 0000  |  rx correcto = 7'b0000000");
        $display("------------------------------------------------------------");
        verificar_det(7'b0000000, 3'b000,  9);
        verificar_det(7'b0000001, 3'b111, 10);
        verificar_det(7'b0000010, 3'b110, 11);
        verificar_det(7'b0000100, 3'b101, 12);
        verificar_det(7'b0001000, 3'b100, 13);
        verificar_det(7'b0010000, 3'b011, 14);
        verificar_det(7'b0100000, 3'b010, 15);
        verificar_det(7'b1000000, 3'b001, 16);

        // Palabra base: datos=1111 → rx=7'b1111111
        $display("\n  datos base = 1111  |  rx correcto = 7'b1111111");
        $display("------------------------------------------------------------");
        verificar_det(7'b1111111, 3'b000, 17);
        verificar_det(7'b1111110, 3'b111, 18);
        verificar_det(7'b1111101, 3'b110, 19);
        verificar_det(7'b1111011, 3'b101, 20);
        verificar_det(7'b1110111, 3'b100, 21);
        verificar_det(7'b1101111, 3'b011, 22);
        verificar_det(7'b1011111, 3'b010, 23);
        verificar_det(7'b0111111, 3'b001, 24);

        // --------------------------------------------------------
        // SECCIÓN 7.2 — corrector_error
        // --------------------------------------------------------
        $display("\n============================================================");
        $display("  TESTBENCH 7.2: corrector_error");
        $display("============================================================");

        // Palabra base: datos=1011 → rx=7'b0110011
        $display("  datos base = 1011  |  rx correcto = 7'b0110011");
        $display("------------------------------------------------------------");
        verificar_cor(7'b0110011, 3'b000, 4'b1011,  1); // sin error
        verificar_cor(7'b0110010, 3'b111, 4'b1011,  2); // error rx[0]=d1
        verificar_cor(7'b0110001, 3'b110, 4'b1011,  3); // error rx[1]=d2
        verificar_cor(7'b0110111, 3'b101, 4'b1011,  4); // error rx[2]=d3
        verificar_cor(7'b0111011, 3'b100, 4'b1011,  5); // error rx[3]=p4
        verificar_cor(7'b0100011, 3'b011, 4'b1011,  6); // error rx[4]=d4
        verificar_cor(7'b0010011, 3'b010, 4'b1011,  7); // error rx[5]=p2
        verificar_cor(7'b1110011, 3'b001, 4'b1011,  8); // error rx[6]=p1

        // Palabra base: datos=0000 → rx=7'b0000000
        $display("\n  datos base = 0000  |  rx correcto = 7'b0000000");
        $display("------------------------------------------------------------");
        verificar_cor(7'b0000000, 3'b000, 4'b0000,  9);
        verificar_cor(7'b0000001, 3'b111, 4'b0000, 10);
        verificar_cor(7'b0000010, 3'b110, 4'b0000, 11);
        verificar_cor(7'b0000100, 3'b101, 4'b0000, 12);
        verificar_cor(7'b0001000, 3'b100, 4'b0000, 13);
        verificar_cor(7'b0010000, 3'b011, 4'b0000, 14);
        verificar_cor(7'b0100000, 3'b010, 4'b0000, 15);
        verificar_cor(7'b1000000, 3'b001, 4'b0000, 16);

        // Palabra base: datos=1111 → rx=7'b1111111
        $display("\n  datos base = 1111  |  rx correcto = 7'b1111111");
        $display("------------------------------------------------------------");
        verificar_cor(7'b1111111, 3'b000, 4'b1111, 17);
        verificar_cor(7'b1111110, 3'b111, 4'b1111, 18);
        verificar_cor(7'b1111101, 3'b110, 4'b1111, 19);
        verificar_cor(7'b1111011, 3'b101, 4'b1111, 20);
        verificar_cor(7'b1110111, 3'b100, 4'b1111, 21);
        verificar_cor(7'b1101111, 3'b011, 4'b1111, 22);
        verificar_cor(7'b1011111, 3'b010, 4'b1111, 23);
        verificar_cor(7'b0111111, 3'b001, 4'b1111, 24);

        // --------------------------------------------------------
        // SECCIÓN 7.4 — decodificador_7seg
        // --------------------------------------------------------
        $display("\n============================================================");
        $display("  TESTBENCH 7.4: decodificador_7seg");
        $display("  seg_out = {g,f,e,d,c,b,a} activo ALTO");
        $display("============================================================");

        verificar_dec(4'h0, 7'b0111111);
        verificar_dec(4'h1, 7'b0000110);
        verificar_dec(4'h2, 7'b1011011);
        verificar_dec(4'h3, 7'b1001111);
        verificar_dec(4'h4, 7'b1100110);
        verificar_dec(4'h5, 7'b1101101);
        verificar_dec(4'h6, 7'b1111101);
        verificar_dec(4'h7, 7'b0000111);
        verificar_dec(4'h8, 7'b1111111);
        verificar_dec(4'h9, 7'b1101111);
        verificar_dec(4'hA, 7'b1110111);
        verificar_dec(4'hB, 7'b1111100);
        verificar_dec(4'hC, 7'b0111001);
        verificar_dec(4'hD, 7'b1011110);
        verificar_dec(4'hE, 7'b1111001);
        verificar_dec(4'hF, 7'b1110001);

        // --------------------------------------------------------
        // SECCIÓN 7.5 — selector
        // --------------------------------------------------------
        $display("\n============================================================");
        $display("  TESTBENCH 7.5: selector");
        $display("  sw=0 → salida=dato_corregido | sw=1 → salida={0,pos_error}");
        $display("  led_out siempre = dato_corregido");
        $display("============================================================");

        // CASO 1: sw=0 → salida = dato_corregido = 4'h5
        verificar_sel(4'h5, 3'b011, 1'b0, 4'h5,          4'h5, 1);

        // CASO 2: sw=1 → salida = {0, pos_error} = 4'b0011 = 4'h3
        verificar_sel(4'h5, 3'b011, 1'b1, 4'b0011,        4'h5, 2);

        // CASO 3: sw=0 → salida = dato_corregido = 4'hA
        verificar_sel(4'hA, 3'b001, 1'b0, 4'hA,           4'hA, 3);

        // CASO 4: sw=1 → salida = {0, pos_error} = 4'b0001 = 4'h1
        verificar_sel(4'hA, 3'b001, 1'b1, 4'b0001,        4'hA, 4);

        // CASO 5: sin error (pos_error=0), sw=1 → salida = 4'h0
        verificar_sel(4'hF, 3'b000, 1'b1, 4'h0,           4'hF, 5);

        // --------------------------------------------------------
        $display("\n============================================================");
        $display("  SIMULACIÓN COMPLETA — receptor_top_tb");
        $display("============================================================\n");

        $finish;
    end

endmodule
