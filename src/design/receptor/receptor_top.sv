// Módulo TOP: integra 7.1 (detector) y 7.2 (corrector)

module receptor_top (
    input  logic [6:0] rx,        // datos recibidos
    output logic [2:0] error_pos, // posición del error (hacia el selector externo)
    output logic [3:0] corrected  // datos corregidos (hacia LEDs y selector)
);

    // ------------------------------
    // Módulo 7.1: Detector de error
    // ------------------------------
    detector_error det (
        .rx       (rx),
        .error_pos(error_pos)  // conectado directo a la salida del TOP
    );

    // ------------------------------
    // Módulo 7.2: Corrector de error
    // ------------------------------
    corrector_error cor (
        .rx       (rx),
        .error_pos(error_pos),
        .corrected(corrected)
    );

endmodule
