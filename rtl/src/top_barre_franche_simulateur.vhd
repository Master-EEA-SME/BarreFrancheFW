library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_barre_franche_simulateur is
    port (
        pin_arst_n_i : in std_logic;
        pin_clk_i    : in std_logic;
        pin_btn_i    : in std_logic;
        pin_sw_i     : in std_logic_vector(3 downto 0);
        pin_led_o    : out std_logic_vector(7 downto 0);
        pin_rx_i     : in std_logic;
        pin_tx_o     : out std_logic
    );
end entity top_barre_franche_simulateur;

architecture rtl of top_barre_franche_simulateur is
    component mcu_barre_franche
        port (
            clk_clk             : in std_logic;
            anemometre_anemo_i  : in std_logic;
            compass_sig_i       : in std_logic;
            ihm_btn_babord_n_i  : in std_logic;
            ihm_btn_stby_n_i    : in std_logic;
            ihm_btn_tribord_n_i : in std_logic;
            ihm_led_babord_o    : out std_logic;
            ihm_led_stby_o      : out std_logic;
            ihm_led_tribord_o   : out std_logic;
            leds_export         : out std_logic_vector(7 downto 0);
            push_buttons_export : in std_logic;
            reset_reset_n       : in std_logic;
            switchs_export      : in std_logic_vector(3 downto 0);
            verin_sck_o         : out std_logic;
            verin_pwm_o         : out std_logic;
            verin_miso_i        : in std_logic;
            verin_cs_n_o        : out std_logic;
            verin_sens_o        : out std_logic
        );
    end component;
    component Simu
        generic (
            C_Freq : integer
        );
        port (
            ARst           : in std_logic;
            Clk            : in std_logic;
            SRst           : in std_logic;
            AnemoOut       : out std_logic;
            GiroPwm        : out std_logic;
            CapPwm         : out std_logic;
            VerinPwm       : in std_logic;
            VerinSens      : in std_logic;
            VerinAngleSck  : in std_logic;
            VerinAngleMiso : out std_logic;
            VerinAngleCs_N : in std_logic;
            BtnBabord      : out std_logic;
            BtnTribord     : out std_logic;
            BtnStandby     : out std_logic;
            LedBabord      : in std_logic;
            LedTribord     : in std_logic;
            LedStandby     : in std_logic;
            Rx             : in std_logic;
            Tx             : out std_logic
        );
    end component;

    signal s_arst_n, s_arst                                          : std_logic;
    signal s_clk                                                     : std_logic;
    signal s_anemo, s_giro, s_compass                                : std_logic;
    signal s_verin_adc_sck, s_verin_adc_miso, s_verin_adc_cs_n       : std_logic;
    signal s_verin_pwm, s_verin_sens                                 : std_logic;
    signal s_ihm_btn_babord_n, s_ihm_btn_stby_n, s_ihm_btn_tribord_n : std_logic;
    signal s_ihm_led_babord, s_ihm_led_stby, s_ihm_led_tribord       : std_logic;
begin
    s_arst_n <= pin_arst_n_i;
    s_arst   <= not s_arst_n;
    s_clk    <= pin_clk_i;
    u_mcu_barre_franche : mcu_barre_franche
        port map(
            reset_reset_n => s_arst_n, clk_clk => s_clk,
            compass_sig_i => s_compass, anemometre_anemo_i => s_anemo,
            ihm_btn_babord_n_i => s_ihm_btn_babord_n, ihm_btn_stby_n_i => s_ihm_btn_stby_n, ihm_btn_tribord_n_i => s_ihm_btn_tribord_n,
            ihm_led_babord_o => s_ihm_led_babord, ihm_led_stby_o => s_ihm_led_stby, ihm_led_tribord_o => s_ihm_led_tribord,
            push_buttons_export => pin_btn_i, switchs_export => pin_sw_i, leds_export => pin_led_o,
            verin_sck_o => s_verin_adc_sck, verin_miso_i => s_verin_adc_miso, verin_cs_n_o => s_verin_adc_cs_n,
            verin_pwm_o => s_verin_pwm, verin_sens_o => s_verin_sens);

    u_simu : Simu
        generic map(
            C_Freq => 50e6)
        port map(
            ARst => s_arst, Clk => s_clk, SRst => '0',
            AnemoOut => s_anemo, GiroPwm => s_giro, CapPwm => s_compass,
            VerinPwm => s_verin_pwm, VerinSens => s_verin_sens,
            VerinAngleSck => s_verin_adc_sck, VerinAngleMiso => s_verin_adc_miso, VerinAngleCs_N => s_verin_adc_cs_n,
            BtnBabord => s_ihm_btn_babord_n, BtnTribord => s_ihm_btn_tribord_n, BtnStandby => s_ihm_btn_stby_n,
            LedBabord => s_ihm_led_babord, LedTribord => s_ihm_led_stby, LedStandby => s_ihm_led_stby,
            Rx => pin_rx_i, Tx => pin_tx_o);
end architecture rtl;