// ============================================================
// Testbench: tb_corrector_error.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Verifica que el corrector:
//   1. Corrija el bit indicado por error_pos
//   2. Extraiga correctamente d1,d2,d3,d4
//   3. No cambie nada si error_pos=0
// ============================================================

`timescale 1ns/1ps

module corrector_error_tb;

    // ----------------------------------------------------------
    // Señales del DUT
    // ----------------------------------------------------------
    reg  [6:0] rx;
    reg  [2:0] error_pos;
    wire [3:0] corrected;

    // ----------------------------------------------------------
    // Instancia del DUT
    // ----------------------------------------------------------
    corrector_error DUT (
        .rx       (rx),
        .error_pos(error_pos),
        .corrected(corrected)
    );

    // ----------------------------------------------------------
    // Tarea de verificación
    // ----------------------------------------------------------
    task verificar;
        input [6:0]  entrada;
        input [2:0]  pos;
        input [3:0]  dato_esperado;
        input [31:0] num_caso;
        begin
            rx        = entrada;
            error_pos = pos;
            #10;
            $write("[CASO %0d] rx=%b pos=%b | corrected=%b (%0d) | esperado=%b (%0d) | ",
                    num_caso, entrada, pos,
                    corrected, corrected,
                    dato_esperado, dato_esperado);
            if (corrected === dato_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ----------------------------------------------------------
    // Estímulos
    // ============================================================
    // Palabra base: datos=1011, rx_correcto=7'b0110011
    //   rx[0]=d1=1, rx[1]=d2=1, rx[2]=d3=0
    //   rx[3]=p4=0, rx[4]=d4=1, rx[5]=p2=1, rx[6]=p1=0
    // dato_esperado = 4'b1011 (d4 d3 d2 d1)
    // ----------------------------------------------------------
    initial begin

        $dumpfile("tb_corrector_error.vcd");
        $dumpvars(0, tb_corrector_error);

        $display("============================================");
        $display("  TESTBENCH: corrector_error");
        $display("  datos base = 1011");
        $display("  rx correcto = 7'b0110011");
        $display("============================================");

        // CASO 1: sin error → extrae datos correctamente
        verificar(7'b0110011, 3'b000, 4'b1011, 1);

        // CASO 2: error en pos 1 (rx[0] invertido) → corrige d1
        verificar(7'b0110010, 3'b001, 4'b1011, 2);

        // CASO 3: error en pos 2 (rx[1] invertido) → corrige d2
        verificar(7'b0110001, 3'b010, 4'b1011, 3);

        // CASO 4: error en pos 3 (rx[2] invertido) → corrige d3
        verificar(7'b0110111, 3'b011, 4'b1011, 4);

        // CASO 5: error en pos 4 (rx[3] invertido) → corrige p4, datos sin cambio
        verificar(7'b0111011, 3'b100, 4'b1011, 5);

        // CASO 6: error en pos 5 (rx[4] invertido) → corrige d4
        verificar(7'b0100011, 3'b101, 4'b1011, 6);

        // CASO 7: error en pos 6 (rx[5] invertido) → corrige p2, datos sin cambio
        verificar(7'b0010011, 3'b110, 4'b1011, 7);

        // CASO 8: error en pos 7 (rx[6] invertido) → corrige p1, datos sin cambio
        verificar(7'b1110011, 3'b111, 4'b1011, 8);

        // ----------------------------------------------------------
        // Palabra: datos=0000, rx=7'b0000000
        // ----------------------------------------------------------
        $display("\n  datos base = 0000");
        $display("  rx correcto = 7'b0000000");
        $display("--------------------------------------------");

        verificar(7'b0000000, 3'b000, 4'b0000, 9);
        verificar(7'b0000001, 3'b001, 4'b0000, 10);
        verificar(7'b0000010, 3'b010, 4'b0000, 11);
        verificar(7'b0000100, 3'b011, 4'b0000, 12);
        verificar(7'b0001000, 3'b100, 4'b0000, 13);
        verificar(7'b0010000, 3'b101, 4'b0000, 14);
        verificar(7'b0100000, 3'b110, 4'b0000, 15);
        verificar(7'b1000000, 3'b111, 4'b0000, 16);

        // ----------------------------------------------------------
        // Palabra: datos=1111, rx=7'b1111111
        // ----------------------------------------------------------
        $display("\n  datos base = 1111");
        $display("  rx correcto = 7'b1111111");
        $display("--------------------------------------------");

        verificar(7'b1111111, 3'b000, 4'b1111, 17);
        verificar(7'b1111110, 3'b001, 4'b1111, 18);
        verificar(7'b1111101, 3'b010, 4'b1111, 19);
        verificar(7'b1111011, 3'b011, 4'b1111, 20);
        verificar(7'b1110111, 3'b100, 4'b1111, 21);
        verificar(7'b1101111, 3'b101, 4'b1111, 22);
        verificar(7'b1011111, 3'b110, 4'b1111, 23);
        verificar(7'b0111111, 3'b111, 4'b1111, 24);

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule