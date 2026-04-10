module receptor_top (

    input  [6:0] rx,        // datos recibidos
    output [2:0] error_pos, // posición del error detectado
    output [3:0] corrected  // datos finales (controlados por SECDED)

);

    // ------------------------------
    // Señales internas
    // ------------------------------
    wire [2:0] error_pos_wire;
    wire [3:0] corrected_wire;

    // SECDED
    wire [1:0] error_type;
    wire [7:0] rx_ext;
    wire parity_global;

    // ------------------------------
    // Paridad global (SECDED)
    // ------------------------------
    assign parity_global = rx[0] ^ rx[1] ^ rx[2] ^
                           rx[3] ^ rx[4] ^ rx[5] ^ rx[6];

    assign rx_ext = {parity_global, rx};

    // ------------------------------
    // Módulo 7.1: Detector
    // ------------------------------
    detector_error det (
        .rx(rx),
        .error_pos(error_pos_wire)
    );

    // ------------------------------
    // Módulo 7.2: Corrector
    // ------------------------------
    corrector_error cor (
        .rx(rx),
        .error_pos(error_pos_wire),
        .corrected(corrected_wire)
    );

    // ------------------------------
    // Módulo SECDED
    // ------------------------------
    secded_detector secded (
        .rx_ext(rx_ext),
        .syndrome(error_pos_wire,
        .error_type(error_type)
    );

    // ------------------------------
    // Lógica final (CLAVE)
    // ------------------------------
    reg [3:0] final_data;

    always @(*) begin
        case (error_type)
            2'b00: final_data = rx[3:0];          // sin error
            2'b01: final_data = corrected_wire;  // 1 error corregido
            2'b10: final_data = 4'b1111;         // doble error (no confiable)
            default: final_data = 4'b1111;
        endcase
    end

    // salida final
    assign corrected = final_data;
    assign error_pos = error_pos_wire;

endmodule