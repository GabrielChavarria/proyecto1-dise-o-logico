module secded_tb;

    reg [7:0] rx_ext;
    reg [2:0] syndrome;
    wire [1:0] error_type;

    secded_checker uut (
        .rx_ext(rx_ext),
        .syndrome(syndrome),
        .error_type(error_type)
    );

    initial begin

        $display("rx_ext | syndrome | error_type");
        $monitor("%b | %b | %b", rx_ext, syndrome, error_type);

        // Caso 1: sin error
        rx_ext = 8'b10101010;
        syndrome = 3'b000;
        #10;

        // Caso 2: 1 error
        rx_ext = 8'b10101011;
        syndrome = 3'b001;
        #10;

        // Caso 3: 2 errores
        rx_ext = 8'b10101111;
        syndrome = 3'b010;
        #10;

        // Caso 4: error en bit de paridad
        rx_ext = 8'b10101011;
        syndrome = 3'b000;
        #10;

        $finish;

    end

endmodule