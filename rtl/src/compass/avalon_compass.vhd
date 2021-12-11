library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils.all;

entity avalon_compass is
    port (
        arst_i       : in std_logic;
        clk_i        : in std_logic;
        sig_i        : in std_logic;
        write_i      : in std_logic;
        write_data_i : in std_logic_vector(31 downto 0);
        read_i       : in std_logic;
        read_data_o  : out std_logic_vector(31 downto 0)
    );
end entity avalon_compass;

architecture rtl of avalon_compass is
    signal s_start_stop, s_continu : std_logic;
    signal s_dat_compass           : std_logic_vector(8 downto 0);
    signal s_dv                    : std_logic;
begin
    p_write : process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_start_stop <= '0';
            s_continu    <= '0';
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                s_start_stop <= write_data_i(0);
                s_continu    <= write_data_i(1);
            end if;
        end if;
    end process p_write;

    read_data_o <= x"00000" & "00" & s_dv & s_dat_compass;

    u_compass : compass
        generic map(
            C_FREQ_IN => 50e6)
        port map(
            arst_i       => arst_i,
            clk_i        => clk_i,
            srst_i       => '0',
            sig_i        => sig_i,
            start_stop_i => s_start_stop,
            continu_i    => s_continu,
            dat_o        => s_dat_compass,
            dv_o         => s_dv
        );

end architecture rtl;