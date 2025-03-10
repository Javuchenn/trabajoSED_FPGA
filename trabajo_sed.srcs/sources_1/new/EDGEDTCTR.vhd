----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2025 21:36:16
-- Design Name: 
-- Module Name: EDGEDTCTR - Behavioral
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

entity EDGEDTCTR is 
port(
    CLK: IN std_logic;
    iniciar_compra: IN std_logic;
    confirm: IN std_logic;
    euro1: IN std_logic;
    cent50: IN std_logic;
    cent20: IN std_logic;
    cent10: IN std_logic;

    iniciar_compraout: OUT std_logic;
    confirmout: OUT std_logic;
    euro1out: OUT std_logic;
    cent50out: OUT std_logic;
    cent20out: OUT std_logic;
    cent10out: OUT std_logic
);
end EDGEDTCTR;

architecture behavioral of EDGEDTCTR is 
    -- Se definen registros de desplazamiento para cada señal de entrada
    signal sreg_iniciar_compra: std_logic_vector(1 downto 0);
    signal sreg_confirm: std_logic_vector(1 downto 0);
    signal sreg_euro1: std_logic_vector(1 downto 0);
    signal sreg_cent50: std_logic_vector(1 downto 0);
    signal sreg_cent20: std_logic_vector(1 downto 0);
    signal sreg_cent10: std_logic_vector(1 downto 0);

begin 
    process(CLK)
    begin
        if rising_edge(CLK) then
            -- Desplazar registros y almacenar el estado actual de cada entrada
            sreg_iniciar_compra <= sreg_iniciar_compra(0) & iniciar_compra;
            sreg_confirm <= sreg_confirm(0) & confirm;
            sreg_euro1 <= sreg_euro1(0) & euro1;
            sreg_cent50 <= sreg_cent50(0) & cent50;
            sreg_cent20 <= sreg_cent20(0) & cent20;
            sreg_cent10 <= sreg_cent10(0) & cent10;
        end if;
    end process;

    -- Detectar flanco ascendente (cambio de '0' a '1') en cada señal
    iniciar_compraout <= '1' when sreg_iniciar_compra = "01" else '0';
    confirmout <= '1' when sreg_confirm = "01" else '0';
    euro1out <= '1' when sreg_euro1 = "01" else '0';
    cent50out <= '1' when sreg_cent50 = "01" else '0';
    cent20out <= '1' when sreg_cent20 = "01" else '0';
    cent10out <= '1' when sreg_cent10 = "01" else '0';

end behavioral;





