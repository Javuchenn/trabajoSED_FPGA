
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FSM_tb is
end entity;

architecture testbench of FSM_tb is
  signal clk, RESET, cocacola, fanta, nestea, iniciar_compra, confirm, fin_tempor : std_logic := '0';
  signal d_acum_in, d_acum_ToDecoder : integer range 0 to 201 := 0;
  signal led_cocacola, led_fanta, led_nestea, DEVOLUCION_DINERO, error_compra : std_logic;
  signal enable_DecoderFinOK, enable_DecoderFinERROR, enable_DecoderCont, enable_cont, enable_tempor : std_logic;

  -- Instancia del módulo bajo prueba
  component FSM
    port(
      clk, RESET : in std_logic;
      d_acum_in : in integer range 0 to 201;
      cocacola, fanta, nestea : in std_logic;
      iniciar_compra, confirm : in std_logic;
      fin_tempor : in std_logic;
      d_acum_ToDecoder : out integer range 0 to 201;
      led_cocacola, led_fanta, led_nestea : out std_logic;
      DEVOLUCION_DINERO, error_compra : out std_logic;
      enable_DecoderFinOK, enable_DecoderFinERROR, enable_DecoderCont : out std_logic;
      enable_cont, enable_tempor : out std_logic
    );
  end component;

begin
  -- Instancia de la FSM
  UUT: FSM
    port map (
      clk => clk, RESET => RESET, d_acum_in => d_acum_in,
      cocacola => cocacola, fanta => fanta, nestea => nestea,
      iniciar_compra => iniciar_compra, confirm => confirm, fin_tempor => fin_tempor,
      d_acum_ToDecoder => d_acum_ToDecoder,
      led_cocacola => led_cocacola, led_fanta => led_fanta, led_nestea => led_nestea,
      DEVOLUCION_DINERO => DEVOLUCION_DINERO, error_compra => error_compra,
      enable_DecoderFinOK => enable_DecoderFinOK, enable_DecoderFinERROR => enable_DecoderFinERROR, enable_DecoderCont => enable_DecoderCont,
      enable_cont => enable_cont, enable_tempor => enable_tempor
    );

  -- Generación de reloj
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
    -- Reset inicial
    RESET <= '0';
    wait for 50 ns;
    RESET <= '1';
    wait for 20 ns;
    
    -- CASO 1: COMPRA EFECTUADA CORRECTAMENTE  
      iniciar_compra <= '1';  -- e_Reposo --> e_WaitConfirm
      wait for 100 ns;
      iniciar_compra <= '0';
      wait for 100 ns;
    
      cocacola <= '1';   -- elijo bebida
      d_acum_in <= 100;  -- introduzco dinero suficiente
      wait for 80 ns;
      confirm <= '1';    -- e_Reposo --> e_CompraOK
      wait for 80 ns;
      confirm <= '0';
      wait for 80 ns;
      fin_tempor <= '1'; -- e_CompraOK --> e_Reposo
      wait for 50 ns;
      fin_tempor <= '0';
      d_acum_in <= 0;
      wait for 150 ns; 
      cocacola <= '0';
      
      
    -- CASO 2: SIMULACIÓN DE DEVOLUCIÓN DE DINERO
      iniciar_compra <= '1';  -- e_Reposo --> e_WaitConfirm
      wait for 100 ns;
      d_acum_in <= 120;       -- Introduzco dinero pero me paso de 100 centimos (e_WaitConfirm --> e_DevolviendoDiner100
      wait for 150 ns;
      iniciar_compra <= '0';
      d_acum_in <= 0;      
      wait for 200 ns;
      fin_tempor <= '1'; -- Marca el fin de la devolución (e_DevolviendoDinero --> e_WaitConfirm)
      wait for 80 ns;
      fin_tempor <= '0';
    
      wait for 80 ns;
      RESET <= '0';  -- RESETEAMOS PARA PROBAR EL CASO 3 (Forzamos volver a e_reposo)
      wait for 40 ns;
      RESET <= '1';
      wait for 150 ns;
      
    
    
    -- CASO 3: ERROR EN LA COMPRA 
      iniciar_compra <= '1';  -- e_Reposo --> e_WaitConfirm
      wait for 100 ns;
      iniciar_compra <= '0';
      wait for 100 ns;
      fanta <= '1';     -- elijo bebida
      d_acum_in <= 80;  -- introduzco dinero (no llego a 100 centimos)
      wait for 100 ns;
      confirm <= '1';   -- e_Reposo --> e_CompraError (no hay dinero suficiente)
      wait for 100 ns;
      confirm <= '0';
      wait for 50 ns;
      fin_tempor <= '1'; -- e_CompraError --> e_Reposo
      wait for 50 ns;
      fin_tempor <= '0';
      wait for 150 ns; 
      fanta <= '0';
      
    
     -- Terminar simulación
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
    wait;
    
  end process;

end testbench;