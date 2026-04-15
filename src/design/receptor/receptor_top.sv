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

    // Lógica condicional para mostrar el dato corregido o la posición del error
    always_comb begin
        if (switch_selector == 1'b0) begin
            // Mostrar dato corregido
            leds_out = corrected_data[3:0];  // Los LEDs mostrarán los 4 bits corregidos
            seg_out = corrected_data[6:0];   // El display de 7 segmentos muestra el dato corregido
        end else begin
            // Mostrar posición del error
            leds_out = error_pos;            // Los LEDs mostrarán la posición del error (3 bits)
            seg_out = {4'b0000, error_pos};  // El display de 7 segmentos muestra la posición del error
        end
    end

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
// MODULO 6.2: Display de 7 segmentos
// ============================================================

module bin_to_7seg (
    input  logic [3:0] sw,
    output logic [6:0] segments
);

    logic AIN, BIN, CIN, DIN;
    logic AIN_N, BIN_N, CIN_N, DIN_N;
    logic SA, SB, SC, SD, SE, SF, SG;

    assign AIN = sw[3];
    assign BIN = sw[2];
    assign CIN = sw[1];
    assign DIN = sw[0];

    assign AIN_N = ~AIN;
    assign BIN_N = ~BIN;
    assign CIN_N = ~CIN;
    assign DIN_N = ~DIN;

    assign SA = (DIN_N & (AIN | BIN_N)) | 
                (AIN_N & (CIN | (BIN & DIN))) | 
                (BIN & CIN) | 
                (AIN & BIN_N & CIN_N);

    assign SB = (BIN_N & (AIN_N | DIN_N)) | 
                (AIN_N & (~(CIN ^ DIN))) | 
                (AIN & DIN & CIN_N);

    assign SC = (AIN & BIN_N) | 
                (AIN_N & (BIN | DIN | CIN_N)) | 
                (DIN & CIN_N);

    assign SD = (DIN_N & ((AIN_N & BIN_N) | (BIN & CIN) | (AIN & CIN_N))) | 
                (DIN & ((BIN & CIN_N) | (BIN_N & CIN)));

    assign SE = (DIN_N & (BIN_N | CIN)) | 
                (AIN & (CIN | BIN));

    assign SF = (AIN & (CIN | BIN_N)) | 
                (DIN_N & (BIN | CIN_N)) | 
                (AIN_N & BIN & CIN_N);

    assign SG = (AIN & (DIN | BIN_N)) | 
                (CIN & (BIN_N | DIN_N)) | 
                (AIN_N & BIN & CIN_N);

    assign segments[0] = SA;
    assign segments[1] = SB;
    assign segments[2] = SC;
    assign segments[3] = SD;
    assign segments[4] = SE;
    assign segments[5] = SF;
    assign segments[6] = SG;

endmodule