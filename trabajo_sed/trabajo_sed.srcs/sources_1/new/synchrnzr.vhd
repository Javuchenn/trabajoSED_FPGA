
-- Este bloque sirve para sincronizar las entradas

library IEEE;
use IEEE.std_logic_1164.all;

entity synchrnzr is
port (
    CLK                : in std_logic;
    iniciar_compra_in  : in std_logic;
    confirm_in         : in std_logic;
    euro1_in           : in std_logic;
    cent50_in          : in std_logic;
    cent20_in          : in std_logic;
    cent10_in          : in std_logic;

    iniciar_compra_out : out std_logic;
    confirm_out        : out std_logic;
    euro1_out          : out std_logic;
    cent50_out         : out std_logic;
    cent20_out         : out std_logic;
    cent10_out         : out std_logic
);
end synchrnzr;

architecture behavioral of synchrnzr is
    signal sreg_iniciar: std_logic_vector(1 downto 0) := "00";
    signal sreg_confirm: std_logic_vector(1 downto 0) := "00";
    signal sreg_euro1: std_logic_vector(1 downto 0) := "00";
    signal sreg_cent50: std_logic_vector(1 downto 0) := "00";
    signal sreg_cent20: std_logic_vector(1 downto 0) := "00";
    signal sreg_cent10: std_logic_vector(1 downto 0) := "00";

begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            iniciar_compra_out <= sreg_iniciar(1);
            confirm_out        <= sreg_confirm(1);
            euro1_out          <= sreg_euro1(1);
            cent50_out         <= sreg_cent50(1);
            cent20_out         <= sreg_cent20(1);
            cent10_out         <= sreg_cent10(1);

            sreg_iniciar <= sreg_iniciar(0) & iniciar_compra_in;
            sreg_confirm  <= sreg_confirm(0) & confirm_in;
            sreg_euro1    <= sreg_euro1(0) & euro1_in;
            sreg_cent50   <= sreg_cent50(0) & cent50_in;
            sreg_cent20   <= sreg_cent20(0) & cent20_in;
            sreg_cent10   <= sreg_cent10(0) & cent10_in;
        end if;
    end process;

end behavioral;