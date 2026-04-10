// Módulo SECDED: detecta doble error y clasifica
module secded_detector (

    input  [7:0] rx_ext,      // 7 bits Hamming + 1 bit de paridad
    input  [2:0] syndrome,    // del detector
    output reg [1:0] error_type

);

    wire parity_calc;

    // XOR de todos los bits
    assign parity_calc = rx_ext[0] ^ rx_ext[1] ^ rx_ext[2] ^
                         rx_ext[3] ^ rx_ext[4] ^ rx_ext[5] ^
                         rx_ext[6] ^ rx_ext[7];

    always @(*) begin

        if (syndrome == 3'b000 && parity_calc == 0)
            error_type = 2'b00; // sin error

        else if (syndrome != 3'b000 && parity_calc == 1)
            error_type = 2'b01; // 1 error

        else if (syndrome != 3'b000 && parity_calc == 0)
            error_type = 2'b10; // 2 errores

        else
            error_type = 2'b11; // error en bit de paridad

    end

endmodule