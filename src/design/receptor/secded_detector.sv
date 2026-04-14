// Módulo SECDED (7,4) Detector de Errores
// Este módulo detecta errores en una palabra de 8 bits (7 bits de datos + 1 bit de paridad global)

// Entradas:

module secded_detector (
    input  [7:0] rx_ext,      // Word de 8 bits (Hamming 7,4 + Paridad Global)
    input  [2:0] syndrome,    // Síndrome calculado de los 7 bits
    output [1:0] error_type   // 00: No error, 01: 1 error, 10: 2 errores, 11: Paridad Error
);

    wire parity_calc;
    wire syndrome_is_zero;

    // Reducción XOR para paridad global (Ecuación de Boole)
    assign parity_calc = ^rx_ext; 

    // Verificación de síndrome (Ecuación de Boole)
    assign syndrome_is_zero = ~(syndrome[0] | syndrome[1] | syndrome[2]);

    // Lógica de salida mediante puertas lógicas (Ecuaciones de Boole)
    // Bit de mayor peso de error_type (Detección de 2 errores)
    assign error_type[1] = (~parity_calc) & (~syndrome_is_zero);

    // Bit de menor peso de error_type (Detección de 1 error)
    assign error_type[0] = (parity_calc & ~syndrome_is_zero) | (parity_calc & syndrome_is_zero);

endmodule
