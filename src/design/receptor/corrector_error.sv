// ============================================================
// Módulo 7.2: Corrector de error
// EL-3307 Diseño Lógico — I Semestre 2026
// ============================================================
// Distribución del transmisor (Transf[i] = rx[i]):
//   rx[0]=d1, rx[1]=d2, rx[2]=d3, rx[3]=p4
//   rx[4]=d4, rx[5]=p2, rx[6]=p1
//
// Tabla de síndromes (obtenida por simulación):
//   síndrome=000 → sin error
//   síndrome=111 → error en rx[0]=d1
//   síndrome=110 → error en rx[1]=d2
//   síndrome=101 → error en rx[2]=d3
//   síndrome=100 → error en rx[3]=p4 (no es dato)
//   síndrome=011 → error en rx[4]=d4
//   síndrome=010 → error en rx[5]=p2 (no es dato)
//   síndrome=001 → error en rx[6]=p1 (no es dato)
// ============================================================

module corrector_error (
    input  [6:0] rx,
    input  [2:0] error_pos,
    output reg [3:0] corrected
);

    // Corregir el bit indicado por la tabla de síndromes
    wire [6:0] rx_fixed;

    assign rx_fixed[0] = (error_pos == 3'b111) ? ~rx[0] : rx[0]; // d1
    assign rx_fixed[1] = (error_pos == 3'b110) ? ~rx[1] : rx[1]; // d2
    assign rx_fixed[2] = (error_pos == 3'b101) ? ~rx[2] : rx[2]; // d3
    assign rx_fixed[3] = (error_pos == 3'b100) ? ~rx[3] : rx[3]; // p4 (no se extrae)
    assign rx_fixed[4] = (error_pos == 3'b011) ? ~rx[4] : rx[4]; // d4
    assign rx_fixed[5] = (error_pos == 3'b010) ? ~rx[5] : rx[5]; // p2 (no se extrae)
    assign rx_fixed[6] = (error_pos == 3'b001) ? ~rx[6] : rx[6]; // p1 (no se extrae)

    // Extraer solo los 4 bits de datos
    always @(*) begin
        corrected[0] = rx_fixed[0]; // d1
        corrected[1] = rx_fixed[1]; // d2
        corrected[2] = rx_fixed[2]; // d3
        corrected[3] = rx_fixed[4]; // d4
    end

endmodule