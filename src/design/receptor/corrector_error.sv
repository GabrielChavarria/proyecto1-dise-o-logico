// Módulo 7.2: Corrector de error
module corrector_error (
    input [6:0] rx,          // datos recibidos
    input [2:0] error_pos,   // posición del error detectado
    output reg [3:0] corrected // datos corregidos
);

    always @(*) begin
        corrected = rx; // copiar datos

        // si hay error, corregir
        if (error_pos != 3'b000) begin
            corrected[error_pos - 1] = ~rx[error_pos - 1];
        end
    end

endmodule
