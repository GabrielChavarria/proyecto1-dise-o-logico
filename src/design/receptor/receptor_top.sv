module receptor_top (
    input  [6:0] rx,      
    input        parity_global_in, 
    input        switch_selector,
    output [3:0] salida_selector, // Conectado a pines 61, 60, 59, 58
    output [6:0] seg_out,         // Conectado a pines 57-41
    output [3:0] data_out,        // LEDs: Conectado a pines 75, 74, 73, 72
    output [2:0] error_pos        // Conectado a pines 63, 40, 35
);

    wire [2:0] sindrome;
    wire [3:0] dato_corregido;
    wire [1:0] error_type;
    wire [7:0] rx_ext;

    assign rx_ext = {parity_global_in, rx};

    detector_error det (
        .rx       (rx),
        .error_pos(sindrome)
    );

    corrector_error cor (
        .rx       (rx),
        .error_pos(sindrome),
        .corrected(dato_corregido)
    );

    secded_detector secded_inst (
        .rx_ext    (rx_ext),
        .syndrome  (sindrome),
        .error_type(error_type)
    );

    reg [3:0] dato_final;
    always @(*) begin
        case (error_type)
            2'b00:   dato_final = dato_corregido; // Sin error
            2'b01:   dato_final = dato_corregido; // Error simple corregido
            2'b10:   dato_final = 4'hF;           // Error doble (Dato no confiable)
            2'b11:   dato_final = dato_corregido; // Error en paridad global
            default: dato_final = 4'hF;
        endcase
    end

    reg [3:0] sel_out;
    always @(*) begin
        case (switch_selector)
            1'b0:    sel_out = dato_final;        // Mostrar dato
            1'b1:    sel_out = {1'b0, sindrome};  // Mostrar síndrome
            default: sel_out = dato_final;
        endcase
    end

    decodificador_7seg deco (
        .bin_in (sel_out),
        .seg_out(seg_out)
    );

    assign salida_selector = sel_out;
    assign data_out        = dato_final; 
    assign error_pos       = sindrome;


endmodule