----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.02.2025 20:57:12
-- Design Name: 
-- Module Name: synchrnzr_tb - Behavioral
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
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity SYNCHRNZR_TB is
end SYNCHRNZR_TB;

architecture TB of SYNCHRNZR_TB is

    -- Component declaration
    component SYNCHRNZR
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
    end component;

    -- Signals for test
    signal CLK: std_logic := '0';
    signal iniciar_compra: std_logic := '0';
    signal confirm: std_logic := '0';
    signal euro1: std_logic := '0';
    signal cent50: std_logic := '0';
    signal cent20: std_logic := '0';
    signal cent10: std_logic := '0';
    
    signal iniciar_compraout: std_logic;
    signal confirmout: std_logic;
    signal euro1out: std_logic;
    signal cent50out: std_logic;
    signal cent20out: std_logic;
    signal cent10out: std_logic;
    
    -- Clock process
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instantiate the Synchronizer
    UUT: SYNCHRNZR port map (
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
    
    -- Clock Generation
    process
    begin
        while now < 200 ns loop -- Simulate for 200ns
            CLK <= '0';
            wait for CLK_PERIOD / 2;
            CLK <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;
    
    -- Stimulus process
    process
    begin
        -- Initial values
        iniciar_compra <= '0';
        confirm <= '0';
        euro1 <= '0';
        cent50 <= '0';
        cent20 <= '0';
        cent10 <= '0';
        wait for 20 ns;
        
        -- Apply test signals
        iniciar_compra <= '1';
        wait for 20 ns;
        iniciar_compra <= '0';
        
        confirm <= '1';
        wait for 30 ns;
        confirm <= '0';
        
        euro1 <= '1';
        cent50 <= '1';
        wait for 40 ns;
        euro1 <= '0';
        cent50 <= '0';
        
        cent20 <= '1';
        cent10 <= '1';
        wait for 50 ns;
        cent20 <= '0';
        cent10 <= '0';
        
        wait;
    end process;
    
end TB;












