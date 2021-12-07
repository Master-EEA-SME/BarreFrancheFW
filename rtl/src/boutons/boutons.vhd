library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity boutons is
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
    signal s_dbtn_stby, s_btn_stby_re : std_logic;
    signal current_st : BOUTONS_ST;
begin
    process (clk_i)
    begin
        if rising_edge(clk_i) then
            s_btn_babord <= btn_babord_n_i; 
            s_btn_tribord <= btn_tribord_n_i; 
            s_btn_stby <= btn_stby_n_i; 
            s_dbtn_stby <= s_btn_stby;
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
                
                when ST_TRIBORD =>
                    
                when others =>
                    
            
            end case;
        end if;
    end process;
end architecture rtl;