
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity contador_tb is
end contador_tb;

architecture testbench of contador_tb is

  component contador
    port(
      clk           : in std_logic;
      enable_cont   : in std_logic;
      euro1, cent50, cent20, cent10 : in std_logic;
      d_acum        : out integer range 0 to 201
    );
  end component;

  -- Señales para el test
  signal clk          : std_logic := '0';
  signal enable_cont  : std_logic := '0';
  signal euro1, cent50, cent20, cent10 : std_logic := '0';
  signal d_acum       : integer range 0 to 201;

  -- Clock generation (10 ns period -> 100 MHz)
  constant clk_period : time := 10 ns;

begin

  -- Instanciación del módulo
  UUT: contador
    port map (
      clk           => clk,
      enable_cont   => enable_cont,
      euro1        => euro1,
      cent50       => cent50,
      cent20       => cent20,
      cent10       => cent10,
      d_acum       => d_acum
    );

  -- Proceso para el reloj
  CLK_PROCESS: process
  begin
    while now < 1500 ns loop  -- Simulación hasta 500 ns
      clk <= '0';
      wait for clk_period / 2;
      clk <= '1';
      wait for clk_period / 2;
    end loop;
    wait;
  end process;

  -- Secuencia test
  STIMULUS: process
  begin
    -- Inicialización
    enable_cont <= '0';
    euro1 <= '0'; cent50 <= '0'; cent20 <= '0'; cent10 <= '0';
    wait for 20 ns;

    -- Activar enable_cont
    enable_cont <= '1';
    wait for 20 ns;

    -- Insertar 50 centimos (Total: 50)
    cent50 <= '1';
    wait for clk_period;
    cent50 <= '0';
    wait for 200 ns;  -- 20 ciclos de reloj

    -- Insertar 20 centimos (Total: 70)
    cent20 <= '1';
    wait for clk_period;
    cent20 <= '0';
    wait for 200 ns;
    
    -- Insertar 20 centimos (Total: 90)
    cent20 <= '1';
    wait for clk_period;
    cent20 <= '0';
    wait for 200 ns; 
    
    -- Insertar 10 centimos (Total: 100)
    cent10 <= '1';
    wait for clk_period;
    cent10 <= '0';
    wait for 200 ns; 

    --  Desactivamos enable_cont (Debería resetearse la cuenta a 0)
    enable_cont <= '1';
    wait for clk_period;
    enable_cont <= '0';
    wait for 200 ns; 
    
    -- Activar enable_cont
    enable_cont <= '1';
    wait for 20 ns;
    
    -- Insertar 1 euro (Total: 100)
    euro1 <= '1';
    wait for clk_period;
    euro1 <= '0';
    wait for 200 ns;
    
    -- Intentar meter monedas con enable_cont desactivado
    enable_cont <= '0';
    wait for 100 ns;
    euro1 <= '1';
    wait for 30 ns;
    euro1 <= '0';
    wait for 30 ns;
    cent20 <= '1';
    wait for 30 ns;
    cent20 <= '0';
    wait for 30 ns;
    wait for 200 ns;
    -- Terminar simulación
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
  end process;

end testbench;
