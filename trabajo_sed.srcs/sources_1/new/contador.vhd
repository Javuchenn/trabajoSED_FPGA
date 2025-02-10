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

-- Cuando se está en el estado de e_WaitConfirm, que es cuando el usuario introduce monedas, hay que tener en cuenta todo el rato si se introducen monedas para mantener la cuenta correcta. Por eso esto se gestiona en cada flanco de reloj, para no dejar de gestionarlo.

-- PROBLEMA QUE HABÍA:
  -- ANTES: CUANDO d_acum_s > 100 se resetea a CERO
  -- TAMBIÉN CUANDO d_acum_s > 100, en la FSM se pasa de e_WaitConfirm --> e_DevolviendDinero, deshabilitándose entonces este contador
  -- No está claro qué ocurre primero de esas 2 cosas, y además no se sabe si al volver a e_WaitConfirm, la cuenta va a estar correctamente reseteada.
  -- No se sabe si el RESET de d_acum_s a CERO hace que nunca se entre a e_DevolviendoDinero
  -- PUEDE que se "hagan las dos cosas a la vez" (de forma concurrente) y FUNCIONE TODO CORRECTAMENTE, pero NO lo puedo asegurar.
-- SOLUCIÓN:
  -- Podría añadir en FSM un if que diga que si enable es CERO, que la cuenta se resetee a CERO, Y QUITAR ENTONCES EL " elsif d_acum_s > 100 then d_acum_s <= 0;" de CONTADOR
    -- YA ESTÁ HECHO, ASÍ QUE EL ELSIF MENCIONADO YA ESTÁ BORRADO
  -- Cuando se pase de 100 la cuenta, el estado pasará a e_DevolviendoDinero y enable_cont se hará CERO, lo cual implica que d_acum se reseteará a CERO correctamente
  
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