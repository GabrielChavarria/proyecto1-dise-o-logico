# Proyecto corto I – Diseño digital combinacional en dispositivos programables

## Escuela de Ingeniería Electrónica
**Curso:** EL-3307 Diseño Lógico  

**Semestre:** I Semestre 2026  

**Profesor:** Oscar Caravaca

--- 
## Integrantes
- Gabriel Alonso Chavarría Rodriguez
- Mariana Guerrero Morales
---
## Abreviaturas y definiciones
- **FPGA**: Field Programmable Gate Arrays
- **HDL**: Hardware Description Language
- **SCR**: Silicon Controlled Rectifier
- **EDA**: Electronic Design Automation
- **GPIO**: General Purpose Input/Output
---
## Herramientas Utilizadas
- **Descripción Hardawre**: SystemVerilog
- **herramientas de simulación**:
- **GTKwave**: Verificación gráfica de señales mediante simulación.
---
## Referencias
- [1] [Open Source FPGA Environment](https://github.com/FZumb4do/open_source_fpga_environment.git)
- [2] [https://wiki.sipeed.com/hardware/en/tang/Tang-Nano-9K/Nano-9K.html)
- 
---
## Objetivo
Implementar y validar un sistema receptor basado en el código Hamming (7,4) mediante lógica programable en una FPGA Tang Nano 9k, integrando módulos de detección y corrección de errores de un bit, con el fin de garantizar la integridad de la información recibida y su correcta visualización en interfaces físicas binarias y hexadecimales.

---
# Descripción General

El presente proyecto tiene como objetivo el diseño e implementación de un sistema digital basado en el código Hamming (7,4), utilizando una FPGA como plataforma de desarrollo. El sistema completo se divide en dos grandes bloques: transmisor y receptor. El transmisor se encarga de tomar una palabra de 4 bits, codificarla en una palabra de 7 bits e introducir un error controlado si así se desea. El receptor, por su parte, recibe la palabra de 7 bits, detecta si existe error, determina la posición del bit erróneo y recupera la palabra original de 4 bits.

Hasta esta etapa del desarrollo, se ha trabajado principalmente en el **subsistema receptor**, incluyendo su organización modular, la integración de sus componentes, la simulación funcional mediante testbench y la verificación del comportamiento temporal de las señales. Además, se reorganizó la estructura general del proyecto para mantener una mejor separación entre documentación, diseño, simulación y archivos de compilación.

El trabajo realizado hasta el momento constituye una base importante para continuar con las siguientes etapas del proyecto, como la visualización en LEDs, el despliegue en 7 segmentos, la integración con el transmisor y la implementación final sobre hardware.

**[Receptor con algoritmo Hamming](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki)**

---
## Estructura actual del proyecto
Se reorganizó la estructura del proyecto con el fin de separar adecuadamente la documentación, el diseño HDL, la simulación, los constraints y los archivos generados durante compilación.
```text
Proyecto_1
├── docs
│   ├── imagenes
│   └── informe
├── src
│   ├── build
│   │   ├── Makefile
│   │   ├── receptor_test.o
│   │   └── receptor_top_tb.vcd
│   ├── constr
│   │   ├── constr_Plantilla.txt
│   │   └── receptor.cst
│   ├── design
│   │   ├── receptor
│   │   │   ├── detector_error.sv
│   │   │   ├── corrector_error.sv
│   │   │   ├── receptor_top.sv
│   │   │   └── README.md
│   │   └── transmisor
│   └── sim
│       └── receptor_top_tb.sv
├── .gitignore
└── README.md
```
La estructura actual del proyecto se compone de carpetas principales como:

- `docs`, para documentación e imágenes,
- `src/build`, para compilación y archivos generados,
- `src/constr`, para constraints,
- `src/design`, para módulos del transmisor y receptor,
- `src/sim`, para archivos de simulación.

Esta organización permite mantener un flujo de trabajo más ordenado, facilita la localización de archivos y mejora la comprensión general del proyecto.

---
## Jerarquía del Subsistema Receptor
- [Módulo 7.1.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.1.-M%C3%B3dulo-decodificador-de-paridad-sobre-la-palabra-recibida) -Módulo detector de error sobre palabra recibida
- [Módulo 7.2.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.2.-M%C3%B3dulo-de-correcci%C3%B3n-de-error-sobre-la-palabra-recibida) -Corrección de error sobre la palabra recibida
- [Módulo 7.3.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.3-M%C3%B3dulo-de-despliegue-de-palabra-corregida-en-formato-binario-en-luces-LED) - Despliegue de palabra corregida en formato binario en luces LED 
- [Módulo 7.4.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.4-M%C3%B3dulo-de-despliegue-de-palabra-corregida-en-display-de-7-segmentos) - Despliegue de palabra corregida en display de 7SEG
- [Módulo 7.5.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.5-Selector) - Selector
- [Módulo 7.8.](https://github.com/GabrielChavarria/proyecto1-dise-o-logico/wiki/7.8-Selector) -Oscilador de Anillo y Medición de Retardos
---

