// Módulo 7.2: Corrector de error

module corrector_error (
    input  logic [6:0] rx,          // datos recibidos (con posible error)
    input  logic [2:0] error_pos,   // posición del error (1–7), 0 = sin error
    output logic [3:0] corrected    // 4 bits de datos corregidos
);

    logic [6:0] rx_fixed;

    always_comb begin
        // 1. Copiar la palabra recibida
        rx_fixed = rx;

        // 2. Si hay error, invertir el bit en la posición indicada
        //    error_pos es base-1 (posición Hamming), rx_fixed es base-0
        if (error_pos != 3'b000)
            rx_fixed[error_pos - 1] = ~rx[error_pos - 1];

        // 3. Extraer los 4 bits de datos del formato Hamming(7,4):
        corrected[0] = rx_fixed[2]; // D1 (posición Hamming 3)
        corrected[1] = rx_fixed[4]; // D2 (posición Hamming 5)
        corrected[2] = rx_fixed[5]; // D3 (posición Hamming 6)
        corrected[3] = rx_fixed[6]; // D4 (posición Hamming 7)
    end

endmodule
