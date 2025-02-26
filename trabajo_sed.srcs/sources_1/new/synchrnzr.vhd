----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2025 20:52:24
-- Design Name: 
-- Module Name: synchrnzr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity SYNCHRNZR is
port (
    CLK: in std_logic;
    iniciar_compra: in std_logic;
    confirm: in std_logic;
    euro1: in std_logic;
    cent50: in std_logic;
    cent20: in std_logic;
    cent10: in std_logic;

    iniciar_compraout: out std_logic;
    confirmout: out std_logic;
    euro1out: out std_logic;
    cent50out: out std_logic;
    cent20out: out std_logic;
    cent10out: out std_logic
);
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is
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
            -- Synchronize inputs
            sreg_iniciar <= sreg_iniciar(0) & iniciar_compra;
            sreg_confirm  <= sreg_confirm(0) & confirm;
            sreg_euro1    <= sreg_euro1(0) & euro1;
            sreg_cent50   <= sreg_cent50(0) & cent50;
            sreg_cent20   <= sreg_cent20(0) & cent20;
            sreg_cent10   <= sreg_cent10(0) & cent10;
        end if;
    end process;

    -- Assign synchronized outputs
    iniciar_compraout <= sreg_iniciar(1);
    confirmout        <= sreg_confirm(1);
    euro1out          <= sreg_euro1(1);
    cent50out         <= sreg_cent50(1);
    cent20out         <= sreg_cent20(1);
    cent10out         <= sreg_cent10(1);

end BEHAVIORAL;












