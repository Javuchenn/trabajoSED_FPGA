
library IEEE;
use IEEE.std_logic_1164.all;

entity FSM is
  port(
    clk                                                             : in std_logic;
    RESET                                                           : in std_logic;
    d_acum_in                                                       : in integer range 0 to 201; -- ud: centimos
    cocacola, fanta, nestea                                         : in std_logic;
    iniciar_compra, confirm                                         : in std_logic;
    fin_tempor                                                      : in std_logic;
    d_acum_ToDecoder                                                : out integer range 0 to 201; -- ud: centimos
    led_cocacola, led_fanta, led_nestea                             : out std_logic;
    DEVOLUCION_DINERO                                               : out std_logic;
    error_compra                                                    : out std_logic;
    enable_DecoderFinOK, enable_DecoderFinERROR, enable_DecoderCont : out std_logic;
    enable_cont, enable_tempor : out std_logic
  );
end entity;

architecture behavioral of FSM is
  type TipoEstado is (e_Reposo, e_WaitConfirm, e_DevolviendoDinero, e_CompraOK, e_CompraError);
  signal current_state : TipoEstado := e_Reposo;
  signal next_state    : TipoEstado;
  
begin

  d_acum_ToDecoder <= d_acum_in; -- Para trasladar la información del dinero acumulado al decoder (bloque ajeno a este)
  
  TRANSICIONES_ESTADOS: process(current_state, confirm, iniciar_compra, d_acum_in, fin_tempor) -- Añado d_acum_in a la lista de sensibilidad para e_WaitConfirm --> e_DevolviendoDinero
  begin
    next_state <= current_state;
    if current_state = e_Reposo and iniciar_compra = '1' then  
      next_state <= e_WaitConfirm;          -- e_Reposo --> e_WaitConfirm
      
    elsif current_state = e_WaitConfirm then
      if confirm = '1' then
        if ((cocacola = '1' and fanta = '0' and nestea = '0') or (cocacola = '0' and fanta = '1' and nestea = '0') or (cocacola = '0' and fanta = '0' and nestea = '1')) and d_acum_in = 100 then
          next_state <= e_CompraOK;                 -- e_WaitConfirm --> e_CompraOK
        else
          next_state <= e_CompraError;              -- e_WaitConfirm --> e_CompraError
        end if;
      elsif d_acum_in > 100 and confirm = '0' then  -- e_WaitConfirm --> e_DevolviendoDinero
        next_state <= e_DevolviendoDinero;
      end if;
      
    elsif current_state = e_DevolviendoDinero and fin_tempor = '1' then -- e_DevolviendoDinero --> e_WaitConfirm
      next_state <= e_WaitConfirm;
      
    elsif (current_state = e_CompraOK or current_state = e_CompraError) and fin_tempor = '1' then -- e_CompraOK, e_CompraError --> e_Reposo
      next_state <= e_Reposo;
      
    end if;
  end process;


  TRATAMIENTO_ESTADOS: process(clk)
  begin
    if rising_edge(clk) then
      if current_state = e_Reposo then
        led_cocacola    <= '0';
        led_fanta       <= '0';
        led_nestea      <= '0';
        error_compra    <= '0';
      end if;
      
      if current_state = e_DevolviendoDinero then
        DEVOLUCION_DINERO <= '1';
      else
        DEVOLUCION_DINERO <= '0';   
      end if;
        
      
      if current_state = e_CompraOK then 
        enable_DecoderFinOK <= '1';
        if cocacola = '1' then
          led_cocacola <= '1';
        elsif fanta = '1' then
          led_fanta <= '1';
        elsif nestea = '1' then
          led_nestea <= '1';
        end if;
      else
        enable_DecoderFinOK <= '0';
      end if;
      
      if current_state = e_CompraError then
        error_compra <= '1';
        enable_DecoderFinERROR <= '1';
      else
        enable_DecoderFinERROR <= '0';
      end if; 
         
      if current_state = e_WaitConfirm then -- Solo se cuentan las monedas en el estado de espera para confirmar
        enable_cont <= '1'; enable_DecoderCont <= '1';
      else
        enable_cont <= '0'; enable_DecoderCont <= '0';
      end if;
      
    end if;
    
  end process;
  
  GESTION_TEMPORIZADOR: process(clk)
  begin
    if rising_edge(clk) then
      if current_state = e_CompraOK or current_state = e_CompraERROR or current_state = e_DevolviendoDinero then
        enable_tempor <= '1';
      else
        enable_tempor <= '0';
      end if;
    end if; 
  end process;
  
  MEMORIA_ESTADOS: process (clk, RESET)
  begin
    if RESET = '1' then
      current_state <= e_Reposo;
    elsif rising_edge(clk) then
      current_state <= next_state;
    end if;
  end process;
  
end behavioral;