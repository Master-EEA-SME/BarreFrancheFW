library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_mcp3201 is
end entity tb_mcp3201;

architecture rtl of tb_mcp3201 is
    constant C_CLK_PER : time := 20 ns;
    signal s_arst      : std_logic;
    signal s_clk       : std_logic;
    signal s_trg       : std_logic;
begin

    p_arst : process
    begin
        s_arst <= '1';
        wait for 63 ns;
        s_arst <= '0';
        wait;
    end process p_arst;

    p_clk : process
    begin
        s_clk <= '1';
        wait for C_CLK_PER / 2;
        s_clk <= '0';
        wait for C_CLK_PER / 2;
    end process p_clk;

    p_tb : process
    begin
        s_trg <= '0';
        wait for 5 * C_CLK_PER;
        s_trg <= '1';
        wait for C_CLK_PER;
        s_trg <= '0';
        wait;
    end process p_tb;

    mcp3201_inst : entity work.mcp3201
        generic map(
            C_FREQ_IN  => 50e6,
            C_FREQ_SCK => 1e6)
        port map(
            arst_i => s_arst, clk_i => s_clk,
            trg_i => s_trg, dat_o => open, dv_o => open,
            sck_o => open, miso_i => '1', cs_n_o => open);
end architecture rtl;