// ============================================================
// Testbench: receptor_top_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Verifica el sistema completo de extremo a extremo:
//   - Sin error
//   - Error en cada posición 1-7
//   - Doble error (SECDED)
//   - Switch selector
// ============================================================
// Distribución del transmisor:
//   rx[0]=d1, rx[1]=d2, rx[2]=d3, rx[3]=p4
//   rx[4]=d4, rx[5]=p2, rx[6]=p1
// ============================================================

`timescale 1ns/1ps

module receptor_top_tb;

    // ----------------------------------------------------------
    // Señales del DUT — sin logic, compatible con iVerilog
    // ----------------------------------------------------------
    reg  [6:0] rx;
    reg        switch_selector;
    wire [3:0] salida_selector;
    wire [6:0] seg_out;
    wire [3:0] led_out;
    wire [2:0] error_pos;

    // ----------------------------------------------------------
    // Instancia del DUT
    // ----------------------------------------------------------
    receptor_top DUT (
        .rx              (rx),
        .switch_selector (switch_selector),
        .salida_selector (salida_selector),
        .seg_out         (seg_out),
        .led_out         (led_out),
        .error_pos       (error_pos)
    );

    // ----------------------------------------------------------
    // Tarea de verificación
    // ----------------------------------------------------------
    task verificar;
        input [6:0] entrada;
        input [2:0] pos_esperada;
        input [3:0] dato_esperado;
        input [31:0] num_caso;
        begin
            rx = entrada;
            #10;
            $write("[CASO %0d] rx=%b | error_pos=%b esp=%b | led_out=%b esp=%b | ",
                    num_caso, entrada,
                    error_pos, pos_esperada,
                    led_out, dato_esperado);
            if (error_pos !== pos_esperada)
                $display("ERROR en error_pos <<<");
            else if (led_out !== dato_esperado)
                $display("ERROR en led_out <<<");
            else
                $display("OK");
        end
    endtask

    // ----------------------------------------------------------
    // Estímulos
    // ============================================================
    // Palabra base: datos=1011, rx_correcto=7'b0110011
    //   p1=0→rx[6], p2=1→rx[5], d4=1→rx[4]
    //   p4=0→rx[3], d3=0→rx[2], d2=1→rx[1], d1=1→rx[0]
    // ----------------------------------------------------------
    initial begin

        $dumpfile("receptor_top_tb.vcd");
        $dumpvars(0, receptor_top_tb);

        switch_selector = 0;

        $display("============================================");
        $display("  TESTBENCH: receptor_top");
        $display("  datos base = 1011");
        $display("  rx correcto = 7'b0110011");
        $display("============================================");

        // CASO 1: sin error
        verificar(7'b0110011, 3'b000, 4'b1011, 1);

        // CASO 2: error en posición 1 (rx[0])
        verificar(7'b0110010, 3'b001, 4'b1011, 2);

        // CASO 3: error en posición 2 (rx[1])
        verificar(7'b0110001, 3'b010, 4'b1011, 3);

        // CASO 4: error en posición 3 (rx[2])
        verificar(7'b0110111, 3'b011, 4'b1011, 4);

        // CASO 5: error en posición 4 (rx[3]=p4)
        verificar(7'b0111011, 3'b100, 4'b1011, 5);

        // CASO 6: error en posición 5 (rx[4]=d4)
        verificar(7'b0100011, 3'b101, 4'b1011, 6);

        // CASO 7: error en posición 6 (rx[5]=p2)
        verificar(7'b0010011, 3'b110, 4'b1011, 7);

        // CASO 8: error en posición 7 (rx[6]=p1)
        verificar(7'b1110011, 3'b111, 4'b1011, 8);

        // ----------------------------------------------------------
        // CASO 9: doble error — dato no confiable
        // rx[0] y rx[1] invertidos → led_out debe ser 4'b1111
        // ----------------------------------------------------------
        $display("\n[CASO 9] doble error — led_out debe ser 1111");
        rx = 7'b0110000;
        #10;
        $write("[CASO 9] rx=%b | led_out=%b | esperado=1111 | ", rx, led_out);
        if (led_out === 4'b1111)
            $display("OK");
        else
            $display("ERROR <<<");

        // ----------------------------------------------------------
        // CASO 10: switch=1 con error en pos 1 → salida_selector=síndrome
        // ----------------------------------------------------------
        $display("\n[CASO 10] switch=1, error pos 1 → salida_selector debe ser 0001");
        rx = 7'b0110010;
        switch_selector = 1;
        #10;
        $write("[CASO 10] rx=%b switch=1 | salida_selector=%b | esperado=0001 | ",
                rx, salida_selector);
        if (salida_selector === 4'b0001)
            $display("OK");
        else
            $display("ERROR <<<");

        // ----------------------------------------------------------
        // CASO 11: switch=0 con error en pos 1 → salida_selector=dato corregido
        // ----------------------------------------------------------
        $display("\n[CASO 11] switch=0, error pos 1 → salida_selector debe ser 1011");
        switch_selector = 0;
        #10;
        $write("[CASO 11] rx=%b switch=0 | salida_selector=%b | esperado=1011 | ",
                rx, salida_selector);
        if (salida_selector === 4'b1011)
            $display("OK");
        else
            $display("ERROR <<<");

        // ----------------------------------------------------------
        // Casos borde
        // ----------------------------------------------------------
        $display("\n  Casos borde");
        $display("--------------------------------------------");

        // datos=0000
        verificar(7'b0000000, 3'b000, 4'b0000, 12);

        // datos=1111, rx=7'b1111111
        verificar(7'b1111111, 3'b000, 4'b1111, 13);

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule