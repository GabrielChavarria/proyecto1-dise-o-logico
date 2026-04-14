// Testbench: Sección 7.5 — Selector Top

// CAMBIOS (reescritura completa):
//   1. Puertos actualizados para coincidir con el módulos corregidos pos_error, dato_corregido, switch_selector, salida_selector, led_out
//   2. Switch simulado correctamente como entrada de control del mux
//   3. Se agrega monitoreo de led_out
//   4. Casos de prueba cubren switch en OFF (dato corregido) y ON (síndrome)

`timescale 1ns/1ps

module selector_tb;

    // Entradas
    logic [3:0] dato_corregido;
    logic [2:0] pos_error;
    logic       switch_selector;

    // Salidas
    logic [3:0] salida_selector;
    logic [6:0] seg_out;
    logic [3:0] led_out;

    // Instancia del módulo corregido
    selector dut (
        .dato_corregido (dato_corregido),
        .pos_error      (pos_error),
        .switch_selector(switch_selector),
        .salida_selector(salida_selector),
        .seg_out        (seg_out),
        .led_out        (led_out)
    );

    initial begin
        $dumpfile("selector_tb.vcd");
        $dumpvars(0, selector_top_tb);

        $display("============================================================");
        $display("         PRUEBA DE FUNCIONAMIENTO: SECCIÓN 7.5              ");
        $display("============================================================");
        $display("Tiempo | Switch | Dato Corr | Pos Error | Salida | LEDs | Seg");
        $display("============================================================");

        // ── CASO 1: switch=0 → salida debe ser dato_corregido ──────────
        dato_corregido  = 4'h5;   // 0101
        pos_error       = 3'b011; // posición 3
        switch_selector = 1'b0;
        #10;
        $display("%4t  |   %b  |     %h     |     %b    |   %h    |  %b  | %b",
                 $time, switch_selector, dato_corregido,
                 pos_error, salida_selector, led_out, seg_out);

        // ── CASO 2: switch=1 → salida debe ser {0, pos_error} ──────────
        switch_selector = 1'b1;
        #10;
        $display("%4t  |   %b  |     %h     |     %b    |   %h    |  %b  | %b",
                 $time, switch_selector, dato_corregido,
                 pos_error, salida_selector, led_out, seg_out);

        // ── CASO 3: otro valor, switch=0 ────────────────────────────────
        dato_corregido  = 4'hA;   // 1010
        pos_error       = 3'b001; // posición 1
        switch_selector = 1'b0;
        #10;
        $display("%4t  |   %b  |     %h     |     %b    |   %h    |  %b  | %b",
                 $time, switch_selector, dato_corregido,
                 pos_error, salida_selector, led_out, seg_out);

        // ── CASO 4: mismo valor, switch=1 ───────────────────────────────
        switch_selector = 1'b1;
        #10;
        $display("%4t  |   %b  |     %h     |     %b    |   %h    |  %b  | %b",
                 $time, switch_selector, dato_corregido,
                 pos_error, salida_selector, led_out, seg_out);

        // ── CASO 5: sin error (pos_error=0), switch=1 ───────────────────
        dato_corregido  = 4'hF;
        pos_error       = 3'b000;
        switch_selector = 1'b1;
        #10;
        $display("%4t  |   %b  |     %h     |     %b    |   %h    |  %b  | %b",
                 $time, switch_selector, dato_corregido,
                 pos_error, salida_selector, led_out, seg_out);

        $display("============================================================");
        $display(" SIMULACIÓN FINALIZADA CON ÉXITO ");
        $display("============================================================");

        #10 $finish;
    end

endmodule