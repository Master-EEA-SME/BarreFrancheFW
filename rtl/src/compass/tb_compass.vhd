library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_compass is
end entity tb_compass;

architecture rtl of tb_compass is
    constant C_CLK_PER : time := 20 ns;
    signal s_arst : std_logic;
    signal s_clk : std_logic;
    signal s_compass : std_logic;
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
    
    p_tb: process
    begin
        s_continu <= '0'; s_start_stop <= '0';
        wait for 5*C_CLK_PER;
        s_start_stop <= '1';
        wait for 100*C_CLK_PER;
        wait;
    end process p_tb;

    p_compass: process
    begin
        s_compass <= '0';
        wait for 100 ns;
        for i in 0 to 100 loop
            s_compass <= '1';
            wait for 10 ms;
            s_compass <= '0';
            wait for 10 ms;
        end loop;
        wait;
    end process p_compass;
    
end architecture rtl;