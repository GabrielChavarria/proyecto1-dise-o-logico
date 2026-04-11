// ============================================================
// Módulo 7.2: Corrector de error
// EL-3307 Diseño Lógico — I Semestre 2026
// ============================================================
// Distribución de bits del transmisor (Transf[i] = rx[i]):
//   rx[0] = d1   (posición 1)
//   rx[1] = d2   (posición 2)
//   rx[2] = d3   (posición 3)
//   rx[3] = p4   (posición 4)
//   rx[4] = d4   (posición 5)
//   rx[5] = p2   (posición 6)
//   rx[6] = p1   (posición 7)
//
// error_pos viene del detector (valor 1-based):
//   000 = sin error
//   001 = error en posición 1 → rx[0]
//   010 = error en posición 2 → rx[1]
//   ...
//   111 = error en posición 7 → rx[6]
// ============================================================

module corrector_error (
    input  [6:0] rx,
    input  [2:0] error_pos,
    output reg [3:0] corrected
);

    // Corregir el bit indicado por error_pos
    // Se evita indexado dinámico para garantizar síntesis en Gowin
    wire [6:0] rx_fixed;

    assign rx_fixed[0] = (error_pos == 3'd1) ? ~rx[0] : rx[0]; // d1
    assign rx_fixed[1] = (error_pos == 3'd2) ? ~rx[1] : rx[1]; // d2
    assign rx_fixed[2] = (error_pos == 3'd3) ? ~rx[2] : rx[2]; // d3
    assign rx_fixed[3] = (error_pos == 3'd4) ? ~rx[3] : rx[3]; // p4 (no se extrae)
    assign rx_fixed[4] = (error_pos == 3'd5) ? ~rx[4] : rx[4]; // d4
    assign rx_fixed[5] = (error_pos == 3'd6) ? ~rx[5] : rx[5]; // p2 (no se extrae)
    assign rx_fixed[6] = (error_pos == 3'd7) ? ~rx[6] : rx[6]; // p1 (no se extrae)

    // Extraer solo los 4 bits de datos (d1, d2, d3, d4)
    always @(*) begin
        corrected[0] = rx_fixed[0]; // d1 → posición 1
        corrected[1] = rx_fixed[1]; // d2 → posición 2
        corrected[2] = rx_fixed[2]; // d3 → posición 3
        corrected[3] = rx_fixed[4]; // d4 → posición 5
    end

endmodule