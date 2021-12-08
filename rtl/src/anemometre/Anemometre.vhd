library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Anemometre is
    port (
        ARst_i      : in    std_logic := '0';
        Clk_i       : in    std_logic;
        Anemo_i     : in    std_logic;
        StartStop_i : in    std_logic;
        Continu_i   : in    std_logic;
        Dat_o       : out   std_logic_vector(8 downto 0);
        Dv_o        : out   std_logic
    );
end entity Anemometre;

architecture rtl of Anemometre is
    signal s_AnemoInRe  : std_logic; -- Image du front montant de Anemo_i
    signal s_AnemoReCnt : unsigned(8 downto 0); -- Compteur de fronts montants
    signal s_Running    : std_logic; -- Indique qu'une mesure est en cours d'acquisition
    signal s_PulseSRst  : std_logic;
    signal s_PulseQ     : std_logic;
begin
    s_PulseSRst <= not s_Running; -- On remet à 0 le générateur d'impulsions lorsque aucune mesure est en cours. 
    -- On instancie un générateur d'impulsions pour avoir une base d'une seconde
    u_pulse_1hz : entity work.Pulse 
        generic map (
            C_FREQ_IN => 50e6, C_FREQ_OUT  => 1) -- Pour la simulation, on mesurera Anemo_i sur 10us => C_FREQ_OUT = 100e3
        port map (
            ARst_i  => ARst_i,  Clk_i   => Clk_i,   SRst_i  => s_PulseSRst,
            En_i    => '1',     Q_o     => s_PulseQ);

    -- On instancie un détecteur de front montants / front descendant pour detecter un front montant
    -- de Anemo_i
    uAnemoInEd : entity work.EdgeDetector 
        generic map (
            C_SYNC => false)
        port map (
            ARst_i  => ARst_i,  Clk_i   => Clk_i,       SRst_i  => '0',
            Di_i    => Anemo_i, Re_o    => s_AnemoInRe, Fe_o    => open);

    -- Process qui permet de compter les front montants de Anemo_i
    pAnemoReCnt : process(Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_AnemoReCnt <= (others => '0');
        elsif rising_edge(Clk_i) then
            if s_Running = '1' then -- Si une mesure est en cours, on compte les front montants
                if s_AnemoInRe = '1' then
                    s_AnemoReCnt <= s_AnemoReCnt + 1;
                end if;
            else -- Si aucune mesure est en cours, on remet à 0 le compteur pour qu'il soit prêt à une nouvelle mesure
                s_AnemoReCnt <= (others => '0'); 
            end if;
        end if;
    end process pAnemoReCnt;

    -- Process qui permet de mettre à jour la valeur mesuré et ainsi la memorisé
    pMem: process(Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            Dv_o <= '0';
        elsif rising_edge(Clk_i) then
            if s_PulseQ = '1' then -- Cela indique qu'une seconde s'est écroulé, on recopie la valeur mésuré (s_AnemoReCnt) dans Dat_o et on indique que la mesure est valide (Dv_o)
                Dat_o <= std_logic_vector(s_AnemoReCnt);
                Dv_o <= '1';
            else -- On remet à 0 Dv_o car on veut que Dv_o soit à 1 pendant un seul coup d'horloge
                Dv_o <= '0';
            end if;
        end if;
    end process pMem;

    pMode: process(Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_Running <= '0';
        elsif rising_edge(Clk_i) then
            if s_PulseQ = '1' then
                s_Running <= '0';
            elsif Continu_i = '1' then
                s_Running <= '1';
            elsif StartStop_i = '1' then
                s_Running <= '1';
            end if;
        end if;
    end process pMode;


    
end architecture rtl;