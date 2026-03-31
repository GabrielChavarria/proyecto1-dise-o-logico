# Código HDL del receptor

Esta carpeta contiene los módulos SystemVerilog que implementan el
receptor del sistema de corrección de errores basado en Hamming (7,4).

El receptor recibe la palabra de 7 bits enviada por el transmisor y
realiza las siguientes funciones:

- Decodificación de paridad
- Detección del bit con error
- Corrección del error detectado
- Recuperación de la palabra original de 4 bits

Además, los datos corregidos se envían a los módulos de visualización
para ser mostrados en LEDs y en un display de 7 segmentos.
