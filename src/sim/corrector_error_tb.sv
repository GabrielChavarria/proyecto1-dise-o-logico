// ============================================================
// Testbench: corrector_error_tb.sv
// EL-3307 Diseño Lógico — I Semestre 2026
// Herramienta: iVerilog + GTKWave
// ============================================================
// Tabla de síndromes real del transmisor:
//   000 → sin error
//   111 → error en rx[0]=d1
//   110 → error en rx[1]=d2
//   101 → error en rx[2]=d3
//   100 → error en rx[3]=p4
//   011 → error en rx[4]=d4
//   010 → error en rx[5]=p2
//   001 → error en rx[6]=p1
// ============================================================

`timescale 1ns/1ps

module corrector_error_tb;

    reg  [6:0] rx;
    reg  [2:0] error_pos;
    wire [3:0] corrected;

    corrector_error DUT (
        .rx       (rx),
        .error_pos(error_pos),
        .corrected(corrected)
    );

    task verificar;
        input [6:0]  entrada;
        input [2:0]  pos;
        input [3:0]  dato_esperado;
        input [31:0] num_caso;
        begin
            rx        = entrada;
            error_pos = pos;
            #10;
            $write("[CASO %0d] rx=%b pos=%b | corrected=%b | esperado=%b | ",
                    num_caso, entrada, pos, corrected, dato_esperado);
            if (corrected === dato_esperado)
                $display("OK");
            else
                $display("ERROR <<<");
        end
    endtask

    // ----------------------------------------------------------
    // Palabra base: datos=1011, rx=7'b0110011
    //   rx[0]=d1=1, rx[1]=d2=1, rx[2]=d3=0
    //   rx[3]=p4=0, rx[4]=d4=1, rx[5]=p2=1, rx[6]=p1=0
    // corrected esperado = {d4,d3,d2,d1} = 4'b1011
    // ----------------------------------------------------------
    initial begin

        $dumpfile("corrector_error_tb.vcd");
        $dumpvars(0, corrector_error_tb);

        $display("============================================");
        $display("  TESTBENCH: corrector_error");
        $display("  datos base = 1011");
        $display("  rx correcto = 7'b0110011");
        $display("============================================");

        // sin error
        verificar(7'b0110011, 3'b000, 4'b1011, 1);

        // error en rx[0]=d1 → síndrome=111
        verificar(7'b0110010, 3'b111, 4'b1011, 2);

        // error en rx[1]=d2 → síndrome=110
        verificar(7'b0110001, 3'b110, 4'b1011, 3);

        // error en rx[2]=d3 → síndrome=101
        verificar(7'b0110111, 3'b101, 4'b1011, 4);

        // error en rx[3]=p4 → síndrome=100 (datos sin cambio)
        verificar(7'b0111011, 3'b100, 4'b1011, 5);

        // error en rx[4]=d4 → síndrome=011
        verificar(7'b0100011, 3'b011, 4'b1011, 6);

        // error en rx[5]=p2 → síndrome=010 (datos sin cambio)
        verificar(7'b0010011, 3'b010, 4'b1011, 7);

        // error en rx[6]=p1 → síndrome=001 (datos sin cambio)
        verificar(7'b1110011, 3'b001, 4'b1011, 8);

        // ----------------------------------------------------------
        // Palabra: datos=0000, rx=7'b0000000
        // ----------------------------------------------------------
        $display("\n  datos base = 0000");
        $display("  rx correcto = 7'b0000000");
        $display("--------------------------------------------");

        verificar(7'b0000000, 3'b000, 4'b0000, 9);
        verificar(7'b0000001, 3'b111, 4'b0000, 10); // rx[0]=d1
        verificar(7'b0000010, 3'b110, 4'b0000, 11); // rx[1]=d2
        verificar(7'b0000100, 3'b101, 4'b0000, 12); // rx[2]=d3
        verificar(7'b0001000, 3'b100, 4'b0000, 13); // rx[3]=p4
        verificar(7'b0010000, 3'b011, 4'b0000, 14); // rx[4]=d4
        verificar(7'b0100000, 3'b010, 4'b0000, 15); // rx[5]=p2
        verificar(7'b1000000, 3'b001, 4'b0000, 16); // rx[6]=p1

        // ----------------------------------------------------------
        // Palabra: datos=1111, rx=7'b1111111
        // ----------------------------------------------------------
        $display("\n  datos base = 1111");
        $display("  rx correcto = 7'b1111111");
        $display("--------------------------------------------");

        verificar(7'b1111111, 3'b000, 4'b1111, 17);
        verificar(7'b1111110, 3'b111, 4'b1111, 18); // rx[0]=d1
        verificar(7'b1111101, 3'b110, 4'b1111, 19); // rx[1]=d2
        verificar(7'b1111011, 3'b101, 4'b1111, 20); // rx[2]=d3
        verificar(7'b1110111, 3'b100, 4'b1111, 21); // rx[3]=p4
        verificar(7'b1101111, 3'b011, 4'b1111, 22); // rx[4]=d4
        verificar(7'b1011111, 3'b010, 4'b1111, 23); // rx[5]=p2
        verificar(7'b0111111, 3'b001, 4'b1111, 24); // rx[6]=p1

        $display("============================================");
        $display("  SIMULACION COMPLETADA");
        $display("============================================");

        $finish;
    end

endmodule