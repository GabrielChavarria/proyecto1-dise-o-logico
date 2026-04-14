`timescale 1ns / 1ps

module receptor_top_tb();
    reg [6:0] rx;
    reg parity_global_in;
    reg switch_selector;
    wire [3:0] salida_selector;
    wire [6:0] seg_out;
    wire [3:0] data_out;
    wire [2:0] error_pos;

    receptor_top uut (
        .rx(rx),
        .parity_global_in(parity_global_in),
        .switch_selector(switch_selector),
        .salida_selector(salida_selector),
        .seg_out(seg_out),
        .data_out(data_out),
        .error_pos(error_pos)
    );

    initial begin
        // Caso 1: Dato correcto (Dato=1010 -> rx=1100110 según tu tabla)
        // d1=0, d2=1, d3=0, d4=1. Paridades: p1=1, p2=1, p4=0
        rx = 7'b1100110; parity_global_in = 0; switch_selector = 0;
        #10;
        
        // Caso 2: Error simple en d1 (rx[0])
        rx = 7'b1100111; #10;
        
        // Caso 3: Error doble (rx[0] y rx[1])
        rx = 7'b1100101; #10;
        
        $finish;
    end
endmodule