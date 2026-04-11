`timescale 1ns/1ps

module selector_top_tb;
    // Señales de estímulo
    logic [3:0] dato_corregido;
    logic [2:0] posicion_error;
    logic [3:0] bin_desde_selector; // Esto simula el retorno de la proto
    
    // Señales de monitoreo
    logic [3:0] hacia_selector_A;
    logic [2:0] hacia_selector_B;
    logic [6:0] seg_out;

    // Instancia del módulo TOP
    selector_top dut (
        .dato_corregido(dato_corregido),
        .posicion_error(posicion_error),
        .hacia_selector_A(hacia_selector_A),
        .hacia_selector_B(hacia_selector_B),
        .bin_desde_selector(bin_desde_selector),
        .seg_out(seg_out)
    );

    // Lógica de simulación
    initial begin
        $dumpfile("selector_top_tb.vcd");
        $dumpvars(0, selector_top_tb);

        $display("Tiempo | Dato Corr | Error Pos | Regreso Proto | Display 7seg");
        $display("-------------------------------------------------------------");

        // CASO 1: Simulamos que el switch externo selecciona "Dato Corregido"
        // Dato corregido = 5 (4'b0101), Posición error = 3 (3'b011)
        dato_corregido = 4'h5; posicion_error = 3'h3;
        bin_desde_selector = hacia_selector_A; // Simulamos switch en OFF (pasa A)
        #10;
        $display("%t |    %h     |     %h     |       %h       |   %b", $time, dato_corregido, posicion_error, bin_desde_selector, seg_out);

        // CASO 2: Simulamos que el switch externo selecciona "Posición del Error"
        // El selector externo debería devolver el síndrome
        bin_desde_selector = {1'b0, hacia_selector_B}; // Simulamos switch en ON (pasa B con MSB en 0)
        #10;
        $display("%t |    %h     |     %h     |       %h       |   %b", $time, dato_corregido, posicion_error, bin_desde_selector, seg_out);

        // CASO 3: Otro valor (Dato = A, Error = 1)
        dato_corregido = 4'hA; posicion_error = 3'h1;
        bin_desde_selector = hacia_selector_A; // Volvemos a mostrar el dato
        #10;
        $display("%t |    %h     |     %h     |       %h       |   %b", $time, dato_corregido, posicion_error, bin_desde_selector, seg_out);

        #10;
        $finish;
    end
endmodule