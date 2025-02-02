library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder is
  port(
    code : in integer range 0 to 201;
    display1, display2, display3 : out std_logic_vector(6 downto 0)
  );
end decoder;

architecture Behavioral of decoder is
begin
  decodificacion: process(code)
  begin
    if code = 0 then
      display1 <= "0000001"; display2 <= "0000001"; display3 <= "0000001"; -- 0 0 0 centimos
    elsif code = 10 then
      display1 <= "0000001"; display2 <= "1001111"; display3 <= "0000001"; -- 0 1 0 centimos
    elsif code = 20 then
      display1 <= "0000001"; display2 <= "0010010"; display3 <= "0000001"; -- 0 2 0 centimos
    elsif code = 30 then
      display1 <= "0000001"; display2 <= "0000110"; display3 <= "0000001"; -- 0 3 0 centimos
    elsif code = 40 then
      display1 <= "0000001"; display2 <= "1001100"; display3 <= "0000001"; -- 0 4 0 centimos
    elsif code = 50 then
      display1 <= "0000001"; display2 <= "0100100"; display3 <= "0000001"; -- 0 5 0 centimos
    elsif code = 60 then
      display1 <= "0000001"; display2 <= "0100000"; display3 <= "0000001"; -- 0 6 0 centimos
    elsif code = 70 then
      display1 <= "0000001"; display2 <= "0001111"; display3 <= "0000001"; -- 0 7 0 centimos
    elsif code = 80 then
      display1 <= "0000001"; display2 <= "0000000"; display3 <= "0000001"; -- 0 8 0 centimos
    elsif code = 90 then
      display1 <= "0000001"; display2 <= "0000100"; display3 <= "0000001"; -- 0 9 0 centimos
    elsif code = 100 then
      display1 <= "1001111"; display2 <= "0000001"; display3 <= "0000001"; -- 1 0 0 centimos
    else
      display1 <= "0100001"; display2 <= "0100001"; display3 <= "0100001"; -- MÁS DE 100 CENTS u otro error (Figura especial en los displays)
    end if;
  end process;
end Behavioral;
