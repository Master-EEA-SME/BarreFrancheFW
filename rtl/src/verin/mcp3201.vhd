library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mcp3201 is
    generic (
        C_FREQ_IN : integer := 50_000_000;
        C_FREQ_SCK : integer := 1_000_000
    );
    port (
        arst_i  : in    std_logic;
        clk_i   : in    std_logic;
        trg_i   : in    std_logic;
        dat_o   : out   std_logic_vector(11 downto 0);
        dv_o    : out   std_logic;
        sck_o   : out   std_logic;
        miso_i  : in    std_logic;
        cs_n_o  : out   std_logic
    );
end entity mcp3201;

architecture rtl of mcp3201 is
    constant C_FREQ : integer := integer(real(C_FREQ_SCK) * 2.0*17 / real(C_FREQ_IN));
    signal s_en, s_trg : std_logic;
    signal s_rx_dat : std_logic_vector(7 downto 0);
    signal s_rx_vld : std_logic;
    signal s_busy : std_logic;
    signal s_byte_cnt : std_logic_vector(1 downto 0);
    signal s_dat : std_logic_vector(15 downto 0);
begin
    
    u_spi_master : entity work.SpiMaster
        port map (
            ARst_i => arst_i,
            Clk_i => clk_i,
            SRst_i => '0',
            Freq_i => std_logic_vector(to_unsigned(C_FREQ, 16)),
            En_i =>,
            Trg_i =>,
            TxDat_i =>,
            RxDat_o =>,
            RxVld_o =>,
            Busy_o =>,
            Sck_o =>,
            Miso_i =>,
            Mosi_o =>,
            Cs_N_o =>);
    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            dv_o <= '0';
        elsif rising_edge(clk_i) then
            if trg_i = '1' then
                s_byte_cnt <= "01";
            end if;
            dat_o <= '0';
            if s_rx_vld = '1' then
                s_byte_cnt <= s_byte_cnt(0) & '0';
                s_dat <= s_dat(7 downto 0) & s_rx_dat;
                if s_byte_cnt(1) = '1' then
                    dat_o <= '1';
                end if;
            end if;
        end if;
    end process;
    dat_o <= s_dat(11 downto 0);
end architecture rtl;