library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_anemometre is
end entity tb_anemometre;

architecture rtl of tb_anemometre is
    constant C_CLK_PER : time := 20 ns;
    signal s_arst : std_logic;
    signal s_clk : std_logic;
    signal s_anemo : std_logic;
    signal s_start_stop, s_continu : std_logic;
begin
    
    p_arst: process
    begin
        s_arst <= '1';
        wait for 63 ns;
        s_arst <= '0';
        wait;
    end process p_arst;

    p_clk: process
    begin
        s_clk <= '1';
        wait for C_CLK_PER / 2;
        s_clk <= '0';
        wait for C_CLK_PER / 2;
    end process p_clk;

    -- Avant de simuler, mettre C_FREQ_OUT à 10e3 dans u_anemometre/u_pulse_1hz pour que
    -- l'anemomètre mesure sur une periode de 100 us.
    p_tb: process
    begin
        s_anemo <= '0';
        s_start_stop <= '0'; s_continu <= '0';
        wait for 5*C_CLK_PER;
        s_start_stop <= '1';
        wait for C_CLK_PER;
        s_start_stop <= '0';
        wait for 5*C_CLK_PER;
        for i in 1 to 100 loop
            s_anemo <= '1';
            wait for 30*C_CLK_PER;
            s_anemo <= '0';
            wait for 20*C_CLK_PER;
        end loop;
        wait for 100*C_CLK_PER;
        s_continu <= '1';
        wait for 5*C_CLK_PER;
        for i in 1 to 50 loop
            s_anemo <= '1';
            wait for 30*C_CLK_PER;
            s_anemo <= '0';
            wait for 20*C_CLK_PER;
        end loop;
        wait for 2750*C_CLK_PER;
        for i in 1 to 150 loop
            s_anemo <= '1';
            wait for 10*C_CLK_PER;
            s_anemo <= '0';
            wait for 10*C_CLK_PER;
        end loop;
        s_continu <= '0';
        wait;
    end process p_tb;

    u_anemometre : entity work.anemometre
        port map (
            ARst_i => s_arst, Clk_i => s_clk,
            Anemo_i => s_anemo,
            StartStop_i => s_start_stop, Continu_i => s_continu,
            Dat_o => open, Dv_o => open);

end architecture rtl;