library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity anemometre is
    generic (
        C_FREQ_IN : integer := 50_000_000
    );
    port (
        arst_i      : in    std_logic := '0';
        clk_i       : in    std_logic;
        anemo_i     : in    std_logic;
        start_stop_i : in    std_logic;
        continu_i   : in    std_logic;
        dat_o       : out   std_logic_vector(8 downto 0);
        dv_o        : out   std_logic
    );
end entity anemometre;

architecture rtl of anemometre is
    signal C_1S_CNT_INCR : unsigned(31 downto 0) := to_unsigned(integer(1.0 * 2.0 ** 32 / real(C_FREQ_IN)), 32);
    signal s_1s_cnt : unsigned(32 downto 0);
    signal s_anemo_cnt : unsigned(8 downto 0); -- Compteur de fronts montants
    signal s_running    : std_logic; -- Indique qu'une mesure est en cours d'acquisition
    signal s_anemo, s_danemo, s_anemo_re : std_logic;
begin
    -- Générateur d'impulsions pour avoir une base d'une seconde
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_1s_cnt <= '0' & C_1S_CNT_INCR;
        elsif rising_edge(clk_i) then
            if s_running = '1' then
                s_1s_cnt <= ('0' & s_1s_cnt(31 downto 0)) + ('0' & C_1S_CNT_INCR);
            else
                s_1s_cnt <= '0' & C_1S_CNT_INCR;
            end if;
        end if;
    end process;
    -- Détecteur de front montants pour detecter un front montant de anemo_i
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_anemo <= '0';
            s_danemo <= '0';
        elsif rising_edge(clk_i) then
            s_anemo <= anemo_i;
            s_danemo <= s_anemo;
        end if;
    end process;
    s_anemo_re <= '1' when s_anemo = '1' and s_danemo = '0' else '0';

    -- Process qui permet de compter les front montants de anemo_i
    pAnemoReCnt : process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_anemo_cnt <= (others => '0');
        elsif rising_edge(clk_i) then
            if s_Running = '1' then -- Si une mesure est en cours, on compte les front montants
                if s_anemo_re = '1' then
                    s_anemo_cnt <= s_anemo_cnt + 1;
                end if;
            else -- Si aucune mesure est en cours, on remet à 0 le compteur pour qu'il soit prêt à une nouvelle mesure
                s_anemo_cnt <= (others => '0'); 
            end if;
        end if;
    end process pAnemoReCnt;

    -- Process qui permet de mettre à jour la valeur mesuré et ainsi la memorisé
    pMem: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            dv_o <= '0';
        elsif rising_edge(clk_i) then
            if s_1s_cnt(s_1s_cnt'left) = '1' then -- Cela indique qu'une seconde s'est écroulé, on recopie la valeur mésuré (s_AnemoReCnt) dans dat_o et on indique que la mesure est valide (dv_o)
                dat_o <= std_logic_vector(s_anemo_cnt);
                dv_o <= '1';
            else -- On remet à 0 dv_o car on veut que dv_o soit à 1 pendant un seul coup d'horloge
                dv_o <= '0';
            end if;
        end if;
    end process pMem;

    pMode: process(clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_Running <= '0';
        elsif rising_edge(clk_i) then
            if s_1s_cnt(s_1s_cnt'left) = '1' then
                s_Running <= '0';
            elsif continu_i = '1' then
                s_Running <= '1';
            elsif start_stop_i = '1' then
                s_Running <= '1';
            end if;
        end if;
    end process pMode;


    
end architecture rtl;