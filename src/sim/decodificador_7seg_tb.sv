`timescale 1ns/1ps

module decodificador_7seg_tb;
    logic [3:0] bin_in;
    logic [6:0] seg_out;

    // Instancia del módulo
    decodificador_7seg uut (.*);

    initial begin
        $dumpfile("decodificador_7seg_tb.vcd");
        $dumpvars(0, decodificador_7seg_tb);

        $display("Tiempo | Bin | Seg_out (gfedcba)");
        $display("-------------------------------");

        // Prueba: 0, 5, A, F
        bin_in = 4'h0; #10;
        $display("%t |  %h  | %b", $time, bin_in, seg_out);
        
        bin_in = 4'h5; #10;
        $display("%t |  %h  | %b", $time, bin_in, seg_out);
        
        bin_in = 4'hA; #10;
        $display("%t |  %h  | %b", $time, bin_in, seg_out);
        
        bin_in = 4'hF; #10;
        $display("%t |  %h  | %b", $time, bin_in, seg_out);

        #10 $finish;
    end
endmodule