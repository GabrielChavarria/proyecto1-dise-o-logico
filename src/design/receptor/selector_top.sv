// Sección 7.5: Integración con Selector Externo 
// Este módulo define los cables que van a la protoboard y regresan a la FPGA

module selector_top (
    // 1. Entradas desde la lógica del receptor (Simuladas aquí como entradas del top)
    input  logic [3:0] dato_corregido,    // Viene de la lógica de Hamming
    input  logic [2:0] posicion_error,    // El síndrome de 3 bits
    
    // 2. Salidas HACIA la protoboard (Pines que enviarán datos al 74LS157)
    output logic [3:0] hacia_selector_A,  // Palabra corregida
    output logic [2:0] hacia_selector_B,  // Posición del error
    
    // 3. Entradas DESDE la protoboard (Lo que regresa del selector externo)
    input  logic [3:0] bin_desde_selector,
    
    // 4. Salida final al display (Controlada por el decodificador que ya hiciste)
    output logic [6:0] seg_out
);

    // Conexión física: Sacamos los datos internos a los pines de la FPGA
    assign hacia_selector_A = dato_corregido;
    assign hacia_selector_B = posicion_error;

    // Instancia del decodificador que ya tienes listo
    // bin_in ahora recibe lo que viene procesado desde la protoboard
    decodificador_7seg mi_deco (
        .bin_in(bin_desde_selector), 
        .seg_out(seg_out)
    );

endmodule
