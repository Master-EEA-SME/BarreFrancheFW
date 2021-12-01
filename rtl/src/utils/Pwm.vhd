library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Pwm is
    generic (
        N : integer := 16
    );
    port (
        ARst_i  : in    std_logic;
        Clk_i   : in    std_logic;
        En_i    : in    std_logic;
        Duty_i  : in    std_logic_vector(N - 1 downto 0);
        Freq_i  : in    std_logic_vector(N - 1 downto 0);
        Q       : out   std_logic
    );
end entity Pwm;

architecture rtl of Pwm is
    signal s_FreqCnt    : unsigned(N downto 0);
    signal s_Q          : std_logic;
begin
    -- Générateur de fréquence, ce process nous permettra d'obtenir la fréquence du PWM
    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_FreqCnt <= (others => '0');
        elsif rising_edge(Clk_i) then
            if En_i = '1' then
                s_FreqCnt <= ('0' & s_FreqCnt(s_FreqCnt'left - 1 downto 0)) + ('0' & Freq_i);
            else
                s_FreqCnt <= (others => '0');
            end if;
        end if;
    end process;

    -- Ce process permet de générer le rapport cyclique.
    -- Le rapport cyclique sera un pourcentage de la plage 0 à 2^N - 1
    -- On fait la comparaison dans ce process pour stabiliser Q
    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            Q <= '0';
        elsif rising_edge(Clk_i) then
            if En_i = '1' then
                if s_FreqCnt(s_FreqCnt'left - 1 downto 0) < Duty_i then
                    Q <= '1';
                else
                    Q <= '0';
                end if;
            else
                Q <= '0';
            end if;
        end if;
    end process;
    
end architecture rtl;