// ============================================================
// MODULO PRINCIPAL: Receptor con Decodificador Hamming(7,4)
// ============================================================

module receptor_top (
    input  logic [6:0] rx,               // Palabra Hamming recibida con posibles errores
    input  logic       switch_selector,   // 0=dato corregido, 1=síndrome (posición del error)
    output logic [3:0] leds_out,          // LEDs → dato corregido o posición del error
    output logic [6:0] seg_out            // Display 7 segmentos → dato corregido o posición del error
);

    logic [2:0] error_pos;      // Posición del error detectado
    logic [6:0] corrected_data; // Datos corregidos

    // Decodificador Hamming (Detector de error y corrección)
    hamming74_decoder U1 (
        .rx(rx),
        .error_pos(error_pos),
        .corrected_data(corrected_data)
    );

    // Instanciación del módulo bin_to_7seg_converter
    logic [3:0] display_data;  // Datos que se mostrarán en el display de 7 segmentos
    
    always_comb begin
        if (switch_selector == 1'b0) begin
            // Mostrar dato corregido
            leds_out = corrected_data[3:0];  // Los LEDs mostrarán los 4 bits corregidos
            display_data = corrected_data[3:0];  // Pasamos los 4 bits corregidos para mostrar en 7 segmentos
        end else begin
            // Mostrar posición del error
            leds_out = error_pos;            // Los LEDs mostrarán la posición del error (3 bits)
            display_data = error_pos;        // Pasamos la posición del error para mostrar en 7 segmentos
        end
    end

    // Instanciar el convertidor a 7 segmentos
    bin_to_7seg_converter U2 (
        .data_in(display_data),  // Entrada: los datos que se quieren mostrar
        .segments(seg_out)       // Salida: el valor de los segmentos del display
    );

endmodule

// ============================================================
// MODULO 6.1: Decodificador Hamming(7,4) y corrección de errores
// ============================================================

module hamming74_decoder (
    input  logic [6:0] rx,              // Palabra Hamming recibida
    output logic [2:0] error_pos,       // Posición del error detectado (si existe)
    output logic [6:0] corrected_data   // Datos corregidos
);

    logic [3:0] d;   // Datos de salida
    logic p1, p2, p4; // Paridad calculada

    // Calculamos la paridad según los bits recibidos
    always_comb begin
        // Cálculo de paridad
        p1 = rx[6] ^ rx[5] ^ rx[4] ^ rx[2] ^ rx[1] ^ rx[0]; // Paridad p1
        p2 = rx[6] ^ rx[5] ^ rx[3] ^ rx[2] ^ rx[1] ^ rx[0]; // Paridad p2
        p4 = rx[6] ^ rx[4] ^ rx[3] ^ rx[2] ^ rx[1] ^ rx[0]; // Paridad p4

        // Detección de error basado en el síndrome
        error_pos = {p4, p2, p1}; // Síndrome de error (compara con 0)

        // Corregir los datos si hay error
        if (error_pos != 3'b000) begin
            // Se detecta un error en la posición indicada por el síndrome
            corrected_data = rx ^ (1 << (error_pos - 1)); // Corregir el bit erróneo
        end else begin
            // Si no hay error, los datos son correctos
            corrected_data = rx;
        end
    end
endmodule

// ============================================================
// MODULO 6.2: Conversor binario a 7 segmentos (para datos corregidos y posición del error)
// ============================================================

module bin_to_7seg_converter (
    input  logic [3:0] data_in,        // Entrada de 4 bits (datos corregidos o posición de error)
    output logic [6:0] segments        // Salida para el display de 7 segmentos
);

    always_comb begin
        case (data_in)
            4'b0000: segments = 7'b0111111; // 0
            4'b0001: segments = 7'b0000110; // 1
            4'b0010: segments = 7'b1011011; // 2
            4'b0011: segments = 7'b1001111; // 3
            4'b0100: segments = 7'b1100110; // 4
            4'b0101: segments = 7'b1101101; // 5
            4'b0110: segments = 7'b1111101; // 6
            4'b0111: segments = 7'b0000111; // 7
            4'b1000: segments = 7'b1111111; // 8
            4'b1001: segments = 7'b1101111; // 9
            4'b1010: segments = 7'b1110111; // A
            4'b1011: segments = 7'b1111100; // B
            4'b1100: segments = 7'b0111001; // C
            4'b1101: segments = 7'b1011110; // D
            4'b1110: segments = 7'b1111001; // E
            4'b1111: segments = 7'b1110001; // F
            default: segments = 7'b0000000; // Apagar
        endcase
    end
endmodule