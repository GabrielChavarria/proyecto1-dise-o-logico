// Sección 7.4: Decodificador Hexadecimal a 7 Segmentos

module decodificador_7seg (
    input  logic [3:0] bin_in,    // Dato de 4 bits a mostrar
    output logic [6:0] seg_out    // Salidas: {g, f, e, d, c, b, a} — activo en ALTO
);

    always_comb begin
        case (bin_in)
            4'h0: seg_out = 7'b0000000; // 0
            4'h1: seg_out = 7'b0000001; // 1
            4'h2: seg_out = 7'b0000010; // 2
            4'h3: seg_out = 7'b0000011; // 3
            4'h4: seg_out = 7'b0000100; // 4 
            4'h5: seg_out = 7'b0000101; // 5
            4'h6: seg_out = 7'b0000110; // 6
            4'h7: seg_out = 7'b0000111; // 7
            4'h8: seg_out = 7'b0001000; // 8
            4'h9: seg_out = 7'b0001001; // 9
            4'hA: seg_out = 7'b0001010; // A
            4'hB: seg_out = 7'b0001011; // B
            4'hC: seg_out = 7'b0001100; // C
            4'hD: seg_out = 7'b0001101; // D
            4'hE: seg_out = 7'b0001110; // E
            4'hF: seg_out = 7'b0001111; // F
            default: seg_out = 7'b0000000; // Mostrar 0 por defecto
        endcase
    end

endmodule
