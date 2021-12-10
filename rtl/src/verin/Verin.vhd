library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity verin is
    generic (
        C_FREQ_IN  : integer := 50_000_000;
        C_FREQ_SCK : integer := 1_000_000
    );
    port (
        arst_i         : in std_logic;
        clk_i          : in std_logic;
        pwm_en_i       : in std_logic;
        pwm_duty_i     : in std_logic_vector(15 downto 0);
        pwm_freq_i     : in std_logic_vector(15 downto 0);
        butee_g_i      : in std_logic_vector(11 downto 0);
        butee_d_i      : in std_logic_vector(11 downto 0);
        fin_course_d_o : out std_logic;
        fin_course_g_o : out std_logic;
        angle_barre_o  : out std_logic_vector(11 downto 0);
        sens_i         : in std_logic;
        sck_o          : out std_logic;
        miso_i         : in std_logic;
        cs_n_o         : out std_logic;
        sens_o         : out std_logic;
        pwm_o          : out std_logic
    );
end entity verin;

architecture rtl of verin is
    signal s_pwm_en            : std_logic;
    signal s_adc_trg, s_adc_dv : std_logic;
    signal s_adc_dat           : std_logic_vector(11 downto 0);
    constant C_CNT_100MS_INCR  : unsigned(31 downto 0) := to_unsigned(integer(10.0 * 2.0 ** 32 / real(C_FREQ_IN)), 32);
    signal s_cnt_100ms         : unsigned(32 downto 0);
begin
    -- Gestion Pwm
    u_pwm : entity work.Pwm
        generic map(
            N => 16)
        port map(
            ARst_i => arst_i, Clk_i => clk_i,
            En_i => s_pwm_en, Duty_i => pwm_duty_i, Freq_i => pwm_freq_i,
            Q => pwm_o);
    -- Gestion butées
    s_pwm_en <=
        '0' when unsigned(s_adc_dat) >= unsigned(butee_d_i) and sens_i = '1' else
        '0' when unsigned(s_adc_dat) <= unsigned(butee_d_i) and sens_i = '0' else
        pwm_en_i;
    sens_o <= sens_i;
    -- Gestion ADC
    u_mcp3201 : entity work.mcp3201
        generic map(
            C_FREQ_IN => C_FREQ_IN, C_FREQ_SCK => C_FREQ_SCK)
        port map(
            arst_i => arst_i, clk_i => clk_i,
            trg_i => s_adc_trg, dat_o => s_adc_dat, dv_o => s_adc_dv,
            sck_o => sck_o, miso_i => miso_i, cs_n_o => cs_n_o);

    --    process (clk_i, arst_i)
    --    begin
    --        if arst_i = '1' then
    --            s_adc_cooldown_cnt <= (others => '0');
    --            s_adc_on_cooldown  <= '0';
    --        elsif rising_edge(clk_i) then
    --            if s_adc_dv = '1' then
    --                s_adc_on_cooldown  <= '1';
    --                s_adc_cooldown_cnt <= (others => '0');
    --            end if;
    --            if s_adc_on_cooldown = '1' then
    --                s_adc_cooldown_cnt <= s_adc_cooldown_cnt + 1;
    --                if s_adc_cooldown_cnt(s_adc_cooldown_cnt'left) = '1' then
    --                    s_adc_on_cooldown <= '0';
    --                end if;
    --            end if;
    --        end if;
    --    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_cnt_100ms(31 downto 0) <= (others => '1');
            s_cnt_100ms(32)          <= '0';
        elsif rising_edge(clk_i) then
            s_cnt_100ms <= ('0' & s_cnt_100ms(31 downto 0)) & ('0' & C_CNT_100MS_INCR);
        end if;
    end process;
    s_adc_trg     <= s_cnt_100ms(32);
    angle_barre_o <= s_adc_dat;
end architecture rtl;