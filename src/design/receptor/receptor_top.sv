// ============================================================
// TOP MODULE: receptor_top
// ============================================================

module receptor_top (
    input  logic [6:0] rx,               // Palabra Hamming recibida
    input  logic       switch_selector,  // 0=dato corregido, 1=síndrome

    output logic [3:0] leds_out,         // LEDs → dato corregido
    output logic [6:0] seg_out,          // Display 7 segmentos
    output logic [3:0] salida_selector   // ⚠️ FALTABA en tu versión
);

    // --------------------------------------------------------
    // Señales internas entre módulos
    // --------------------------------------------------------
    logic [2:0] error_pos;      
    logic [3:0] dato_corregido; 
    logic [3:0] dummy_led;      // evita warnings por puerto no usado

    // --------------------------------------------------------
    // Módulo 7.1 — Detector de error
    // --------------------------------------------------------
    detector_error U_detector (
        .rx(rx),
        .error_pos(error_pos)
    );

    // --------------------------------------------------------
    // Módulo 7.2 — Corrector de error
    // --------------------------------------------------------
    corrector_error U_corrector (
        .rx(rx),
        .error_pos(error_pos),
        .corrected(dato_corregido)
    );

    // --------------------------------------------------------
    // Módulo 7.3 — Interfaz LEDs
    // --------------------------------------------------------
    interfaz_leds U_leds (
        .data_in(dato_corregido),
        .leds_out(leds_out)
    );

    // --------------------------------------------------------
    // Módulo 7.5 — Selector
    // --------------------------------------------------------
    selector U_selector (
        .dato_corregido(dato_corregido),
        .pos_error(error_pos),
        .switch_selector(switch_selector),
        .salida_selector(salida_selector),
        .seg_out(seg_out),
        .led_out(dummy_led)
    );

endmodule