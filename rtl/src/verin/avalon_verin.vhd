library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity avalon_verin is
    port (
        arst_i       : in std_logic;
        clk_i        : in std_logic;
        address_i    : in std_logic_vector(2 downto 0);
        write_i      : in std_logic;
        write_data_i : in std_logic_vector(31 downto 0);
        read_i       : in std_logic;
        read_data_o  : out std_logic_vector(31 downto 0);
        sck_o        : out std_logic;
        miso_i       : in std_logic;
        cs_n_o       : out std_logic;
        pwm_o        : out std_logic;
        sens_o       : out std_logic
    );
end entity avalon_verin;

architecture rtl of avalon_verin is
    signal s_freq, s_duty, s_butee_g, s_butee_d             : std_logic_vector(15 downto 0);
    signal s_en_pwm, s_sens, s_fin_course_d, s_fin_course_g : std_logic;
    signal s_angle_barre                                    : std_logic_vector(11 downto 0);
begin

    p_write : process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_freq    <= (others => '0');
            s_duty    <= (others => '0');
            s_butee_g <= (others => '0');
            s_butee_d <= (others => '0');
            s_en_pwm  <= '0';
            s_sens    <= '0';
        elsif rising_edge(clk_i) then
            if write_i = '1' then
                case to_integer(unsigned(address_i)) is
                    when 0 =>
                        s_freq <= write_data_i(15 downto 0);
                    when 1 =>
                        s_duty <= write_data_i(15 downto 0);
                    when 2 =>
                        s_butee_g <= write_data_i(15 downto 0);
                    when 3 =>
                        s_butee_d <= write_data_i(15 downto 0);
                    when 4 =>
                        s_en_pwm <= write_data_i(0);
                        s_sens   <= write_data_i(0);
                    when others =>
                end case;
            end if;
        end if;
    end process p_write;
    read_data_o <=
        x"0000" & s_freq when to_integer(unsigned(address_i)) = 0 else
        x"0000" & s_duty when to_integer(unsigned(address_i)) = 1 else
        x"0000" & s_butee_g when to_integer(unsigned(address_i)) = 2 else
        x"0000" & s_butee_d when to_integer(unsigned(address_i)) = 3 else
        x"0000000" & s_fin_course_g & s_fin_course_d & s_sens & s_en_pwm when to_integer(unsigned(address_i)) = 4 else
        x"00000" & s_angle_barre when to_integer(unsigned(address_i)) = 5 else
        (others => '0');
    u_verin : entity work.verin
        generic map(
            C_FREQ_IN  => 50e6,
            C_FREQ_SCK => 1e6)
        port map(
            arst_i         => arst_i,
            clk_i          => clk_i,
            pwm_en_i       => s_en_pwm,
            pwm_duty_i     => s_duty,
            pwm_freq_i     => s_freq,
            butee_g_i      => s_butee_g(11 downto 0),
            butee_d_i      => s_butee_d(11 downto 0),
            fin_course_d_o => s_fin_course_d,
            fin_course_g_o => s_fin_course_g,
            angle_barre_o  => s_angle_barre,
            sens_i         => s_sens,
            sck_o          => sck_o,
            miso_i         => miso_i,
            cs_n_o         => cs_n_o,
            sens_o         => sens_o,
            pwm_o          => pwm_o
        );

end architecture rtl;