
library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
  port(
    enable_DecoderCont           : in std_logic;
    enable_DecoderFinOK          : in std_logic;
    enable_DecoderFinERROR       : in std_logic;
    d_acum_InDecoder             : in integer range 0 to 201;
    display1, display2, display3 : out std_logic_vector(6 downto 0)
  );
end decoder;

architecture Behavioral of decoder is
begin
  decodificacion: process(enable_DecoderCont, d_acum_InDecoder, enable_DecoderFinOK, enable_DecoderFinERROR)
  begin
    if enable_DecoderCont = '1' then
      if d_acum_InDecoder = 0 then
        display1 <= "0000001"; display2 <= "0000001"; display3 <= "0000001"; -- 0 0 0 centimos
      elsif d_acum_InDecoder = 10 then
        display1 <= "0000001"; display2 <= "1001111"; display3 <= "0000001"; -- 0 1 0 centimos
      elsif d_acum_InDecoder = 20 then
        display1 <= "0000001"; display2 <= "0010010"; display3 <= "0000001"; -- 0 2 0 centimos
      elsif d_acum_InDecoder = 30 then
        display1 <= "0000001"; display2 <= "0000110"; display3 <= "0000001"; -- 0 3 0 centimos
      elsif d_acum_InDecoder = 40 then
        display1 <= "0000001"; display2 <= "1001100"; display3 <= "0000001"; -- 0 4 0 centimos
      elsif d_acum_InDecoder = 50 then
        display1 <= "0000001"; display2 <= "0100100"; display3 <= "0000001"; -- 0 5 0 centimos
      elsif d_acum_InDecoder = 60 then
        display1 <= "0000001"; display2 <= "0100000"; display3 <= "0000001"; -- 0 6 0 centimos
      elsif d_acum_InDecoder = 70 then
        display1 <= "0000001"; display2 <= "0001111"; display3 <= "0000001"; -- 0 7 0 centimos
      elsif d_acum_InDecoder = 80 then
        display1 <= "0000001"; display2 <= "0000000"; display3 <= "0000001"; -- 0 8 0 centimos
      elsif d_acum_InDecoder = 90 then
        display1 <= "0000001"; display2 <= "0000100"; display3 <= "0000001"; -- 0 9 0 centimos
      elsif d_acum_InDecoder = 100 then
        display1 <= "1001111"; display2 <= "0000001"; display3 <= "0000001"; -- 1 0 0 centimos
      else -- este ultimo else, realmente, no hace falta, porque el dinero nunca se va a pasar de 100 gracias a FSM y no va a haber ningun otro valor de d_acumInDecoder
        display1 <= "0100001"; display2 <= "0100001"; display3 <= "0100001"; -- ERROR (Figura especial en los displays)
      end if;
      
    elsif enable_DecoderFinOK = '1' then  -- Escribimos "SII" en los displays (511)
      display1 <= "0100100"; display2 <= "1001111"; display3 <= "1001111";

    elsif enable_DecoderFinERROR = '1' then  -- Escribimos NOO (un cero sin el palo de abajo y otros dos ceros normales)
      display1 <= "0001001"; display2 <= "0000001"; display3 <= "0000001";
      
    else  -- si no hay ningun enable, apago los displays
      display1 <= "1111111"; display2 <= "1111111"; display3 <= "1111111";

    end if;
 
  end process;
end Behavioral;