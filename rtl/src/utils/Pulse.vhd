library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all; -- log2, ceil

entity Pulse is
    generic (
        C_FREQ_IN   : integer := 50e6;
        C_FREQ_OUT  : integer := 1e6
    );
    port (
        ARst_i  : in    std_logic := '0';
        Clk_i   : in    std_logic;
        SRst_i  : in    std_logic := '0';
        En_i    : in    std_logic;
        Q_o     : out   std_logic
    );
end entity Pulse;

architecture rtl of Pulse is
    constant N      : integer := integer(ceil(log2(real(C_FREQ_IN / C_FREQ_OUT - 1))));
    signal s_Cnt    : unsigned(N - 1 downto 0);
begin
    
    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_Cnt <= (others => '0');
            Q_o <= '0';
        elsif rising_edge(Clk_i) then
            if SRst_i = '1' then
                s_Cnt <= (others => '0');
                Q_o <= '0';
            else
                if En_i = '1' then
                    s_Cnt <= s_Cnt + 1;
                    if s_Cnt >= (C_FREQ_IN / C_FREQ_OUT) - 1 then
                        s_Cnt <= (others => '0');
                        Q_o <= '1';
                    else 
                        Q_o <= '0';
                    end if;
                else
                    Q_o <= '0';
                end if;
            end if;
        end if;
    end process;
    
end architecture rtl;