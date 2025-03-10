----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2025 21:37:52
-- Design Name: 
-- Module Name: EDGEDTCTR_TB - Behavioral
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

entity EDGEDTCTR_TB is
end EDGEDTCTR_TB;

architecture tb of EDGEDTCTR_TB is
    -- Señales locales
    signal CLK : std_logic := '0';
    signal iniciar_compra : std_logic := '0';
    signal confirm : std_logic := '0';
    signal euro1 : std_logic := '0';
    signal cent50 : std_logic := '0';
    signal cent20 : std_logic := '0';
    signal cent10 : std_logic := '0';

    signal iniciar_compraout : std_logic;
    signal confirmout : std_logic;
    signal euro1out : std_logic;
    signal cent50out : std_logic;
    signal cent20out : std_logic;
    signal cent10out : std_logic;

    -- Instanciamos el diseño EDGEDTCTR
    component EDGEDTCTR is
        port(
            CLK : in std_logic;
            iniciar_compra : in std_logic;
            confirm : in std_logic;
            euro1 : in std_logic;
            cent50 : in std_logic;
            cent20 : in std_logic;
            cent10 : in std_logic;

            iniciar_compraout : out std_logic;
            confirmout : out std_logic;
            euro1out : out std_logic;
            cent50out : out std_logic;
            cent20out : out std_logic;
            cent10out : out std_logic
        );
    end component;

begin
    -- Instanciación del DUT
    UUT: EDGEDTCTR
        port map (
            CLK => CLK,
            iniciar_compra => iniciar_compra,
            confirm => confirm,
            euro1 => euro1,
            cent50 => cent50,
            cent20 => cent20,
            cent10 => cent10,
            iniciar_compraout => iniciar_compraout,
            confirmout => confirmout,
            euro1out => euro1out,
            cent50out => cent50out,
            cent20out => cent20out,
            cent10out => cent10out
        );

    -- Generador de reloj
    CLK_PROCESS: process
    begin
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;

    -- Aplicación de estímulos
    STIMULI_PROCESS: process
    begin
        -- Iniciar la simulación
        iniciar_compra <= '0';
        confirm <= '0';
        euro1 <= '0';
        cent50 <= '0';
        cent20 <= '0';
        cent10 <= '0';
        wait for 20 ns;

        -- Simular flanco ascendente de iniciar_compra
        -- Para la señal "iniciar_compra" vamos a mantenerla en '1' toda la simulación, así comprobaremos que, a pesar de esto, "iniciar_compraout" sólo será '1' durante un ciclo de reloj después del flanco de "iniciar_compraout", lo que significa que el detector de flanco está funcionando correctamente.
        iniciar_compra <= '1';
        wait for 20ns;

        -- Simular flanco ascendente de confirm
        confirm <= '1';
        wait for 10 ns;
        confirm <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de euro1
        euro1 <= '1';
        wait for 10 ns;
        euro1 <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent50
        cent50 <= '1';
        wait for 10 ns;
        cent50 <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent20
        cent20 <= '1';
        wait for 10 ns;
        cent20 <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent10
        cent10 <= '1';
        wait for 10 ns;
        cent10 <= '0';
        wait for 10 ns;

        -- Terminar simulación
        assert false
        report "[PASSED]: simulation finished."
        severity failure;
        wait;
    end process;
end tb;
