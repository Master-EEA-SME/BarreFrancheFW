CC=ghdl
FLAGS=

all: compass edge_detector pulse pwm spi_master mcp3201 verin anemometre

compass:
	$(CC) $(FLAGS) -a src/compass/compass.vhd

edge_detector:
	$(CC) $(FLAGS) -a src/utils/EdgeDetector.vhd

pulse:
	$(CC) $(FLAGS) -a src/utils/Pulse.vhd

pwm:
	$(CC) $(FLAGS) -a src/utils/Pwm.vhd

spi_master:
	$(CC) $(FLAGS) -a src/utils/SpiMaster.vhd

mcp3201: spi_master
	$(CC) $(FLAGS) -a src/verin/mcp3201.vhd

verin: pwm spi_master mcp3201
	$(CC) $(FLAGS) -a src/verin/verin.vhd

anemometre: edge_detector
	$(CC) $(FLAGS) -a src/anemometre/anemometre.vhd

clean:
	$(CC) --clean
