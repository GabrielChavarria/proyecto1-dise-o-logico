# Código HDL del transmisor

Esta carpeta contiene los módulos SystemVerilog correspondientes al
transmisor del sistema de comunicación con corrección de errores.

El transmisor tiene como función generar la palabra codificada que será
enviada al receptor.

Los módulos incluidos en esta sección implementan:

- Codificador Hamming (7,4)
- Generación de bits de paridad
- Módulo de visualización de la palabra de entrada
- Módulo generador de error

Estos módulos reciben una palabra de datos de 4 bits ingresada por el
usuario mediante interruptores y generan una palabra codificada de
7 bits que puede incluir un error intencional para su posterior
detección y corrección.
