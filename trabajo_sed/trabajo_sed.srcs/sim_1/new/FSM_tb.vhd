
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM_tb is
end FSM_tb;

architecture tb of FSM_tb is
  signal clk, reset, euro1, cent50, cent20, cent10 : std_logic := '0';
  signal cocacola, fanta, nestea, iniciar_compra, confirm, nueva_compra : std_logic := '0';
  signal led_cocacola, led_fanta, led_nestea, c_confirm, error_compra : std_logic;
  signal dinero_acumulado : integer range 0 to 201;

  -- Instancia del DUT (Device Under Test)
  component FSM
    port(
      clk, reset, euro1, cent50, cent20, cent10, cocacola, fanta, nestea, iniciar_compra, confirm, nueva_compra : in std_logic;
      led_cocacola, led_fanta, led_nestea, c_confirm, error_compra : out std_logic;
      dinero_acumulado : out integer range 0 to 201
    );
  end component;

begin
  -- Instanciamos el módulo bajo prueba (DUT)
  UUT: FSM
    port map (
      clk => clk, reset => reset, euro1 => euro1, cent50 => cent50, cent20 => cent20, cent10 => cent10,
      cocacola => cocacola, fanta => fanta, nestea => nestea, confirm => confirm, iniciar_compra => iniciar_compra, nueva_compra => nueva_compra,
      led_cocacola => led_cocacola, led_fanta => led_fanta, led_nestea => led_nestea,
      c_confirm => c_confirm, error_compra => error_compra, dinero_acumulado => dinero_acumulado
    );

  -- Generación del reloj
  process
  begin
    while true loop
      clk <= '0'; wait for 10 ns;
      clk <= '1'; wait for 10 ns;
    end loop;
  end process;

  -- Proceso de prueba
  process
  begin
    -- Reset del sistema
    reset <= '1';
    wait for 50 ns;
    reset <= '0'; wait for 20 ns;
    
    -- Iniciamos primera compra
    iniciar_compra <= '1'; wait for 30 ns; iniciar_compra <= '0';
    
    -- Insertamos monedas
    euro1 <= '1'; wait for 50 ns; euro1 <= '0'; wait for 50 ns;
    cent50 <= '1'; wait for 50 ns; cent50 <= '0'; wait for 50 ns;

    -- Seleccionamos bebida y confirmamos compra
    cocacola <= '1'; wait for 40 ns;
    confirm <= '1'; wait for 40 ns; confirm <= '0'; cocacola <= '0';

    -- Esperamos la respuesta
    wait for 50 ns;

    -- Nueva compra (segunda compra)
    nueva_compra <= '1'; wait for 40 ns; nueva_compra <= '0'; wait for 40 ns;
    
    -- Iniciamos segunda compra
    iniciar_compra <= '1'; wait for 30 ns; iniciar_compra <= '0';
    
    -- Insertamos más monedas
    cent20 <= '1'; wait for 50 ns; cent20 <= '0'; wait for 50 ns;
    cent20 <= '1'; wait for 50 ns; cent20 <= '0'; wait for 50 ns;
    cent20 <= '1'; wait for 50 ns; cent20 <= '0'; wait for 50 ns;
    cent20 <= '1'; wait for 50 ns; cent20 <= '0'; wait for 50 ns;
    cent20 <= '1'; wait for 50 ns; cent20 <= '0';
    
    -- Seleccionamos bebida y confirmamos compra
    fanta <= '1'; wait for 20 ns;
    confirm <= '1'; wait for 50 ns; confirm <= '0'; fanta <= '0';

    -- Terminar simulación
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
  end process;

end tb;
