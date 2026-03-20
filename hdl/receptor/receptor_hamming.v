// Módulo principal del receptor Hamming (7,4)
module receptor_hamming (

    input  [6:0] rx,        // Entrada de 7 bits recibidos (puede tener error)
    output [2:0] error_pos, // Posición del error detectado (síndrome)
    output [3:0] data_out,  // Datos originales corregidos (4 bits)
    output [3:0] leds       // Salida para visualizar en LEDs

);

    // ------------------------------
    // CÁLCULO DEL SÍNDROME (detección de error)
    // ------------------------------

    // Cada bit del síndrome se calcula con XOR (paridad)
    // Esto permite detectar si hay error en ciertas posiciones

    assign error_pos[0] = rx[0] ^ rx[2] ^ rx[4] ^ rx[6];
    assign error_pos[1] = rx[1] ^ rx[2] ^ rx[5] ^ rx[6];
    assign error_pos[2] = rx[3] ^ rx[4] ^ rx[5] ^ rx[6];

    // Si error_pos = 000 → no hay error
    // Si no → indica la posición del bit incorrecto

    // ------------------------------
    // CORRECCIÓN DEL ERROR
    // ------------------------------

    reg [6:0] corrected;  // Registro donde guardamos los bits corregidos

    always @(*) begin
        corrected = rx;   // Copiamos los datos recibidos

        // Si hay error (síndrome diferente de 0)
        if (error_pos != 3'b000) begin

            // Se corrige el bit erróneo invirtiéndolo (NOT)
            // error_pos indica la posición (1 a 7)
            corrected[error_pos - 1] = ~rx[error_pos - 1];
        end
    end

    // ------------------------------
    // EXTRACCIÓN DE LOS DATOS ORIGINALES
    // ------------------------------

    // En Hamming (7,4), los datos están en posiciones específicas

    assign data_out[0] = corrected[2]; // bit de datos 1
    assign data_out[1] = corrected[4]; // bit de datos 2
    assign data_out[2] = corrected[5]; // bit de datos 3
    assign data_out[3] = corrected[6]; // bit de datos 4

    // ------------------------------
    // SALIDA A LEDS (visualización)
    // ------------------------------

    assign leds = data_out; // mostramos los datos corregidos en LEDs

endmodule