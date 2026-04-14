// ============================================================
// Módulo SECDED: Clasificación de errores (Hamming extendido)
// EL-3307 Diseño Lógico — I Semestre 2026
// ============================================================

module secded_detector (
    input  logic [7:0] rx_ext,   // {parity_global_in, rx[6:0]}
    input  logic [2:0] syndrome, // Síndrome proveniente del detector_error
    output logic [1:0] error_type
);

    logic parity_calc;

    // Reducción XOR para calcular la paridad total de los 8 bits
    assign parity_calc = ^rx_ext;

    always_comb begin
        if (parity_calc == 1'b0 && syndrome == 3'b000)
            error_type = 2'b00; // Sin error
        else if (parity_calc == 1'b1 && syndrome != 3'b000)
            error_type = 2'b01; // Error simple (corregible)
        else if (parity_calc == 1'b0 && syndrome != 3'b000)
            error_type = 2'b10; // Doble error (detectado, no corregible)
        else
            error_type = 2'b11; // Error solo en el bit de paridad global
    end

endmodule