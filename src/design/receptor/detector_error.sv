// Módulo 7.1: Detector de error (cálculo del síndrome)
module detector_error (
    input [6:0] rx,        // datos recibidos
    output [2:0] error_pos // posición del error
);

    // cálculo del síndrome usando XOR
    assign error_pos[0] = rx[0] ^ rx[2] ^ rx[4] ^ rx[6];
    assign error_pos[1] = rx[1] ^ rx[2] ^ rx[5] ^ rx[6];
    assign error_pos[2] = rx[3] ^ rx[4] ^ rx[5] ^ rx[6];

endmodule