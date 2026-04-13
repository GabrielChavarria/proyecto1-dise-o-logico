// ============================================================
// Testbench: decodificador_7seg_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Verifica los 16 valores hexadecimales (0-F)
// Segmentos activos en ALTO
// Orden: seg_out = {g, f, e, d, c, b, a}
// ============================================================

`timescale 1ns/1ps

module decodificador_7seg_tb;

    // ----------------------------------------------------------
    // Señales del DUT — sin logic, compatible con iVerilog
    // ----------------------------------------------------------
    reg  [3:0] bin_in;
    wire [6:0] seg_out;

    // ----------------------------------------------------------
    // Instancia del DUT
    // ----------------------------------------------------------
    decodificador_7seg DUT (
        .bin_in (bin_in),
        .seg_out(seg_out)
    );

    // ----------------------------------------------------------
    // Tarea de verificación
    // ----------------------------------------------------------
    task verificar;
        input [3:0] entrada;
        input [6:0] seg_esperado;
        begin
            bin_in = entrada;
            #10;
            $write("[%H] bin_in=%b | seg_out=%b | esperado=%b | ",
                    entrada, entrada, seg_out, seg_esperado);
            if (seg_out === seg_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ----------------------------------------------------------
    // Estímulos — los 16 valores hexadecimales
    // Formato seg_out: {g, f, e, d, c, b, a}
    // ----------------------------------------------------------
    initial begin

        $dumpfile("decodificador_7seg_tb.vcd");
        $dumpvars(0, decodificador_7seg_tb);

        $display("============================================");
        $display("  TESTBENCH: decodificador_7seg");
        $display("  seg_out = {g,f,e,d,c,b,a} activo ALTO");
        $display("============================================");

        verificar(4'h0, 7'b0111111); // 0
        verificar(4'h1, 7'b0000110); // 1
        verificar(4'h2, 7'b1011011); // 2
        verificar(4'h3, 7'b1001111); // 3
        verificar(4'h4, 7'b1100110); // 4
        verificar(4'h5, 7'b1101101); // 5
        verificar(4'h6, 7'b1111101); // 6
        verificar(4'h7, 7'b0000111); // 7
        verificar(4'h8, 7'b1111111); // 8
        verificar(4'h9, 7'b1101111); // 9
        verificar(4'hA, 7'b1110111); // A
        verificar(4'hB, 7'b1111100); // B
        verificar(4'hC, 7'b0111001); // C
        verificar(4'hD, 7'b1011110); // D
        verificar(4'hE, 7'b1111001); // E
        verificar(4'hF, 7'b1110001); // F

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule