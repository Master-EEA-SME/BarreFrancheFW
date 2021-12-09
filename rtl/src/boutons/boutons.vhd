library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity boutons is
    generic (
        C_FREQ_IN : integer := 50e6
    );
    port (
        arst_i          : in std_logic;
        clk_i           : in std_logic;
        srst_i          : in std_logic;
        btn_babord_n_i  : in std_logic;
        btn_tribord_n_i : in std_logic;
        btn_stby_n_i    : in std_logic;
        len_babord_o    : out std_logic;
        len_tribord_o   : out std_logic;
        len_stby_o      : out std_logic;
        code_fonction   : out std_logic_vector(3 downto 0)
    );
end entity boutons;

architecture rtl of boutons is
    type BOUTONS_ST is (ST_IDLE, ST_BABORD, ST_TRIBORD, ST_AUTO, ST_BABORD_APPUI, ST_BABORD_1, ST_BABORD_10, ST_TRIBORD_APPUI, ST_TRIBORD_1, ST_TRIBORD_10);
    signal s_btn_babord, s_btn_tribord, s_btn_stby : std_logic;
    signal s_dbtn_stby, s_btn_stby_re              : std_logic;
    signal current_st                              : BOUTONS_ST;
    signal s_end_tempo                             : std_logic;
    signal s_end_bip                               : std_logic;

    signal C_CNT_TEMPO_INCR     : unsigned(31 downto 0) := to_unsigned(integer(0.5 * 2.0 ** 32 / real(C_FREQ_IN)), 32);
    signal s_cnt_tempo          : unsigned(32 downto 0);
    signal C_CNT_TEMPO_BIP_INCR : unsigned(31 downto 0) := to_unsigned(integer(1.0 * 2.0 ** 32 / real(C_FREQ_IN)), 32);
    signal s_cnt_tempo_bip      : unsigned(32 downto 0);
    signal s_bip_cnt            : std_logic_vector(1 downto 0);
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            s_btn_babord  <= not btn_babord_n_i;
            s_btn_tribord <= not btn_tribord_n_i;
            s_btn_stby    <= not btn_stby_n_i;
            s_dbtn_stby   <= s_btn_stby;
        end if;
    end process;
    s_btn_stby_re <= '1' when s_dbtn_stby = '0' and s_btn_stby = '1' else '0';

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            current_st <= ST_IDLE;
        elsif rising_edge(clk_i) then
            case current_st is
                when ST_IDLE =>
                    if s_btn_stby_re = '1' then
                        current_st <= ST_AUTO;
                    elsif s_btn_babord = '1' then
                        current_st <= ST_BABORD;
                    elsif s_btn_tribord = '1' then
                        current_st <= ST_TRIBORD;
                    end if;
                when ST_BABORD =>
                    if s_btn_babord = '0' then
                        current_st <= ST_IDLE;
                    end if;
                when ST_TRIBORD =>
                    if s_btn_tribord = '0' then
                        current_st <= ST_IDLE;
                    end if;
                when ST_AUTO =>
                    if s_btn_stby_re = '1' then
                        current_st <= ST_IDLE;
                    elsif s_btn_babord = '1' then
                        current_st <= ST_BABORD_APPUI;
                    elsif s_btn_tribord = '1' then
                        current_st <= ST_TRIBORD_APPUI;
                    end if;
                when ST_BABORD_APPUI =>
                    if s_btn_babord = '1' and s_end_tempo = '1' then
                        current_st <= ST_BABORD_10;
                    elsif s_btn_babord = '0' then
                        current_st <= ST_BABORD_1;
                    end if;
                when ST_TRIBORD_APPUI =>
                    if s_btn_tribord = '1' and s_end_tempo = '1' then
                        current_st <= ST_TRIBORD_10;
                    elsif s_btn_tribord = '0' then
                        current_st <= ST_TRIBORD_1;
                    end if;
                when ST_BABORD_1 | ST_BABORD_10 | ST_TRIBORD_1 | ST_TRIBORD_10 =>
                    if s_end_bip = '1' then
                        current_st <= ST_AUTO;
                    end if;
                when others =>
            end case;
        end if;
    end process;

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_cnt_tempo <= '0' & C_CNT_TEMPO_INCR;
        elsif rising_edge(clk_i) then
            if current_st = ST_BABORD_APPUI or current_st = ST_TRIBORD_APPUI then
                s_cnt_tempo <= ('0' & s_cnt_tempo(31 downto 0)) & ('0' & C_CNT_TEMPO_INCR);
            else
                s_cnt_tempo <= '0' & C_CNT_TEMPO_INCR;
            end if;
        end if;
    end process;
    s_end_tempo <= s_cnt_tempo(s_cnt_tempo'left);

    process (clk_i, arst_i)
    begin
        if arst_i = '1' then
            s_cnt_tempo_bip <= '0' & C_CNT_TEMPO_BIP_INCR;
        elsif rising_edge(clk_i) then
            if current_st = ST_BABORD_APPUI or current_st = ST_TRIBORD_APPUI then
                s_cnt_tempo_bip <= ('0' & s_cnt_tempo_bip(31 downto 0)) & ('0' & C_CNT_TEMPO_BIP_INCR);
            else
                s_cnt_tempo_bip <= '0' & C_CNT_TEMPO_INCR;
            end if;
            if current_st = ST_BABORD_1 or current_st = ST_BABORD_10 or current_st = ST_TRIBORD_1 or current_st = ST_TRIBORD_10 then
                if s_cnt_tempo_bip(s_cnt_tempo_bip'left) = '1' then
                    s_bip_cnt <= s_bip_cnt(0) & '0';
                end if;
            else
                s_bip_cnt <= "01";
            end if;
        end if;
    end process;
    s_end_bip <=
        '1' when (current_st = ST_BABORD_1 or current_st = ST_TRIBORD_1) and s_bip_cnt(0) = '1' and s_cnt_tempo_bip(s_cnt_tempo_bip'left) = '1' else
        '1' when (current_st = ST_BABORD_10 or current_st = ST_TRIBORD_10) and s_bip_cnt(1) = '1' and s_cnt_tempo_bip(s_cnt_tempo_bip'left) = '1' else
        '0';
end architecture rtl;