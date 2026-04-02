// Sección 7.3: interfaz de LEDs (Receptor/ Salida)
// Descripción: Este módulo se encarga de tomar el dato procesado por el receptor y mostrarlo en los LEDs.
module interfaz_leds (
    input logic [3:0] data_in, // Dato de 4 bits que se mostrará en los LEDs
    output logic [3:0] leds_out  // Salida para los LEDs
);

// El enunciado pide que la lógica se escriba en ecaciones booleanas, por lo que se asigna directamente 
//la entrada a la salida.

assing codigo_bin_led_po[0]= datos_corregidos[0];
assign codigo_bin_led_po[1]= datos_corregidos[1];
assign codigo_bin_led_po[2]= datos_corregidos[2];       
assign codigo_bin_led_po[3]= datos_corregidos[3];

endmodule

