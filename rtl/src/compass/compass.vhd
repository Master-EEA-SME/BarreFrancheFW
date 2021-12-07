library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity compass is
    generic (
        C_FREQ_IN : integer := 50e6
    );
    port (
        arst_i       : in std_logic;
        clk_i        : in std_logic;
        srst_i       : in std_logic;
        sig_i        : in std_logic;
        start_stop_i : in std_logic;
        continu_i    : in std_logic;
        dat_o        : out std_logic_vector(8 downto 0);
        dv_o         : out std_logic
    );
end entity compass;

architecture rtl of compass is
    constant C_1MS_CNT_INCR : unsigned(15 downto 0) := to_unsigned(integer(1000.0 * 2.0**16 / real(C_FREQ_IN)), 16);
    signal s_sig, s_dsig, s_sig_re : std_logic;
    signal s_1ms_cnt               : unsigned(16 downto 0);
    signal s_cnt                   : unsigned(8 downto 0);
    signal s_running : std_logic;
begin
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_1ms_cnt <= '0' & C_1MS_CNT_INCR;
        elsif rising_edge(clk_i) then
            if s_running = '1' then
                s_1ms_cnt <= ('0' & s_1ms_cnt(15 downto 0)) + ('0' & C_1MS_CNT_INCR);
            else                
                s_1ms_cnt <= '0' & C_1MS_CNT_INCR;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_sig  <= '0';
            s_dsig <= '0';
        elsif rising_edge(clk_i) then
            s_sig  <= sig_i;
            s_dsig <= s_sig;
        end if;
    end process;
    s_sig_re <= '1' when s_dsig = '0' and s_sig = '1' else '0';

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            
        elsif rising_edge(clk_i) then
            if s_sig_re = '1' then
                s_cnt <= (others => '0');
            elsif s_1ms_cnt(16) = '1' and s_dsig = '1' then
                s_cnt <= s_cnt + 1;
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            dv_o <= '0';
        elsif rising_edge(clk_i) then
            if s_sig_re = '1' then
                dat_o <= std_logic_vector(s_cnt);
                dv_o <= '1';
            else
                dv_o <= '0';
            end if;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_running <= '0';
        elsif rising_edge(clk_i) then
            if start_stop_i = '1' or continu_i = '1' then
                s_running <= '1';
            elsif s_sig_re = '1' then
                s_running <= '0';
            end if;
        end if;
    end process;
end architecture rtl;