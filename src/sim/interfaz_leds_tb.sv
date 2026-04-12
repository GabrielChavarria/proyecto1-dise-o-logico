// Testbench: Sección 7.3 — Interfaz LEDs

`timescale 1ns/1ps

module interfaz_leds_tb;

    logic [3:0] data_in;
    logic [3:0] leds_out;

    interfaz_leds uut (
        .data_in (data_in),
        .leds_out(leds_out)
    );

    initial begin
        $dumpfile("interfaz_leds_tb.vcd");
        $dumpvars(0, interfaz_leds_tb);
    end

    initial begin
        $display("==============================================");
        $display("   PRUEBA DE FUNCIONAMIENTO: SECCIÓN 7.3     ");
        $display("==============================================");
        $display(" Tiempo | Entrada (Data) | Salida (LEDs) ");
        $display("==============================================");

        // Caso 1: Todo apagado
        data_in = 4'b0000; #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 2: Patrón alternado (0101 = 5)
        data_in = 4'b0101; #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 3: Patrón alternado (1010 = A)
        data_in = 4'b1010; #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 4: Solo MSB (1000 = 8)
        data_in = 4'b1000; #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 5: Todos encendidos (1111 = F)
        data_in = 4'b1111; #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        $display("==============================================");
        $display(" SIMULACIÓN FINALIZADA CON ÉXITO ");
        $display("==============================================");

        $finish;
    end

endmodule
