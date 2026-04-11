// ============================================================
// receptor_top.sv
// Top module unificado del Receptor — Hamming (7,4) + SECDED
// EL-3307 Diseño Lógico — I Semestre 2026
// ============================================================
// Integra:
//   - detector_error    (7.1)
//   - corrector_error   (7.2)
//   - secded_detector   (extra)
//   - decodificador_7seg (7.4)
//   - Selector y LEDs   (7.3 / 7.5)
// ============================================================

module receptor_top (

    // ----------------------------------------------------------
    // Entradas desde el transmisor (7 bits Hamming)
    // ----------------------------------------------------------
    input  [6:0] rx,             // palabra recibida

    // ----------------------------------------------------------
    // Switch selector (protoboard)
    // 0 = mostrar dato corregido
    // 1 = mostrar síndrome (posición del error)
    // ----------------------------------------------------------
    input        switch_selector,

    // ----------------------------------------------------------
    // Salidas físicas hacia protoboard / selector externo
    // ----------------------------------------------------------
    output [3:0] salida_selector, // dato corregido o síndrome (4 bits)
    output [6:0] seg_out,         // display 7 segmentos

    // ----------------------------------------------------------
    // Salidas hacia LEDs internos de la Tang Nano
    // ----------------------------------------------------------
    output [3:0] led_out,         // dato corregido en LEDs internos

    // ----------------------------------------------------------
    // Salida de posición del error (para depuración)
    // ----------------------------------------------------------
    output [2:0] error_pos        // síndrome: 0 = sin error

);

    // ----------------------------------------------------------
    // Señales internas
    // ----------------------------------------------------------
    wire [2:0] sindrome;          // posición del error (1-based)
    wire [3:0] dato_corregido;    // 4 bits de datos corregidos
    wire [1:0] error_type;        // clasificación SECDED

    // ----------------------------------------------------------
    // Paridad global (Opción B: calculada localmente)
    // XOR de los 7 bits recibidos
    // ----------------------------------------------------------
    wire parity_global;
    assign parity_global = rx[0] ^ rx[1] ^ rx[2] ^ rx[3] ^
                           rx[4] ^ rx[5] ^ rx[6];

    wire [7:0] rx_ext;
    assign rx_ext = {parity_global, rx};

    // ----------------------------------------------------------
    // Módulo 7.1: Detector de error
    // ----------------------------------------------------------
    detector_error det (
        .rx       (rx),
        .error_pos(sindrome)
    );

    // ----------------------------------------------------------
    // Módulo 7.2: Corrector de error
    // ----------------------------------------------------------
    corrector_error cor (
        .rx       (rx),
        .error_pos(sindrome),
        .corrected(dato_corregido)
    );

    // ----------------------------------------------------------
    // Módulo SECDED: clasificación del tipo de error
    // ----------------------------------------------------------
    secded_detector secded (
        .rx_ext    (rx_ext),
        .syndrome  (sindrome),
        .error_type(error_type)
    );

    // ----------------------------------------------------------
    // Lógica final: selección del dato a mostrar
    // según clasificación SECDED
    // ----------------------------------------------------------
    reg [3:0] dato_final;

    always @(*) begin
        case (error_type)
            2'b00: dato_final = dato_corregido; // sin error
            2'b01: dato_final = dato_corregido; // 1 error corregido
            2'b10: dato_final = 4'b1111;        // doble error, dato no confiable
            2'b11: dato_final = dato_corregido; // error solo en bit paridad global
            default: dato_final = 4'b1111;
        endcase
    end

    // ----------------------------------------------------------
    // Selector (7.5): decide qué enviar a la protoboard
    // switch=0 → dato corregido
    // switch=1 → síndrome (posición del error, bit extra = 0)
    // ----------------------------------------------------------
    reg [3:0] sel_out;

    always @(*) begin
        case (switch_selector)
            1'b0: sel_out = dato_final;              // dato corregido
            1'b1: sel_out = {1'b0, sindrome};        // síndrome con MSB=0
            default: sel_out = dato_final;
        endcase
    end

    // ----------------------------------------------------------
    // Módulo 7.4: Decodificador 7 segmentos
    // Muestra lo que seleccionó el switch
    // ----------------------------------------------------------
    decodificador_7seg deco (
        .bin_in (sel_out),
        .seg_out(seg_out)
    );

    // ----------------------------------------------------------
    // Salidas
    // ----------------------------------------------------------
    assign salida_selector = sel_out;
    assign led_out         = dato_final; // LEDs siempre muestran dato corregido
    assign error_pos       = sindrome;

endmodule