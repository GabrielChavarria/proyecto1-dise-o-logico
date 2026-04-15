// ============================================================
// TOP MODULE: receptor_top
// EL-3307 Diseño Lógico — I Semestre 2026
//
// Jerarquía:
//   receptor_top
//   ├── detector_error   (Módulo 7.1) — calcula síndrome
//   ├── corrector_error  (Módulo 7.2) — corrige bit erróneo y extrae datos
//   ├── interfaz_leds    (Módulo 7.3) — mapea dato corregido a LEDs
//   └── selector         (Módulo 7.5)
//       └── decodificador_7seg (Módulo 7.4) — instanciado internamente
//
// Entradas externas:
//   rx[6:0]          — palabra Hamming recibida (7 bits)
//   switch_selector  — 0: mostrar dato corregido, 1: mostrar síndrome
//
// Salidas externas:
//   leds_out[3:0]    — LEDs con el dato corregido (4 bits)
//   seg_out[6:0]     — Display 7 segmentos {g,f,e,d,c,b,a} activo ALTO
//   salida_selector[3:0] — dato o síndrome según switch
// ============================================================

module receptor_top (
    input  logic [6:0] rx,               // Palabra Hamming recibida
    input  logic       switch_selector,  // 0=dato corregido, 1=síndrome

    output logic [3:0] leds_out,         // LEDs → dato corregido
    output logic [6:0] seg_out,          // Display 7 segmentos
);

    // --------------------------------------------------------
    // Señales internas entre módulos
    // --------------------------------------------------------
    wire [2:0] error_pos;      // Síndrome (posición del error)
    wire [3:0] dato_corregido; // 4 bits de datos corregidos

    // --------------------------------------------------------
    // Módulo 7.1 — Detector de error (síndrome)
    // --------------------------------------------------------
    detector_error U_detector (
        .rx        (rx),
        .error_pos (error_pos)
    );

    // --------------------------------------------------------
    // Módulo 7.2 — Corrector de error
    // --------------------------------------------------------
    corrector_error U_corrector (
        .rx        (rx),
        .error_pos (error_pos),
        .corrected (dato_corregido)
    );

    // --------------------------------------------------------
    // Módulo 7.3 — Interfaz de LEDs
    // --------------------------------------------------------
    interfaz_leds U_leds (
        .data_in  (dato_corregido),
        .leds_out (leds_out)
    );

    // --------------------------------------------------------
    // Módulo 7.5 — Selector + Display 7 segmentos (7.4 interno)
    // --------------------------------------------------------
    selector U_selector (
        .dato_corregido  (dato_corregido),
        .pos_error       (error_pos),
        .switch_selector (switch_selector),
        .salida_selector (salida_selector),
        .seg_out         (seg_out),
        .led_out         ()  // No conectado: leds_out ya lo maneja interfaz_leds
    );

endmodule