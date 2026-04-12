// ============================================================
// Testbench: tb_detector_error.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Verifica que el síndrome sea correcto para:
//   - Palabra sin error
//   - Error en cada una de las 7 posiciones
// ============================================================
// Distribución del transmisor:
//   rx[0]=d1, rx[1]=d2, rx[2]=d3, rx[3]=p4
//   rx[4]=d4, rx[5]=p2, rx[6]=p1
// ============================================================

`timescale 1ns/1ps

module tb_detector_error;

    // ----------------------------------------------------------
    // Señales del DUT
    // ----------------------------------------------------------
    reg  [6:0] rx;
    wire [2:0] error_pos;

    // ----------------------------------------------------------
    // Instancia del DUT
    // ----------------------------------------------------------
    detector_error DUT (
        .rx       (rx),
        .error_pos(error_pos)
    );

    // ----------------------------------------------------------
    // Tarea de verificación
    // ----------------------------------------------------------
    task verificar;
        input [6:0] entrada;
        input [2:0] sindrome_esperado;
        input [31:0] num_caso;
        begin
            rx = entrada;
            #10;
            $write("[CASO %0d] rx=%b | sindrome=%b (%0d) | esperado=%b (%0d) | ",
                    num_caso, entrada, error_pos, error_pos,
                    sindrome_esperado, sindrome_esperado);
            if (error_pos === sindrome_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ----------------------------------------------------------
    // Estímulos
    // ============================================================
    // Palabra de prueba: datos = 4'b1011
    // Transmisor calcula:
    //   p1 = d4^d3^d1 = 1^0^1 = 0 → rx[6] = 0
    //   p2 = d4^d2^d1 = 1^1^1 = 1 → rx[5] = 1
    //   d4 = 1                     → rx[4] = 1
    //   p4 = d3^d2^d1 = 0^1^1 = 0 → rx[3] = 0
    //   d3 = 0                     → rx[2] = 0
    //   d2 = 1                     → rx[1] = 1
    //   d1 = 1                     → rx[0] = 1
    //   rx_correcto = 7'b0110011
    // ----------------------------------------------------------
    initial begin

        $dumpfile("tb_detector_error.vcd");
        $dumpvars(0, tb_detector_error);

        $display("============================================");
        $display("  TESTBENCH: detector_error");
        $display("  datos base = 1011");
        $display("  rx correcto = 7'b0110011");
        $display("============================================");

        // CASO 1: sin error → síndrome = 000
        verificar(7'b0110011, 3'b000, 1);

        // CASO 2: error en posición 1 (rx[0] invertido) → síndrome = 001
        verificar(7'b0110010, 3'b001, 2);

        // CASO 3: error en posición 2 (rx[1] invertido) → síndrome = 010
        verificar(7'b0110001, 3'b010, 3);

        // CASO 4: error en posición 3 (rx[2] invertido) → síndrome = 011
        verificar(7'b0110111, 3'b011, 4);

        // CASO 5: error en posición 4 (rx[3] invertido) → síndrome = 100
        verificar(7'b0111011, 3'b100, 5);

        // CASO 6: error en posición 5 (rx[4] invertido) → síndrome = 101
        verificar(7'b0100011, 3'b101, 6);

        // CASO 7: error en posición 6 (rx[5] invertido) → síndrome = 110
        verificar(7'b0010011, 3'b110, 7);

        // CASO 8: error en posición 7 (rx[6] invertido) → síndrome = 111
        verificar(7'b1110011, 3'b111, 8);

        // ----------------------------------------------------------
        // Segunda palabra: datos = 4'b0000
        // p1=0, p2=0, p4=0 → rx = 7'b0000000
        // ----------------------------------------------------------
        $display("\n  datos base = 0000");
        $display("  rx correcto = 7'b0000000");
        $display("--------------------------------------------");

        verificar(7'b0000000, 3'b000, 9);
        verificar(7'b0000001, 3'b001, 10);
        verificar(7'b0000010, 3'b010, 11);
        verificar(7'b0000100, 3'b011, 12);
        verificar(7'b0001000, 3'b100, 13);
        verificar(7'b0010000, 3'b101, 14);
        verificar(7'b0100000, 3'b110, 15);
        verificar(7'b1000000, 3'b111, 16);

        // ----------------------------------------------------------
        // Tercera palabra: datos = 4'b1111
        // p1 = 1^1^1 = 1, p2 = 1^1^1 = 1, p4 = 1^1^1 = 1
        // rx = 7'b1111111
        // ----------------------------------------------------------
        $display("\n  datos base = 1111");
        $display("  rx correcto = 7'b1111111");
        $display("--------------------------------------------");

        verificar(7'b1111111, 3'b000, 17);
        verificar(7'b1111110, 3'b001, 18);
        verificar(7'b1111101, 3'b010, 19);
        verificar(7'b1111011, 3'b011, 20);
        verificar(7'b1110111, 3'b100, 21);
        verificar(7'b1101111, 3'b101, 22);
        verificar(7'b1011111, 3'b110, 23);
        verificar(7'b0111111, 3'b111, 24);

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule