// Módulo 7.1: Detector de error (cálculo del síndrome)
// Convención: paridad PAR, distribución estándar Hamming(7,4)
// Posiciones 1-based: p1=1, p2=2, d1=3, p3=4, d2=5, d3=6, d4=7
// Índices   0-based: rx[0]..rx[6]
module detector_error (
    input  [6:0] rx,        // palabra recibida (7 bits)
    output [2:0] error_pos  // síndrome: posición del error (1-based), 0 = sin error
);

    // s0 cubre posiciones 1,3,5,7 → índices 0,2,4,6
    assign error_pos[0] = rx[0] ^ rx[2] ^ rx[4] ^ rx[6];

    // s1 cubre posiciones 2,3,6,7 → índices 1,2,5,6
    assign error_pos[1] = rx[1] ^ rx[2] ^ rx[5] ^ rx[6];

    // s2 cubre posiciones 4,5,6,7 → índices 3,4,5,6
    assign error_pos[2] = rx[3] ^ rx[4] ^ rx[5] ^ rx[6];

endmodule