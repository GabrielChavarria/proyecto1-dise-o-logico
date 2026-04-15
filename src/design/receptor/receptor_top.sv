// ============================================================
// TOP MODULE: receptor_top
// ============================================================

module receptor_top (
    input  logic [6:0] rx,               // Palabra Hamming recibida
    input  logic       switch_selector,  // 0=dato corregido, 1=síndrome

    output logic [3:0] leds_out,         // LEDs → dato corregido
    output logic [6:0] seg_out,          // Display 7 segmentos
    output logic [3:0] salida_selector   // FALTABA en tu versión
);

    // --------------------------------------------------------
    // Señales internas entre módulos
    // --------------------------------------------------------
    logic [2:0] error_pos;      
    logic [3:0] dato_corregido; 

    // --------------------------------------------------------
    // Lógica integrada del Detector de error (7.1)
    // --------------------------------------------------------
    assign error_pos[0] = rx[6] ^ rx[4] ^ rx[2] ^ rx[0];
    assign error_pos[1] = rx[5] ^ rx[4] ^ rx[1] ^ rx[0];
    assign error_pos[2] = rx[3] ^ rx[2] ^ rx[1] ^ rx[0];

    // --------------------------------------------------------
    // Lógica integrada del Corrector de error (7.2)
    // --------------------------------------------------------
    logic [6:0] rx_fixed;

    assign rx_fixed[0] = (error_pos == 3'b111) ? ~rx[0] : rx[0];
    assign rx_fixed[1] = (error_pos == 3'b110) ? ~rx[1] : rx[1];
    assign rx_fixed[2] = (error_pos == 3'b101) ? ~rx[2] : rx[2];
    assign rx_fixed[3] = (error_pos == 3'b100) ? ~rx[3] : rx[3];
    assign rx_fixed[4] = (error_pos == 3'b011) ? ~rx[4] : rx[4];
    assign rx_fixed[5] = (error_pos == 3'b010) ? ~rx[5] : rx[5];
    assign rx_fixed[6] = (error_pos == 3'b001) ? ~rx[6] : rx[6];

    assign dato_corregido = {rx_fixed[4], rx_fixed[2], rx_fixed[1], rx_fixed[0]};

    // --------------------------------------------------------
    // Lógica integrada de Interfaz LEDs (7.3)
    // --------------------------------------------------------
    assign leds_out = dato_corregido;

    // --------------------------------------------------------
    // Lógica integrada del Selector (7.5) y Decodificador 7 segmentos
    // --------------------------------------------------------
    logic [3:0] salida_selector_int;

    always_comb begin
        case (switch_selector)
            1'b0: salida_selector_int = dato_corregido;
            1'b1: salida_selector_int = {1'b0, error_pos};
        endcase
    end

    assign salida_selector = salida_selector_int;

    always_comb begin
        case (salida_selector_int)
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