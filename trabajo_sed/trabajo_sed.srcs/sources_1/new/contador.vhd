
-- Este bloque sirve para contar las monedas que le entran
-- Este bloque le envia a FSM el dinero acumulado (d_acum)

library IEEE;
use IEEE.std_logic_1164.all;

entity contador is
  port(
    clk                            : in std_logic;
    enable_cont                    : in std_logic;
    euro1, cent50, cent20, cent10  : in std_logic;
    d_acum                         : out integer range 0 to 201  -- ud: centimos    
  );
end contador;
  
architecture behavioral of contador is
  signal d_acum_s : integer range 0 to 201 := 0;
begin
  d_acum <= d_acum_s;
  
  CUENTA: process(clk)
  begin
    if rising_edge(clk) then
      if enable_cont = '0' then
        d_acum_s <= 0;
        
      elsif enable_cont = '1' then
        if euro1 = '1' then
          d_acum_s <= d_acum_s + 100;
        elsif cent50 = '1' then
          d_acum_s <= d_acum_s + 50;
        elsif cent20 = '1' then
          d_acum_s <= d_acum_s + 20;
        elsif cent10 = '1' then
          d_acum_s <= d_acum_s + 10;
        end if;
      end if;
    end if;
  end process;
end behavioral;