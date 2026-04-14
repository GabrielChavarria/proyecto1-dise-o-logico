`timescale 1ns / 1ps

module secded_detector_tb;

    // Señales de prueba
    reg [7:0] rx_ext;
    reg [2:0] syndrome;
    wire [1:0] error_type;

    // Instancia del módulo (Unit Under Test)
    secded_detector uut (
        .rx_ext(rx_ext),
        .syndrome(syndrome),
        .error_type(error_type)
    );

    initial begin
        // Monitor para ver resultados en consola
        $monitor("Tiempo=%0t | RX=%b | Sindrome=%b | Tipo_Error=%b", 
                 $time, rx_ext, syndrome, error_type);

        // --- CASO 1: Sin error ---
        // Palabra correcta (ejemplo), paridad global calculada debe dar 0
        rx_ext = 8'b01101001; 
        syndrome = 3'b000;
        #10;

        // --- CASO 2: Un error ---
        // Invertimos el bit 0. Paridad global ahora es 1, síndrome no es 0
        rx_ext = 8'b01101000; 
        syndrome = 3'b001;
        #10;

        // --- CASO 3: Error en bit de paridad global ---
        // Datos correctos (syndrome 0) pero paridad global invertida
        rx_ext = 8'b11101001; 
        syndrome = 3'b000;
        #10;

        // --- CASO 4: Doble error (Puntos Extra) ---
        // Invertimos bits 0 y 1. Paridad global vuelve a ser 0, pero síndrome detecta algo
        rx_ext = 8'b01101010; 
        syndrome = 3'b011; // El síndrome dependerá de tu lógica de Hamming (7,4)
        #10;

        $finish;
    end

endmodule