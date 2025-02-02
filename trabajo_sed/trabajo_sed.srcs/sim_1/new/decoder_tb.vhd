library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder_tb is
end entity;

architecture Behavioral of decoder_tb is
    -- Declarar señales para conectar con el DUT (Device Under Test)
    signal code_tb : integer range 0 to 201;
    signal display1_tb, display2_tb, display3_tb : std_logic_vector(6 downto 0);

    -- Instancia del DUT
    component decoder
        port (
            code : in integer range 0 to 201;
            display1, display2, display3 : out std_logic_vector(6 downto 0)
        );
    end component;
    
begin
    -- Instancia del decodificador
    uut: decoder
        port map (
            code => code_tb,
            display1 => display1_tb,
            display2 => display2_tb,
            display3 => display3_tb
        );

    -- Proceso de prueba
    stimulus: process
    begin
        -- Probar todos los valores específicos
        code_tb <= 0;    wait for 10 ns;
        code_tb <= 10;   wait for 10 ns;
        code_tb <= 20;   wait for 10 ns;
        code_tb <= 30;   wait for 10 ns;
        code_tb <= 40;   wait for 10 ns;
        code_tb <= 50;   wait for 10 ns;
        code_tb <= 60;   wait for 10 ns;
        code_tb <= 70;   wait for 10 ns;
        code_tb <= 80;   wait for 10 ns;
        code_tb <= 90;   wait for 10 ns;
        code_tb <= 100;  wait for 10 ns;
        code_tb <= 110;  wait for 10 ns; -- Caso mayor a 100
        
        -- Terminar simulación
        assert false
    	report "[PASSED]: simulation finished."
        severity failure;
    end process;
end architecture;