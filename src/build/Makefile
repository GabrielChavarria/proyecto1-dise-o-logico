# --- Configuración de Hardware ---
BOARD  = tangnano9k
FAMILY = GW1N-9C
DEVICE = GW1NR-LV9QN88PC6/I5

# --- Configuración de Proyecto ---
PROYECT = receptor
SOURCES := $(wildcard ../design/*.v ../design/*.sv ../design/**/*.v ../design/**/*.sv)
TESTBENCH = ../sim/receptor_top_tb.sv
CONSTRAINTS = ../constr/receptor_consolidado.cst

# --- Módulos Top ---
TOP_DESIGN = receptor_top
TOP_TB = receptor_top_tb
VCD_FILE = receptor_top_tb.vcd

# --- Flujo de Trabajo ---
all: synth pnr bitstream

synth: ${SOURCES}
	@echo [YOSYS] Sintetizando diseño...
	@yosys -p "read_verilog -sv ${SOURCES}; synth_gowin -top ${TOP_DESIGN} -json ${PROYECT}.json" > synthesis.log 2>&1 || (type synthesis.log && exit 1)
	@echo [OK] Síntesis finalizada.

pnr: ${PROYECT}.json ${CONSTRAINTS}
	@echo [NEXTPNR] Ejecutando Place and Route...
	@nextpnr-gowin --json ${PROYECT}.json --write ${PROYECT}_pnr.json --freq 27 --device ${DEVICE} --family ${FAMILY} --cst ${CONSTRAINTS} > pnr.log 2>&1 || (type pnr.log && exit 1)
	@echo [OK] PnR finalizado.

bitstream: ${PROYECT}_pnr.json
	@echo [GOWIN_PACK] Generando bitstream: ${PROYECT}_${BOARD}.fs
	@gowin_pack -d ${FAMILY} -o ${PROYECT}_${BOARD}.fs ${PROYECT}_pnr.json
	@echo [DONE] Flujo completado exitosamente.

test: ${SOURCES} ${TESTBENCH}
	@echo [IVERILOG] Compilando y ejecutando simulación...
	@iverilog -o ${PROYECT}_test.o -s ${TOP_TB} -g2005-sv ${TESTBENCH} ${SOURCES}
	@vvp ${PROYECT}_test.o
	@echo [OK] Simulación terminada.

wv: ${VCD_FILE}
	@echo [GTKWAVE] Abriendo visualizador...
	@gtkwave ${VCD_FILE}

load: ${PROYECT}_${BOARD}.fs
	@echo [OPENFPGALOADER] Cargando bitstream en ${BOARD}...
	@openFPGALoader -b ${BOARD} ${PROYECT}_${BOARD}.fs
	@echo [OK] FPGA Programada.

clean:
	@echo [CLEAN] Eliminando archivos temporales...
	@del /f /q *.json *.fs *.o *.vcd *.log 2>nul || exit 0

.PHONY: all synth pnr bitstream test wv load clean