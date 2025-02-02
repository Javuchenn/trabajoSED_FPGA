
-- Ahora mismo si se pasa de 100 céntimos, se reinicia la cuenta a 0
library IEEE;
use IEEE.std_logic_1164.all;

entity FSM is
  port(
    clk                                   : in std_logic;
    RESET                                 : in std_logic;
    euro1                                 : in std_logic;
    cent50, cent20, cent10                : in std_logic;
    cocacola, fanta, nestea               : in std_logic;
    iniciar_compra, confirm, nueva_compra : in std_logic;
    led_cocacola, led_fanta, led_nestea   : out std_logic;
    dinero_acumulado                      : out integer range 0 to 201; -- unidad: centimos
    c_confirm                             : out std_logic; -- COMPRA CONFIRMADA
    error_compra                          : out std_logic
  );
end FSM;

architecture behavioral of FSM is
  type TipoEstado is (e_WaitCoins, e_WaitConfirm, e_CompraOK, e_CompraError);
  signal current_state : TipoEstado := e_WaitCoins;
  signal next_state    : TipoEstado;
  
  signal d_acum : integer range 0 to 201;
  
begin
  dinero_acumulado <= d_acum;
  
  TRANSICIONES_ESTADOS: process(current_state, euro1, cent50, cent20, cent10, confirm, nueva_compra, iniciar_compra)
  begin
    next_state <= current_state;
    if current_state = e_WaitCoins and iniciar_compra = '1' then  
      next_state <= e_WaitConfirm;
    elsif current_state = e_WaitConfirm and confirm = '1' then
      if ((cocacola = '1' and fanta = '0' and nestea = '0') or (cocacola = '0' and fanta = '1' and nestea = '0') or (cocacola = '0' and fanta = '0' and nestea = '1')) and d_acum = 100 then
        next_state <= e_CompraOK;
      else
        next_state <= e_CompraError;
      end if;
    elsif (current_state = e_CompraOK or current_state = e_CompraError) and nueva_compra = '1' then
      next_state <= e_WaitCoins;
    end if;
  end process;
  
  
  -- Cuando se está en el estado de e_WaitConfirm, que es cuando el usuario introduce monedas, hay que tener en cuenta todo el rato si se introducen monedas para mantener la cuenta correcta. Por eso esto se gestiona en cada flanco de reloj, para no dejar de gestionarlo.
  TRATAMIENTO_ESTADOS: process(clk) -- Este proceso se ejecuta en cada flanco de reloj
  begin
    if rising_edge(clk) then
      if current_state = e_WaitCoins then
        d_acum       <=  0 ;
        led_cocacola <= '0';
        led_fanta    <= '0';
        led_nestea   <= '0';
        c_confirm    <= '0';
        error_compra <= '0';
      elsif current_state = e_WaitConfirm then -- Solo se cuentan las monedas en el estado de espera para confirmar
        if euro1 = '1' then
          d_acum <= d_acum + 100;
        elsif cent50 = '1' then
          d_acum <= d_acum + 50;
        elsif cent20 = '1' then
          d_acum <= d_acum + 20;
        elsif cent10 = '1' then
          d_acum <= d_acum + 10;
        elsif d_acum > 100 then
          d_acum <= 0;
        end if;
      elsif current_state = e_CompraOK then
        if cocacola = '1' then
          led_cocacola <= '1';
          c_confirm    <= '1';
        elsif fanta = '1' then
          led_fanta <= '1';
          c_confirm <= '1';
        elsif nestea = '1' then
          led_nestea <= '1';
          c_confirm  <= '1';
        end if;
      elsif current_state = e_CompraError then
        error_compra <= '1';
      end if;   
    end if;
  end process;
  
  MEMORIA_ESTADOS: process (clk, RESET)
  begin
    if RESET = '1' then
      current_state <= e_WaitCoins;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
end process;

end behavioral;