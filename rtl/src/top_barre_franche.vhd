library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity top_barre_franche is
    port (
        pin_arst_n_i         : in std_logic;
        pin_clk_i            : in std_logic;
        pin_btn_i            : in std_logic;
        pin_sw_i             : in std_logic_vector(3 downto 0);
        pin_led_o            : out std_logic_vector(7 downto 0);
        pin_anemo_i          : in std_logic;
        pin_compass_i        : in std_logic;
        pin_btn_babord_n_i   : in std_logic;
        pin_btn_stby_n_i     : in std_logic;
        pin_btn_tribord_n_i  : in std_logic;
        pin_led_babord_o     : out std_logic;
        pin_led_stby_o       : out std_logic;
        pin_led_tribord_o    : out std_logic;
        pin_verin_adc_sck_o  : out std_logic;
        pin_verin_adc_miso_i : in std_logic;
        pin_verin_adc_cs_n_o : out std_logic;
        pin_verin_pwm_o      : out std_logic;
        pin_verin_sens_o     : out std_logic
    );
end entity top_barre_franche;

architecture rtl of top_barre_franche is
    component mcu_barre_franche
        port (
            clk_clk             : in std_logic;
            compass_sig_i       : in std_logic;
            anemometre_anemo_i  : in std_logic;
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
    signal s_arst_n, s_arst : std_logic;
    signal s_clk            : std_logic;
begin
    s_arst_n <= pin_arst_n_i;
    s_arst   <= not s_arst_n;
    s_clk    <= pin_clk_i;
    u_mcu_barre_franche : mcu_barre_franche
        port map(
            reset_reset_n => s_arst_n, clk_clk => s_clk,
            compass_sig_i => pin_compass_i, anemometre_anemo_i => pin_anemo_i,
            ihm_btn_babord_n_i => pin_btn_babord_n_i, ihm_btn_stby_n_i => pin_btn_stby_n_i, ihm_btn_tribord_n_i => pin_btn_tribord_n_i,
            ihm_led_babord_o => pin_led_babord_o, ihm_led_stby_o => pin_led_stby_o, ihm_led_tribord_o => pin_led_tribord_o,
            push_buttons_export => pin_btn_i, switchs_export => pin_sw_i, leds_export => pin_led_o,
            verin_sck_o => pin_verin_adc_sck_o, verin_miso_i => pin_verin_adc_miso_i, verin_cs_n_o => pin_verin_adc_cs_n_o,
            verin_pwm_o => pin_verin_pwm_o, verin_sens_o => pin_verin_sens_o);

end architecture rtl;