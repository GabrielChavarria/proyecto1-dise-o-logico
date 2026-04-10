// Sección 7.5: Integración con Selector Externo 
// Este módulo define los cables que van a la protoboard y regresan a la FPGA

module selector_top (
    input  logic [6:0] datos_con_error,   // Los 7 bits del DIP Switch
    
    // Salidas hacia el chip -Cables que salen de la FPGA
    output logic [3:0] hacia_selector_A,  // Palabra ya corregida
    output logic [2:0] hacia_selector_B,  // Posición del error 
    
    // Entrada desde el chip - Lo que regresa a la FPGA
    input  logic  switch_selector,
    
    // Salida final al display físico
    output logic [6:0] seg_out
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
    case (switch_selector)
    

        : 
        default: 
    endcase
    assign hacia_selector_A = dato_corregido; // Enviamos el dato corregido al selector
    assign hacia_selector_B = sindrome; // Enviamos el síndrome para que el selector sepa dónde está el error

    //--- 4. Mapeo para el display ---
    // Aquí se mapea el dato corregido a un formato que el display pueda mostrar

