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
    output logic [3:0] salida_selector   // Salida al selector externo
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


// ============================================================
// Submódulos incluidos en el mismo archivo
// (si se compila todo junto no es necesario incluirlos aquí;
//  descomentar si se quiere un único archivo autónomo)
// ============================================================

// ---- Módulo 7.1: Detector de error -------------------------
module detector_error (
    input  [6:0] rx,
    output [2:0] error_pos
);
    assign error_pos[0] = rx[6] ^ rx[4] ^ rx[2] ^ rx[0]; // s0: verifica p1
    assign error_pos[1] = rx[5] ^ rx[4] ^ rx[1] ^ rx[0]; // s1: verifica p2
    assign error_pos[2] = rx[3] ^ rx[2] ^ rx[1] ^ rx[0]; // s2: verifica p4
endmodule


// ---- Módulo 7.2: Corrector de error ------------------------
module corrector_error (
    input  [6:0] rx,
    input  [2:0] error_pos,
    output reg [3:0] corrected
);
    wire [6:0] rx_fixed;

    assign rx_fixed[0] = (error_pos == 3'b111) ? ~rx[0] : rx[0]; // d1
    assign rx_fixed[1] = (error_pos == 3'b110) ? ~rx[1] : rx[1]; // d2
    assign rx_fixed[2] = (error_pos == 3'b101) ? ~rx[2] : rx[2]; // d3
    assign rx_fixed[3] = (error_pos == 3'b100) ? ~rx[3] : rx[3]; // p4
    assign rx_fixed[4] = (error_pos == 3'b011) ? ~rx[4] : rx[4]; // d4
    assign rx_fixed[5] = (error_pos == 3'b010) ? ~rx[5] : rx[5]; // p2
    assign rx_fixed[6] = (error_pos == 3'b001) ? ~rx[6] : rx[6]; // p1

    always @(*) begin
        corrected[0] = rx_fixed[0]; // d1
        corrected[1] = rx_fixed[1]; // d2
        corrected[2] = rx_fixed[2]; // d3
        corrected[3] = rx_fixed[4]; // d4
    end
endmodule


// ---- Módulo 7.3: Interfaz de LEDs --------------------------
module interfaz_leds (
    input  [3:0] data_in,
    output [3:0] leds_out
);
    assign leds_out = data_in;
endmodule


// ---- Módulo 7.4: Decodificador Hexadecimal a 7 Segmentos ---
module decodificador_7seg (
    input  logic [3:0] bin_in,
    output logic [6:0] seg_out
);
    always_comb begin
        case (bin_in)
            4'h0: seg_out = 7'b0111111;
            4'h1: seg_out = 7'b0000110;
            4'h2: seg_out = 7'b1011011;
            4'h3: seg_out = 7'b1001111;
            4'h4: seg_out = 7'b1100110;
            4'h5: seg_out = 7'b1101101;
            4'h6: seg_out = 7'b1111101;
            4'h7: seg_out = 7'b0000111;
            4'h8: seg_out = 7'b1111111;
            4'h9: seg_out = 7'b1101111;
            4'hA: seg_out = 7'b1110111;
            4'hB: seg_out = 7'b1111100;
            4'hC: seg_out = 7'b0111001;
            4'hD: seg_out = 7'b1011110;
            4'hE: seg_out = 7'b1111001;
            4'hF: seg_out = 7'b1110001;
            default: seg_out = 7'b0111111;
        endcase
    end
endmodule


// ---- Módulo 7.5: Selector ----------------------------------
module selector (
    input  logic [3:0] dato_corregido,
    input  logic [2:0] pos_error,
    input  logic       switch_selector,

    output logic [3:0] salida_selector,
    output logic [6:0] seg_out,
    output logic [3:0] led_out
);
    always_comb begin
        case (switch_selector)
            1'b0: salida_selector = dato_corregido;
            1'b1: salida_selector = {1'b0, pos_error};
        endcase
    end

    decodificador_7seg U1 (
        .bin_in (salida_selector),
        .seg_out(seg_out)
    );

    assign led_out = dato_corregido;
endmodule
