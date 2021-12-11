library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_boutons is
end entity tb_boutons;

architecture rtl of tb_boutons is
    constant C_CLK_PER : time := 20 ns;
    signal s_arst : std_logic;
    signal s_clk : std_logic;
    signal s_babord, s_tribord, s_stby : std_logic;
    signal s_babord_n, s_tribord_n, s_stby_n : std_logic;
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

    p_tb: process
    begin
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '1'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '1';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '1'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '1'; s_stby <= '0'; s_tribord <= '0'; -- 1° babord
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '1'; -- 1° tribord
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '0'; s_tribord <= '0';
        wait for 5*C_CLK_PER;
        s_babord <= '0'; s_stby <= '1'; s_tribord <= '0'; -- retour mode manuel
        wait for 5*C_CLK_PER;
        wait;
    end process p_tb;

    u_boutons : entity work.boutons
        port map (
            arst_i => s_arst, clk_i => s_clk, srst_i => '0',
            btn_babord_n_i => s_babord_n, btn_tribord_n_i => s_tribord_n, btn_stby_n_i => s_stby_n,
            led_babord_o => open, led_tribord_o => open, led_stby_o => open,
            code_fonction => open);
    s_babord_n <= not s_babord;
    s_tribord_n <= not s_tribord;
    s_stby_n <= not s_stby;
end architecture rtl;