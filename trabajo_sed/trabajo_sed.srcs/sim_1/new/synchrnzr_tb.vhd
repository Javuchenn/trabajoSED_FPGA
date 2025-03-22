library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity synchrnzr_tb is
end synchrnzr_tb;

architecture TB of synchrnzr_tb is

    -- Declaracion de componentes
    component synchrnzr
        port (
            CLK: in std_logic;
            iniciar_compra_in: in std_logic;
            confirm_in: in std_logic;
            euro1_in: in std_logic;
            cent50_in: in std_logic;
            cent20_in: in std_logic;
            cent10_in: in std_logic;
            iniciar_compra_out: out std_logic;
            confirm_out: out std_logic;
            euro1_out: out std_logic;
            cent50_out: out std_logic;
            cent20_out: out std_logic;
            cent10_out: out std_logic
        );
    end component;

    -- Señales para el test
    signal CLK: std_logic := '0';
    signal iniciar_compra_in: std_logic := '0';
    signal confirm_in: std_logic := '0';
    signal euro1_in: std_logic := '0';
    signal cent50_in: std_logic := '0';
    signal cent20_in: std_logic := '0';
    signal cent10_in: std_logic := '0';
    
    signal iniciar_compra_out: std_logic;
    signal confirm_out: std_logic;
    signal euro1_out: std_logic;
    signal cent50_out: std_logic;
    signal cent20_out: std_logic;
    signal cent10_out: std_logic;
    
    -- Reloj
    constant CLK_PERIOD : time := 10 ns;

begin
    -- Instanciacion de synchrnzr
    UUT: synchrnzr port map (
        CLK => CLK,
        iniciar_compra_in => iniciar_compra_in,
        confirm_in => confirm_in,
        euro1_in => euro1_in,
        cent50_in => cent50_in,
        cent20_in => cent20_in,
        cent10_in => cent10_in,
        iniciar_compra_out => iniciar_compra_out,
        confirm_out => confirm_out,
        euro1_out => euro1_out,
        cent50_out => cent50_out,
        cent20_out => cent20_out,
        cent10_out => cent10_out
    );
    
    -- Generacion del reloj
    process
    begin
        while now < 200 ns loop
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
        -- Valores iniciales
        iniciar_compra_in <= '0';
        confirm_in <= '0';
        euro1_in <= '0';
        cent50_in <= '0';
        cent20_in <= '0';
        cent10_in <= '0';
        wait for 20 ns;
        
        -- Aplicamos las señales
        iniciar_compra_in <= '1';
        wait for 20 ns;
        iniciar_compra_in <= '0';
        
        confirm_in <= '1';
        wait for 30 ns;
        confirm_in <= '0';
        
        euro1_in <= '1';
        wait for 3 ns;
        cent50_in <= '1';
        wait for 40 ns;
        euro1_in <= '0';
        cent50_in <= '0';
        
        cent20_in <= '1';
        wait for 3 ns;
        cent10_in <= '1';
        wait for 50 ns;
        cent20_in <= '0';
        cent10_in <= '0';
        
        wait;
    end process;
    
end TB;