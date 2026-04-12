// Sección 7.3: interfaz de LEDs (Receptor/ Salida)
module interfaz_leds (
    input  [3:0] data_in,  // Dato de 4 bits que entra
    output [3:0] leds_out  // Salida para los LEDs
);

// Se asigna la entrada a la salida usando ecuaciones de identidad.

assign leds_out = data_in;

endmodule

