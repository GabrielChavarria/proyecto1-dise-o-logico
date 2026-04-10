`timescale 1ns/1ps

module secded_tb;

    // Entradas
    reg [6:0] rx;

    // Salidas
    wire [2:0] error_pos;
    wire [3:0] corrected;

    // Si agregaste SECDED
    wire double_error;

    // Instancia del TOP
    receptor_top uut (
        .rx(rx),
        .error_pos(error_pos),
        .corrected(corrected)
        // agrega aquí double_error si lo conectaste en el top
    );

    // Generar archivo VCD
    initial begin
        $dumpfile("receptor_top_tb.vcd");
        $dumpvars(0, secded_tb);
    end

    // Pruebas
    initial begin

        $display("==============================================");
        $display(" PRUEBA SECDED ");
        $display("==============================================");
        $display("Tiempo | rx       | error_pos | corrected");
        $display("==============================================");

        // CASO 1: SIN ERROR
        rx = 7'b1010101;
        #10;

        // CASO 2: 1 ERROR
        rx = 7'b1010100; // cambia 1 bit
        #10;

        // CASO 3: OTRO ERROR
        rx = 7'b1010001;
        #10;

        // 🚨 CASO 4: 2 ERRORES (SECDED)
        rx = 7'b1000001; // cambia 2 bits
        #10;

        // EXTRA
        rx = 7'b1111111;
        #10;

        $finish;
    end

    // Monitor en consola
    initial begin
        $monitor("%4t   | %b |   %b     |   %b",
                 $time, rx, error_pos, corrected);
    end

endmodule