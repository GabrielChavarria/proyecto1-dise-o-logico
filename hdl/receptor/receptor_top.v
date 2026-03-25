// Módulo TOP: integra 7.1 (detector) y 7.2 (corrector)
module receptor_top (

    input  [6:0] rx,        // datos recibidos
    output [2:0] error_pos, // posición del error detectado
    output [6:0] corrected  // datos corregidos

);

    // señal interna para conectar módulos
    wire [2:0] error_pos_wire;

    // ------------------------------
    // Módulo 7.1: Detector de error
    // ------------------------------
    detector_error det (
        .rx(rx),
        .error_pos(error_pos_wire)
    );

    // ------------------------------
    // Módulo 7.2: Corrector de error
    // ------------------------------
    corrector_error cor (
        .rx(rx),
        .error_pos(error_pos_wire),
        .corrected(corrected)
    );

    // salida del sistema
    assign error_pos = error_pos_wire;

endmodule