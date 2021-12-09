library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SpiMaster is
    port (
        ARst_i  : in    std_logic;
        Clk_i   : in    std_logic;
        SRst_i  : in    std_logic;
        Freq_i  : in    std_logic_vector(15 downto 0);
        En_i    : in    std_logic;
        Trg_i   : in    std_logic;
        TxDat_i : in    std_logic_vector(7 downto 0);
        RxDat_o : out   std_logic_vector(7 downto 0);
        RxVld_o : out   std_logic;
        Busy_o  : out   std_logic;
        Sck_o   : out   std_logic;
        Miso_i  : in    std_logic;
        Mosi_o  : out   std_logic;
        Cs_N_o  : out   std_logic
    );
end entity SpiMaster;

architecture rtl of SpiMaster is
    signal s_FreqCnt                : unsigned(16 downto 0); 
    signal s_Transfer               : std_logic;
    signal s_Sck, s_SckRe, s_SckFe  : std_logic;
    signal s_Miso : std_logic;
    signal s_BitCnt : std_logic_vector(7 downto 0);
    signal s_ShiftEn : std_logic;
    signal s_TxDat, s_RxDat : std_logic_vector(7 downto 0);
    signal s_RxVld : std_logic;
begin
    -- Rendre synchrone Miso
    process (Clk_i)
    begin
        if rising_edge(Clk_i) then
            s_Miso <= Miso_i;
        end if;
    end process;
    -- Permet de générer la fréquence
    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_FreqCnt <= unsigned('0' & Freq_i);
        elsif rising_edge(Clk_i) then
            if SRst_i = '1' then
                s_FreqCnt <= unsigned('0' & Freq_i);
            else
                if s_Transfer = '1' then
                    s_FreqCnt <= ('0' & s_FreqCnt(15 downto 0)) + unsigned('0' & Freq_i);
                    if s_FreqCnt(16) = '1' then
                        s_Sck <= not s_Sck;
                    end if;
                else
                    s_FreqCnt <= unsigned('0' & Freq_i);
                    s_Sck <= '0';
                end if;
            end if;
        end if;
    end process;
    -- Detections de front montants de l'horloge Sck
    s_SckRe <= '1' when s_FreqCnt(16) = '1' and s_Sck = '0' else '0';
    s_SckFe <= '1' when s_FreqCnt(16) = '1' and s_Sck = '1' else '0';

    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_BitCnt <= x"01";
            s_RxVld <= '0';
            Cs_N_o <= '1';
        elsif rising_edge(Clk_i) then
            s_RxVld <= '0';
            if Trg_i = '1' then
                s_TxDat <= TxDat_i;
            end if;
            if s_Transfer = '1' then
                if s_SckFe = '1' then
                    s_ShiftEn <= '1'; -- Autorisation de faire le decalage de s_TxDat
                    s_BitCnt <= s_BitCnt(6 downto 0) & '0';
                    if s_ShiftEn = '1' then
                        s_TxDat <= s_TxDat(6 downto 0) & '0';
                    end if;
                    if s_BitCnt(7) = '1' then
                        s_RxVld <= '1';
                        s_Transfer <= '0';
                    end if;
                end if;
                if s_SckRe = '1' then -- On récupère les données sur les front montants
                    s_RxDat <= s_RxDat(6 downto 0) & s_Miso;
                end if;
            else
                s_ShiftEn <= '0';
                s_BitCnt <= x"01";
                Cs_N_o <= not En_i;
                s_Transfer <= Trg_i;
            end if;
        end if;
    end process;
    RxDat_o <= s_RxDat;
    RxVld_o <= s_RxVld;
    Sck_o <= s_Sck;
    Mosi_o <= s_TxDat(7);
end architecture rtl;