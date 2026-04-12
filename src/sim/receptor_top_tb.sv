// Testbench: Receptor Top — integra 7.1 y 7.2
// CAMBIOS:
//   1. Se agregan vectores que cubren error en cada posición (1–7)
//   2. Se agrega verificación automática con assert para cada caso

`timescale 1ns/1ps

module receptor_top_tb;

    logic [6:0] rx;
    logic [2:0] error_pos;
    logic [3:0] corrected;

    receptor_top uut (
        .rx       (rx),
        .error_pos(error_pos),
        .corrected(corrected)
    );

    initial begin
        $dumpfile("receptor_top_tb.vcd");
        $dumpvars(0, receptor_top_tb);
    end

    // Tarea auxiliar: aplica vector, espera y verifica
    // Parámetros: rx_val, error_pos esperado, corrected esperado
    task automatic aplicar_caso;
        input [6:0]  rx_in;
        input [2:0]  exp_error;
        input [3:0]  exp_corrected;
        input string descripcion;
        begin
            rx = rx_in; #10;
            $display("%4t | %b | ep=%b (esp %b) | corr=%b (esp %b) | %s",
                     $time, rx, error_pos, exp_error,
                     corrected, exp_corrected, descripcion);

            // Verificación automática
            if (error_pos !== exp_error)
                $display("  *** FALLO error_pos: obtenido %b, esperado %b ***",
                         error_pos, exp_error);
            if (corrected !== exp_corrected)
                $display("  *** FALLO corrected: obtenido %b, esperado %b ***",
                         corrected, exp_corrected);
        end
    endtask

    initial begin
        $display("==============================================================");
        $display("       PRUEBA DEL RECEPTOR HAMMING (7,4)                      ");
        $display("==============================================================");
        $display("Tiempo | rx        | error_pos       | corrected       | Caso");
        $display("==============================================================");

        // Palabra de referencia: datos = 4'b1011 → Hamming = 7'b1010101
        // Posiciones Hamming: p1=1,p2=0,d1=1,p3=0,d2=1,d3=0,d4=1 → rx=1010101

        // Caso 1: sin error → error_pos=000, corrected=1011
        aplicar_caso(7'b1010101, 3'b000, 4'b1011, "Sin error");

        // Caso 2: error en posición 1 (bit p1) → error_pos=001
        aplicar_caso(7'b1010100, 3'b001, 4'b1011, "Error pos 1 (P1)");

        // Caso 3: error en posición 2 (bit p2) → error_pos=010
        aplicar_caso(7'b1010111, 3'b010, 4'b1011, "Error pos 2 (P2)");

        // Caso 4: error en posición 3 (bit d1) → error_pos=011
        aplicar_caso(7'b1010001, 3'b011, 4'b1011, "Error pos 3 (D1)");

        // Caso 5: error en posición 4 (bit p3) → error_pos=100
        aplicar_caso(7'b1011101, 3'b100, 4'b1011, "Error pos 4 (P3)");

        // Caso 6: error en posición 5 (bit d2) → error_pos=101
        aplicar_caso(7'b1000101, 3'b101, 4'b1011, "Error pos 5 (D2)");

        // Caso 7: error en posición 6 (bit d3) → error_pos=110
        aplicar_caso(7'b1110101, 3'b110, 4'b1011, "Error pos 6 (D3)");

        // Caso 8: error en posición 7 (bit d4) → error_pos=111
        aplicar_caso(7'b0010101, 3'b111, 4'b1011, "Error pos 7 (D4)");

        // Caso 9: palabra todos unos sin error → corrected=1111
        aplicar_caso(7'b1110111, 3'b000, 4'b1111, "Todos unos sin error");

        $display("==============================================================");
        $display(" SIMULACIÓN FINALIZADA ");
        $display("==============================================================");

        $finish;
    end

endmodule