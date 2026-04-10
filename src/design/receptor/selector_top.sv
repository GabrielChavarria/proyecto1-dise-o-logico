// Sección 7.5: Integración con Selector Externo 
// Este módulo define los cables que van a la protoboard y regresan a la FPGA

module selector_top (
    
    //Entrada desde el transmisor - Cables que llegan a la FPGA
    input  logic [6:0] datos_con_error,   // Bits de transferencia del Transmisor
    input  logic  switch_selector, // Switch para seleccionar entre enviar el dato corregido o el síndrome al selector externo
    
    // Salidas hacia el chip -Cables que salen de la FPGA
    output logic [3:0] salida_selector,  // Palabra corregida o el síndrome, dependiendo del switch
    output logic [6:0] seg_out,
    output logic [3:0] led_out
);

    logic [2:0] sindrome;
    logic [3:0] dato_corregido;

    //--- 1. Condiciones de paridad --- 
    // Acá se detecta donde se encuentra el error, si es que hay alguno
    assign sindrome[0] = datos_con_error[0] ^ datos_con_error[2] ^ datos_con_error[4] ^ datos_con_error[6]; // P1
    assign sindrome[1] = datos_con_error[1] ^ datos_con_error[2] ^ datos_con_error[5] ^ datos_con_error[6]; // P2
    assign sindrome[2] = datos_con_error[3] ^ datos_con_error[4] ^ datos_con_error[5] ^ datos_con_error[6]; // P3

    //--- 2. Correcctor del dato ---
    // Aquí se corrige el dato basado en el síndrome
    assign dato_corregido[0] = datos_con_error[0] ^ sindrome[0]; // D1
    assign dato_corregido[1] = datos_con_error[1] ^ sindrome[1]; // D2
    assign dato_corregido[2] = datos_con_error[2] ^ sindrome[0] ^ sindrome[1]; // D3
    assign dato_corregido[3] = datos_con_error[3] ^ sindrome[2]; // D4

    //--- 3. Salidas hacia el selector externo ---
    always @(*) begin

    case (switch_selector)

        1'b0: salida_selector = dato_corregido; // Si el switch está en 0, enviamos el dato corregido
        1'b1: salida_selector = sindrome; // Si el switch está en 1, enviamos el síndrome para que el selector sepa dónde está el error
        default: salida_selector = 4'b0000; // En caso de que el switch tenga un valor no definido, enviamos el dato corregido
        
    endcase
    end
    
    //--- 4. Mapeo para el display ---
    // Aquí se mapea el dato corregido a un formato que el display pueda mostrar

    

