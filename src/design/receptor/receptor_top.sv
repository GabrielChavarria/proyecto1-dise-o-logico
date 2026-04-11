module receptor_top (
    input  [6:0] rx,        // palabra recibida del transmisor (7 bits)
    output [2:0] error_pos, // posición del error (1-based, 0 = sin error)
    output [3:0] data_out   // ← renombrado para coincidir con el .cst
);

    // ------------------------------
    // Señales internas
    // ------------------------------
    wire [2:0] error_pos_wire;
    wire [3:0] corrected_wire;
    wire [1:0] error_type;

    // ------------------------------
    // Paridad global (Opción B)
    // Se calcula localmente con los 7 bits recibidos
    // ------------------------------
    wire parity_global;
    assign parity_global = rx[0] ^ rx[1] ^ rx[2] ^ rx[3] ^
                           rx[4] ^ rx[5] ^ rx[6];

    wire [7:0] rx_ext;
    assign rx_ext = {parity_global, rx};  // p0 calculado localmente

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
        .syndrome(error_pos_wire),
        .error_type(error_type)
    );

    // ------------------------------
    // Lógica final
    // ------------------------------
    reg [3:0] final_data;

    always @(*) begin
        case (error_type)
            2'b00: final_data = corrected_wire; // sin error, datos limpios
            2'b01: final_data = corrected_wire; // 1 error corregido
            2'b10: final_data = 4'b1111;        // doble error, dato no confiable
            2'b11: final_data = corrected_wire; // error solo en p0, datos ok
            default: final_data = 4'b1111;
        endcase
    end

    // ------------------------------
    // Salidas
    // ------------------------------
    assign data_out  = final_data;
    assign error_pos = error_pos_wire;

endmodule