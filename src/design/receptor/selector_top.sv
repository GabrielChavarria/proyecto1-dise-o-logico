// Sección 7.5: Integración con Selector Externo
// Este módulo define los cables que van a la protoboard y regresan a la FPGA

module selector_top (

    // Entradas desde receptor_top — cables que llegan a la FPGA
    input  logic [3:0] dato_corregido,  // Palabra corregida del módulo 7.2
    input  logic [2:0] pos_error,       // Posición del error del módulo 7.1
    input  logic       switch_selector, // Switch: 0 = dato corregido, 1 = síndrome

    // Salidas hacia la protoboard — cables que salen de la FPGA
    output logic [3:0] salida_selector, // Al selector externo en la protoboard
    output logic [6:0] seg_out,         // Al display de 7 segmentos
    output logic [3:0] led_out          // A los LEDs de la FPGA
);

    //--- 1. Selector: elige entre dato corregido o posición del error ---
    always_comb begin
        case (switch_selector)
            1'b0: salida_selector = dato_corregido;
            1'b1: salida_selector = {1'b0, pos_error}; // 3 bits → 4 bits, MSB=0
        endcase
    end

    //--- 2. Display de 7 segmentos: muestra lo seleccionado ---
    decodificador_7seg U1 (
        .bin_in (salida_selector),
        .seg_out(seg_out)
    );

    //--- 3. LEDs: siempre muestran el dato corregido (según diagrama Fig. 3) ---
    assign led_out = dato_corregido;

endmodule


