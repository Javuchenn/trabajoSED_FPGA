
-- PARA PROBAR EL TESTBENCH DE ESTE DISEÑO, CAMBIAR LA CUENTA MÁXIMA 150_000_000 por 50

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity timer is
  port(
    clk           : in std_logic;
    enable_tempor : in std_logic; 
    fin_tempor    : out std_logic  -- Señal de tiempo cumplido
  );
end timer;

-- UNA VEZ SE ACTIVE FIN_TEMPOR, SE CAMBIARÁ DE ESTADO EN LA FSM, LO QUE HARÁ QUE ENABLE_TEMPOR SE HAGA CERO Y POR TANTO COUNTER Y FIN_TEMPOR SE RESETEEN A CERO

architecture Behavioral of timer is
  signal counter : integer range 0 to 150_000_000 := 0; -- Contador para 3 segundos si clk = 50 MHz
begin
  process(clk)
  begin

    if rising_edge(clk) then
  
      if enable_tempor = '0' then
        counter    <=  0 ;
        fin_tempor <= '0';
      
      elsif enable_tempor = '1' then 
        if counter = 150_000_000 then  -- 150 millones de ciclos (3 seg si clk = 50 MHz)
          fin_tempor <= '1';           -- Activa la señal cuando el contador llega al límite
        else
          counter <= counter + 1;
        end if;   
      end if;
      
    end if;
    
  end process;
end Behavioral;