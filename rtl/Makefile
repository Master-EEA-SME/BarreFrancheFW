CC=ghdl
FLAGS=

all: compass pwm verin anemometre boutons

all_tb: tb_anemometre tb_boutons tb_compass tb_mcp3201

compass:
	$(CC) $(FLAGS) -a src/compass/compass.vhd
tb_compass:
	$(CC) $(FLAGS) -a src/compass/tb_compass.vhd

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

tb_mcp3201: mcp3201
	$(CC) $(FLAGS) -a src/verin/tb_mcp3201.vhd

verin: pwm spi_master mcp3201
	$(CC) $(FLAGS) -a src/verin/verin.vhd

anemometre: edge_detector
	$(CC) $(FLAGS) -a src/anemometre/anemometre.vhd

tb_anemometre: anemometre
	$(CC) $(FLAGS) -a src/anemometre/tb_anemometre.vhd

boutons:
	$(CC) $(FLAGS) -a src/boutons/boutons.vhd

tb_boutons: boutons
	$(CC) $(FLAGS) -a src/boutons/tb_boutons.vhd

clean:
	$(CC) --clean
