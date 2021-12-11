CC=ghdl
FLAGS=

all: all_rtl all_tb avalon

all_rtl: compass pwm verin anemometre boutons

all_tb: tb_anemometre tb_boutons tb_compass tb_mcp3201

avalon: avalon_anemometre avalon_boutons avalon_compass avalon_verin

utils:
	$(CC) $(FLAGS) -a src/utils/utils.vhd

compass:
	$(CC) $(FLAGS) -a src/compass/compass.vhd
tb_compass: compass
	$(CC) $(FLAGS) -a src/compass/tb_compass.vhd

pwm:
	$(CC) $(FLAGS) -a src/utils/pwm.vhd

spi_master:
	$(CC) $(FLAGS) -a src/utils/spi_master.vhd

mcp3201: spi_master
	$(CC) $(FLAGS) -a src/verin/mcp3201.vhd

tb_mcp3201: mcp3201
	$(CC) $(FLAGS) -a src/verin/tb_mcp3201.vhd

verin: utils pwm spi_master mcp3201
	$(CC) $(FLAGS) -a src/verin/verin.vhd

anemometre:
	$(CC) $(FLAGS) -a src/anemometre/anemometre.vhd

tb_anemometre: anemometre
	$(CC) $(FLAGS) -a src/anemometre/tb_anemometre.vhd

boutons:
	$(CC) $(FLAGS) -a src/boutons/boutons.vhd

tb_boutons: boutons
	$(CC) $(FLAGS) -a src/boutons/tb_boutons.vhd

avalon_anemometre: utils anemometre
	$(CC) $(FLAGS) -a src/anemometre/avalon_anemometre.vhd

avalon_boutons: utils boutons
	$(CC) $(FLAGS) -a src/boutons/avalon_boutons.vhd

avalon_compass: utils compass
	$(CC) $(FLAGS) -a src/compass/avalon_compass.vhd

avalon_verin: utils verin
	$(CC) $(FLAGS) -a src/verin/avalon_verin.vhd

clean:
	$(CC) --clean
