// ============================================================
// Módulo 7.1: Detector de error (cálculo del síndrome)
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
// Paridad del transmisor:
//   p1 cubre d4, d3, d1 → rx[6], rx[4], rx[2], rx[0]
//   p2 cubre d4, d2, d1 → rx[5], rx[4], rx[1], rx[0]
//   p4 cubre d3, d2, d1 → rx[3], rx[2], rx[1], rx[0]
//
// Paridad PAR — síndrome = 0 si no hay error
// ============================================================

module detector_error (
    input  [6:0] rx,        // palabra recibida (7 bits)
    output [2:0] error_pos  // síndrome: posición del error (1-based), 0 = sin error
);

    // s0: verifica p1 — cubre p1, d4, d3, d1 → rx[6], rx[4], rx[2], rx[0]
    assign error_pos[0] = rx[6] ^ rx[4] ^ rx[2] ^ rx[0];

    // s1: verifica p2 — cubre p2, d4, d2, d1 → rx[5], rx[4], rx[1], rx[0]
    assign error_pos[1] = rx[5] ^ rx[4] ^ rx[1] ^ rx[0];

    // s2: verifica p4 — cubre p4, d3, d2, d1 → rx[3], rx[2], rx[1], rx[0]
    assign error_pos[2] = rx[3] ^ rx[2] ^ rx[1] ^ rx[0];

endmodule