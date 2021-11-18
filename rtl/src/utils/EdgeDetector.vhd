library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EdgeDetector is
    generic (
        C_SYNC : boolean := false
    );
    port (
        ARst_i  : in    std_logic := '0';
        Clk_i   : in    std_logic;
        SRst_i  : in    std_logic := '0';
        Di_i    : in    std_logic;
        Re_o    : out   std_logic;
        Fe_o    : out   std_logic
    );
end entity EdgeDetector;

architecture rtl of EdgeDetector is
    signal s_reg    : std_logic_vector(1 downto 0);
begin
    genASYNC: if C_SYNC = false generate
        process (Clk_i, ARst_i)
        begin
            if ARst_i = '1' then
                s_reg(0) <= '0';
            elsif rising_edge(Clk_i) then
                if SRst_i = '1' then
                    s_reg(0) <= '0';
                else
                    s_reg(0) <= Di_i;
                end if;
            end if;
        end process;
    end generate genASYNC;

    genSYNC: if C_SYNC = true generate
        s_reg(0) <= Di_i;
    end generate genSYNC;

    process (Clk_i, ARst_i)
    begin
        if ARst_i = '1' then
            s_reg(1) <= '0';
        elsif rising_edge(Clk_i) then
            if SRst_i = '1' then
                s_reg(1) <= '0';
            else
                s_reg(1) <= s_reg(0);
            end if;
        end if;
    end process;
    Re_o <= not s_reg(1) and s_reg(0);
    Fe_o <= not s_reg(0) and s_reg(1);
end architecture rtl;