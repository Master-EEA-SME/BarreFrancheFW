library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use work.utils.all;

entity avalon_boutons is
    port (
        arst_i          : in std_logic;
        clk_i           : in std_logic;
        btn_babord_n_i  : in std_logic;
        btn_tribord_n_i : in std_logic;
        btn_stby_n_i    : in std_logic;
        led_babord_o    : out std_logic;
        led_tribord_o   : out std_logic;
        led_stby_o      : out std_logic;
        write_i         : in std_logic;
        write_data_i    : in std_logic_vector(31 downto 0);
        read_i          : in std_logic;
        read_data_o     : out std_logic_vector(31 downto 0)
    );
end entity avalon_boutons;

architecture rtl of avalon_boutons is
    signal s_code_fonction         : std_logic_vector(3 downto 0);
begin
--    p_write : process (clk_i, arst_i)
--    begin
--        if arst_i = '1' then
--            s_start_stop <= '0';
--            s_continu    <= '0';
--        elsif rising_edge(clk_i) then
--            if write_i = '1' then
--                s_start_stop <= write_data_i(0);
--                s_continu    <= write_data_i(1);
--            end if;
--        end if;
--    end process p_write;

    read_data_o <= x"0000000" & s_code_fonction;

    u_ihm : boutons
        generic map(
            C_FREQ_IN => 50e6)
        port map(
            arst_i          => arst_i,
            clk_i           => clk_i,
            srst_i          => '0',
            btn_babord_n_i  => btn_babord_n_i,
            btn_tribord_n_i => btn_tribord_n_i,
            btn_stby_n_i    => btn_stby_n_i,
            led_babord_o    => led_babord_o,
            led_tribord_o   => led_tribord_o,
            led_stby_o      => led_stby_o,
            code_fonction   => s_code_fonction
        );

end architecture rtl;