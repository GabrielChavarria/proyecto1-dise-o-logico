`timescale 1ns / 1ps

module receptor_top_tb;

    // ------------------------------
    // Señales de prueba
    // ------------------------------
    reg  [6:0] rx;
    wire [2:0] error_pos;
    wire [3:0] corrected;

    // ------------------------------
    // Instancia del módulo bajo prueba (UUT)
    // ------------------------------
    receptor_top uut (
        .rx(rx),
        .error_pos(error_pos),
        .corrected(corrected)
    );

    // ------------------------------
    // Generación de archivo de ondas
    // ------------------------------
    initial begin
        $dumpfile("receptor_top_tb.vcd");
        $dumpvars(0, receptor_top_tb);
    end

    // ------------------------------
    // Casos de prueba
    // ------------------------------
    initial begin
        $display("==============================================");
        $display(" PRUEBA DEL RECEPTOR HAMMING (7,4) ");
        $display("==============================================");
        $display("Tiempo | rx       | error_pos | corrected");
        $display("==============================================");

        // Caso 1: palabra sin error
        rx = 7'b1010101;
        #10;
        $display("%4t   | %b |   %b     |   %b", $time, rx, error_pos, corrected);

        // Caso 2: error en el bit 0
        rx = 7'b1010100;
        #10;
        $display("%4t   | %b |   %b     |   %b", $time, rx, error_pos, corrected);

        // Caso 3: error en el bit 2
        rx = 7'b1010001;
        #10;
        $display("%4t   | %b |   %b     |   %b", $time, rx, error_pos, corrected);

        // Caso 4: error en el bit 6
        rx = 7'b0010101;
        #10;
        $display("%4t   | %b |   %b     |   %b", $time, rx, error_pos, corrected);

        // Caso 5: otro ejemplo
        rx = 7'b1111111;
        #10;
        $display("%4t   | %b |   %b     |   %b", $time, rx, error_pos, corrected);

        $display("==============================================");
        $finish;
    end

endmodule