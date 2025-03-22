
-- Prueba de los tres principales casos:
  -- compra exitosa
  -- devolución de dinero
  -- error en la compra

-- ESTE TESTBENCH FUNCIONA CUANDO EN EL DISEÑO DE "timer", LA CUENTA MÁXIMA ES 5 EN VEZ DE 500_000_000
-- PARA QUE FUNCIONE, TAMBIÉN EN EL DISEÑO DE "decoder", SE DEBE DE CAMBIAR LA LÍNEA INDICADA ("if counter = 10000 then") POR "if counter = 2 then"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tb is
end top_tb;

architecture tb of top_tb is

  -- Declaración de componentes de unit under test (UUT)
  component top
    port(
      cocacola      : in std_logic;
      fanta         : in std_logic;
      nestea        : in std_logic;
      iniciar_compra : in std_logic;
      confirm        : in std_logic;
      euro1          : in std_logic;
      cent50         : in std_logic;
      cent20         : in std_logic;
      cent10         : in std_logic;
      CLK            : in std_logic;
      RESET          : in std_logic;
            
      display           : out std_logic_vector(6 downto 0);
      digit_control     : out std_logic_vector(7 downto 0);
      DEVOLUCION_DINERO : out std_logic;
      led_cocacola   : out std_logic;
      led_fanta      : out std_logic;
      led_nestea     : out std_logic;
      error_compra   : out std_logic;
      led_reposo, led_WaitConfirm : out std_logic  -- DEBUG
    );
  end component;

  -- Señales para conectar el UUT.
  signal cocacola       : std_logic := '0';
  signal fanta          : std_logic := '0';
  signal nestea         : std_logic := '0';
  signal iniciar_compra : std_logic := '0';
  signal confirm        : std_logic := '0';
  signal euro1          : std_logic := '0';
  signal cent50         : std_logic := '0';
  signal cent20         : std_logic := '0';
  signal cent10         : std_logic := '0';
  signal CLK            : std_logic := '0';
  signal RESET          : std_logic := '0';
    
  signal display           : std_logic_vector(6 downto 0);
  signal digit_control     : std_logic_vector(7 downto 0);
  signal DEVOLUCION_DINERO : std_logic;
  signal led_cocacola      : std_logic;
  signal led_fanta         : std_logic;
  signal led_nestea        : std_logic;
  signal error_compra      : std_logic;
  signal led_reposo, led_WaitConfirm : std_logic;  -- DEBUG

  -- Periodo del reloj
  constant CLK_PERIOD : time := 5 ns;

begin
  -- Instanciar UUT
  uut: top port map (
    cocacola => cocacola,
    fanta => fanta,
    nestea => nestea,
    iniciar_compra => iniciar_compra,
    confirm => confirm,
    euro1 => euro1,
    cent50 => cent50,
    cent20 => cent20,
    cent10 => cent10,
    CLK => CLK,
    RESET => RESET,
    display => display,
    digit_control => digit_control,
    DEVOLUCION_DINERO => DEVOLUCION_DINERO,
    led_cocacola => led_cocacola,
    led_fanta => led_fanta,
    led_nestea => led_nestea,
    error_compra => error_compra,
    led_reposo => led_reposo, 
    led_WaitConfirm => led_WaitConfirm
  );

  -- Generacion de reloj
  clk_process : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD / 2;
    CLK <= '1';
    wait for CLK_PERIOD / 2;
  end process;

  -- Stimulus process
  stimulus_process : process
  begin
    -- Reset inicial
    RESET <= '0';
    wait for 20 ns;
    RESET <= '1';
    wait for 20 ns;
    
    -- Inputs valor inicial
    euro1  <= '0';
    cent50 <= '0';
    cent20 <= '0';
    cent10 <= '0';
  
  wait for 50 ns;
  -- Caso 1: Compra exitosa (exactamente 1 euro = 100 centimos)
    cocacola <= '1';
    -- Insertar 1 euro y confirmar
    iniciar_compra <= '1';
    wait for 10 ns;
    iniciar_compra <= '0';
    wait for 50 ns;
    euro1 <= '1';   -- Insertar 1 euro
    wait for 10 ns;
    euro1 <= '0';
    wait for 30 ns;
    confirm <= '1';   -- Confirmar
    wait for 10 ns;
    confirm <= '0';
        
    -- Esperar a FSM para procesar
    wait for 150 ns;
    cocacola <= '0';
        
  -- Caso 2: Devolucion de dinero (mas de 100 centimos)
    fanta <= '1';
    -- Insertar mas de 100 centimos (1 euro + 50 centimos)
    iniciar_compra <= '1';
    wait for 10 ns;
    iniciar_compra <= '0';
    wait for 50 ns;
    euro1 <= '1';   -- Insertamos 1 euro
    wait for 10 ns;
    euro1 <= '0';
    wait for 10 ns;
    cent50 <= '1';  -- Insertamos 50 centimos
    wait for 10 ns;
    cent50 <= '0';
    wait for 10 ns;

    -- Esperar a FSM para procesar
    wait for 150 ns;
    fanta <= '0';

  -- Caso 3: Error en la compra (menos de 100 centimos)
    nestea <= '1';
    -- Insertar menos de 1 euro y confirmar
    -- no hace falta iniciar compra porque del estado de "e_DevolviendoDinero" se pasa a "e_WaitConfirm" en vez de a "e_Reposo"
    wait for 10 ns;
    iniciar_compra <= '0';
    wait for 50 ns;
    cent50 <= '1';
    wait for 10 ns;
    cent50 <= '0';
    wait for 10 ns;
    cent20 <= '1';
    wait for 10 ns;
    cent20 <= '0';
    wait for 30 ns;
    confirm <= '1';   -- Confirmar
    wait for 10 ns;
    confirm <= '0';

    -- Esperar a FSM para procesar
    wait for 150 ns;
    nestea <= '0';
    wait for 30 ns;

    -- Terminar simulacion
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
  end process;

end tb;

 
  
  