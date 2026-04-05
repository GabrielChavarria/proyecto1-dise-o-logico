`timescale 1ns/1ps

module interfaz_leds_tb;

    // 1. Señales de prueba (Cables virtuales)
    // Usamos 'reg' para las entradas que vamos a manipular
    // y 'wire' para las salidas que vamos a observar
    reg  [3:0] data_in;
    wire [3:0] leds_out;

    // 2. Instancia del módulo bajo prueba (UUT)
    // Aquí conectamos los cables del testbench a tu código real
    interfaz_leds uut (
        .data_in(data_in),   // Conecta la entrada del diseño al reg data_in
        .leds_out(leds_out)  // Conecta la salida del diseño al wire leds_out
    );

    // 3. Generación de archivo de ondas (Para ver los diagramas en GTKWave)
    initial begin
        $dumpfile("interfaz_leds_tb.vcd");
        $dumpvars(0, interfaz_leds_tb);
    end

    // 4. Secuencia de prueba (Estímulos)
    initial begin
        $display("==============================================");
        $display("   PRUEBA DE FUNCIONAMIENTO: SECCIÓN 7.3     ");
        $display("==============================================");
        $display(" Tiempo | Entrada (Data) | Salida (LEDs) ");
        $display("==============================================");

        // Caso 1: Todo apagado
        data_in = 4'b0000; 
        #10; // Esperamos 10 unidades de tiempo
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 2: Patrón alternado (Número 10 en binario)
        data_in = 4'b1010; 
        #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 3: Solo el bit más significativo (Número 8)
        data_in = 4'b1000; 
        #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        // Caso 4: Todos encendidos (Número 15)
        data_in = 4'b1111; 
        #10;
        $display(" %4t   |      %b      |     %b", $time, data_in, leds_out);

        $display("==============================================");
        $display(" SIMULACIÓN FINALIZADA CON ÉXITO ");
        $display("==============================================");
        
        $finish; // Detiene el simulador
    end

endmodule
