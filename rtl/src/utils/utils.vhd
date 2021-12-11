library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

package utils is

    component anemometre
        generic (
            C_FREQ_IN : integer
        );
        port (
            arst_i       : in std_logic;
            clk_i        : in std_logic;
            anemo_i      : in std_logic;
            start_stop_i : in std_logic;
            continu_i    : in std_logic;
            dat_o        : out std_logic_vector(8 downto 0);
            dv_o         : out std_logic
        );
    end component;

    component boutons
        generic (
            C_FREQ_IN : integer
        );
        port (
            arst_i          : in std_logic;
            clk_i           : in std_logic;
            srst_i          : in std_logic;
            btn_babord_n_i  : in std_logic;
            btn_tribord_n_i : in std_logic;
            btn_stby_n_i    : in std_logic;
            led_babord_o    : out std_logic;
            led_tribord_o   : out std_logic;
            led_stby_o      : out std_logic;
            code_fonction   : out std_logic_vector(3 downto 0)
        );
    end component;

    component compass
        generic (
            C_FREQ_IN : integer
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
    end component;

    component pwm
        generic (
            N : integer
        );
        port (
            ARst_i : in std_logic;
            Clk_i  : in std_logic;
            En_i   : in std_logic;
            Duty_i : in std_logic_vector(N - 1 downto 0);
            Freq_i : in std_logic_vector(N - 1 downto 0);
            Q      : out std_logic
        );
    end component;

    component spi_master
        port (
            ARst_i  : in std_logic;
            Clk_i   : in std_logic;
            SRst_i  : in std_logic;
            Freq_i  : in std_logic_vector(15 downto 0);
            En_i    : in std_logic;
            Trg_i   : in std_logic;
            TxDat_i : in std_logic_vector(7 downto 0);
            RxDat_o : out std_logic_vector(7 downto 0);
            RxVld_o : out std_logic;
            Busy_o  : out std_logic;
            Sck_o   : out std_logic;
            Miso_i  : in std_logic;
            Mosi_o  : out std_logic;
            Cs_N_o  : out std_logic
        );
    end component;

    component mcp3201
        generic (
            C_FREQ_IN  : integer;
            C_FREQ_SCK : integer
        );
        port (
            arst_i : in std_logic;
            clk_i  : in std_logic;
            trg_i  : in std_logic;
            dat_o  : out std_logic_vector(11 downto 0);
            dv_o   : out std_logic;
            sck_o  : out std_logic;
            miso_i : in std_logic;
            cs_n_o : out std_logic
        );
    end component;

    component verin
        generic (
            C_FREQ_IN  : integer;
            C_FREQ_SCK : integer
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
    end component;
end package utils;