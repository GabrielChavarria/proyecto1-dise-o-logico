// ============================================================
// Testbench unificado: receptor_top_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
//
// Este TB prueba únicamente el módulo top receptor_top,
// que ya incluye el detector, corrector, selector y decodificador.
// ============================================================

`timescale 1ns/1ps

module receptor_top_tb;

    // ============================================================
    // ── SEÑALES ─────────────────────────────────────────────────
    // ============================================================

    reg  [6:0] rx;
    reg        switch_selector;

    wire [3:0] leds_out;
    wire [6:0] seg_out;
    wire [3:0] salida_selector;

    // ============================================================
    // ── INSTANCIA DUT ──────────────────────────────────────────
    // ============================================================

    receptor_top U_top (
        .rx              (rx),
        .switch_selector (switch_selector),
        .leds_out        (leds_out),
        .seg_out         (seg_out),
        .salida_selector (salida_selector)
    );

    // ============================================================
    // ── TAREAS DE VERIFICACIÓN ──────────────────────────────────
    // ============================================================

    task verificar_top;
        input [6:0] entrada;
        input       sw;
        input [2:0] sindrome_esperado;
        input [3:0] salida_esperada;
        input [6:0] seg_esperado;
        input [3:0] leds_esperado;
        input [31:0] num_caso;
        begin
            rx = entrada;
            switch_selector = sw;
            #10;
            $write("[CASO %0d] rx=%b sw=%b | DET(sin)=%b COR(dat)=%b SEL(out)=%h 7SEG=%b LED=%b | ",
                    num_caso, entrada, sw,
                    U_top.error_pos, U_top.dato_corregido,
                    salida_selector, seg_out, leds_out);
            if (U_top.error_pos === sindrome_esperado &&
                U_top.dato_corregido === leds_esperado &&
                salida_selector === salida_esperada &&
                seg_out === seg_esperado &&
                leds_out === leds_esperado)
                $display("OK");
            else
                $display("ERROR <<< expected sin=%b dato=%b salida=%h seg=%b leds=%b",
                         sindrome_esperado, leds_esperado, salida_esperada, seg_esperado, leds_esperado);
        end
    endtask

    // ============================================================
    // ── ESTÍMULOS ───────────────────────────────────────────────
    // ============================================================
    initial begin
        $dumpfile("receptor_top_tb.vcd");
        $dumpvars(0, receptor_top_tb);

        $display("\n============================================================");
        $display("  TESTBENCH: receptor_top (top único)");
        $display("  Columnas: DET=detector | COR=corrector | SEL=selector");
        $display("============================================================");

        verificar_top(7'b0110011, 1'b0, 3'b000, 4'hB, 7'b1111100, 4'b1011, 1);
        verificar_top(7'b0110011, 1'b1, 3'b000, 4'h0, 7'b0111111, 4'b1011, 2);
        verificar_top(7'b0110010, 1'b0, 3'b111, 4'hB, 7'b1111100, 4'b1011, 3);
        verificar_top(7'b0110010, 1'b1, 3'b111, 4'h7, 7'b0000111, 4'b1011, 4);
        verificar_top(7'b0000000, 1'b0, 3'b000, 4'h0, 7'b0111111, 4'b0000, 5);
        verificar_top(7'b0000000, 1'b1, 3'b000, 4'h0, 7'b0111111, 4'b0000, 6);
        verificar_top(7'b1111111, 1'b0, 3'b000, 4'hF, 7'b1110001, 4'b1111, 7);
        verificar_top(7'b1111111, 1'b1, 3'b000, 4'h0, 7'b0111111, 4'b1111, 8);

        $display("\n============================================================");
        $display("  SIMULACIÓN COMPLETA — receptor_top_tb");
        $display("============================================================\n");

        $finish;
    end

endmodule
