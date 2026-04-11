// Módulo 7.2: Corrector de error
module corrector_error (
    input  [6:0] rx,
    input  [2:0] error_pos,
    output reg [3:0] corrected
);

    // Corregir el bit indicado por error_pos (valor 1-based)
    // Se evita indexado dinámico para garantizar síntesis correcta en Gowin
    wire [6:0] rx_fixed;

    assign rx_fixed[0] = (error_pos == 3'd1) ? ~rx[0] : rx[0]; // p1
    assign rx_fixed[1] = (error_pos == 3'd2) ? ~rx[1] : rx[1]; // p2
    assign rx_fixed[2] = (error_pos == 3'd3) ? ~rx[2] : rx[2]; // d1
    assign rx_fixed[3] = (error_pos == 3'd4) ? ~rx[3] : rx[3]; // p3
    assign rx_fixed[4] = (error_pos == 3'd5) ? ~rx[4] : rx[4]; // d2
    assign rx_fixed[5] = (error_pos == 3'd6) ? ~rx[5] : rx[5]; // d3
    assign rx_fixed[6] = (error_pos == 3'd7) ? ~rx[6] : rx[6]; // d4

    // Extraer solo los 4 bits de datos (posiciones 3,5,6,7 → índices 2,4,5,6)
    always @(*) begin
        corrected[0] = rx_fixed[2]; // d1
        corrected[1] = rx_fixed[4]; // d2
        corrected[2] = rx_fixed[5]; // d3
        corrected[3] = rx_fixed[6]; // d4
    end

endmodule