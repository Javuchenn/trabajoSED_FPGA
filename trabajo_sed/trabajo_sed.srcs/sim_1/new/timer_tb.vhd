
-- ESTE TESTBENCH ESTÁ PENSADO PARA CUANDO EN EL DISEÑO, LA CUENTA MÁXIMA ES 50 EN VEZ DE 500_000_000, ASÍ SE PODRÁ VERIFICAR EL COMPORTAMIENTO DEL DISEÑO SIN QUE EL SIMULADOR GENERE UN EXCESO DE DATOS Y DETENGA LA SIMULACIÓN PREMATURAMENTE

library IEEE;
use IEEE.std_logic_1164.all;

entity timer_tb is
end timer_tb;

architecture Behavioral of timer_tb is
  -- Componente a testear
  component timer
    port(
      clk           : in std_logic;
      enable_tempor : in std_logic; 
      fin_tempor    : out std_logic
    );
  end component;

  -- Señales para la prueba
  signal clk           : std_logic := '0';
  signal enable_tempor : std_logic := '0';
  signal fin_tempor    : std_logic;

  -- Constante para el periodo del reloj (50 MHz → 20 ns por ciclo)
  constant CLK_PERIOD : time := 20 ns;

begin
  -- Instanciamos el temporizador
  uut: timer port map (
    clk           => clk,
    enable_tempor => enable_tempor,
    fin_tempor    => fin_tempor
  );

  -- Proceso de generación de reloj
  process
  begin
    while now < 1 ms loop -- Simulamos por 1 ms
      clk <= not clk;
      wait for CLK_PERIOD / 2; -- Divide el período en dos flancos
    end loop;
    wait;
  end process;

  -- Proceso de test
  process
  begin
    -- Inicialización
    enable_tempor <= '0';
    wait for 100 ns; -- Esperamos un poco antes de empezar
    
    -- Activamos enable_tempor
    enable_tempor <= '1';
    
    -- Esperamos a que fin_tempor se active
    wait until fin_tempor = '1';
    wait for 100 ns;
    
    -- Desactivamos enable_tempor (FSM debería resetear el contador)
    enable_tempor <= '0';
    wait for 100 ns;

    -- Terminar simulación
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
    wait;
  end process;

end Behavioral;

