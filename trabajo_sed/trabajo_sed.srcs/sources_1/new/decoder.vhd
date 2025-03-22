
-- Este bloque sirve para controlar los displays de 7 segmentos de la placa
-- Dependiendo de la habilitacion que se le envie desde FSM, se mostraran diferentes segmentos en los displays


-- PARA UTILIZAR EL TESTBENCH DE ESTE DISEÑO, SE DEBE DE CAMBIAR LA LÍNEA INDICADA ("if counter = 10000 then") POR "if counter = 2 then"
-- PARA USAR EL TESTBENCH DE TOP SE DEBE DE HACER EL MISMO CAMBIO INDICADO

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
  port(
    clk                     : in std_logic; -- Reloj para la multiplexación
    enable_DecoderCont      : in std_logic;
    enable_DecoderFinOK     : in std_logic;
    enable_DecoderFinERROR  : in std_logic;
    d_acum_InDecoder        : in integer range 0 to 201;
    display                 : out std_logic_vector(6 downto 0); -- Bus de segmentos
    digit_control           : out std_logic_vector(7 downto 0)  -- Control de los dígitos
  );
end decoder;

architecture Behavioral of decoder is
  signal state                       : STD_LOGIC_VECTOR(1 downto 0) := "00";  -- Estado para multiplexar displays
  signal counter                     : INTEGER := 0;  -- Contador para dividir la frecuencia del reloj
  signal centenas, decenas, unidades : integer range 0 to 9 := 0; -- Digitos individuales
  
  -- Tabla de decodificación para los dígitos 0-9 y caracteres especiales en 7 segmentos
  function to_7segment(value : integer) return std_logic_vector is
  begin
    case value is
      when 0 => return "0000001";  -- 0
      when 1 => return "1001111";  -- 1
      when 2 => return "0010010";  -- 2
      when 3 => return "0000110";  -- 3
      when 4 => return "1001100";  -- 4
      when 5 => return "0100100";  -- 5
      when 6 => return "0100000";  -- 6
      when 7 => return "0001111";  -- 7
      when 8 => return "0000000";  -- 8
      when 9 => return "0000100";  -- 9
      when 10 => return "0001001";  -- "N"
      when 11 => return "1100010";  -- "o"
      when others => return "1111111";  -- Apagado
    end case;
  end function;

begin

  gestion_estado_multiplexar_displays: process(clk)
  begin
    if rising_edge(clk) then
      counter <= counter + 1;
      if counter = 10000 then  -- Ajusta la velocidad de cambio del display  -- línea que se debe cambiar para usar el testbench
        counter <= 0;
        if state = "10" then
          state <= "00";
        else
          state <= state + 1;
        end if;
      end if;
    end if;
       
      
  end process;
  
  extraccion_digitos: process(clk)
  begin
    -- Extraer centenas, decenas y unidades
    centenas    <= (d_acum_InDecoder / 100) mod 10;
    decenas     <= (d_acum_InDecoder / 10)  mod 10;
    unidades    <= d_acum_InDecoder         mod 10; 
  end process;
    
  
  gestion_displays_activo: process(state)
  begin
    ------------------------------------------------------------------
    -- ESTADO DE e_WaitConfirm (CONTANDO MONEDAS)
    if enable_DecoderCont = '1' then -- se muestra el dinero acumulado
      case state is
        when "00" =>
          display <= to_7segment(centenas);
          digit_control <= "01111111";  -- Activa el display 0
        when "01" =>
          display <= to_7segment(decenas);
          digit_control <= "10111111";  -- Activa el display 1
        when "10" =>
          display <= to_7segment(unidades);
          digit_control <= "11011111";  -- Activa el display 2
        when others =>
          display <= "1111111";
          digit_control <= "11111111";  -- Apaga todos los displays
      end case;
    ------------------------------------------------------------------
    
    -- ESTADO DE e_CompraOK
    elsif enable_DecoderFinOK = '1' then  -- Se muestra "51" ("SI")
      case state is
        when "00" =>
          display <= to_7segment(5);
          digit_control <= "01111111";  -- Activa el display 0
        when "01" =>
          display <= to_7segment(1);
          digit_control <= "10111111";  -- Activa el display 1
        when others =>
          display <= "1111111";
          digit_control <= "11111111";  -- Apaga todos los displays
      end case;

    -- ESTADO DE e_CompraERROR
    elsif enable_DecoderFinERROR = '1' then  -- se muestra "no"
      case state is
        when "00" =>
          display <= to_7segment(10);
          digit_control <= "01111111";  -- Activa el display 0
        when "01" =>
          display <= to_7segment(11);
          digit_control <= "10111111";  -- Activa el display 1
        when others =>
          display <= "1111111";
          digit_control <= "11111111";  -- Apaga todos los displays
      end case;
        
    else  -- Si no hay enable, apagar los displays
      display <= "1111111";
      digit_control <= "11111111";  -- Apaga todos los displays
    end if;
    
  end process;

end Behavioral;