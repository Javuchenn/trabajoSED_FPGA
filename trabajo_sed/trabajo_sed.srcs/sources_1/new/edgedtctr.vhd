
-- Este bloque sirve para detectar los flancos en las entradas

library IEEE;
use IEEE.std_logic_1164.all;

entity edgedtctr is 
port(
    CLK: in std_logic;
    iniciar_compra_in  : in std_logic;
    confirm_in         : in std_logic;
    euro1_in           : in std_logic;
    cent50_in          : in std_logic;
    cent20_in          : in std_logic;
    cent10_in          : in std_logic;

    iniciar_compra_out : out std_logic;
    confirm_out        : out std_logic;
    euro1_out          : out std_logic;
    cent50_out         : out std_logic;
    cent20_out         : out std_logic;
    cent10_out         : out std_logic
);
end edgedtctr;

architecture behavioral of edgedtctr is 
    -- Se definen registros de desplazamiento para cada señal de entrada
    signal sreg_iniciar_compra: std_logic_vector(2 downto 0);
    signal sreg_confirm: std_logic_vector(2 downto 0);
    signal sreg_euro1: std_logic_vector(2 downto 0);
    signal sreg_cent50: std_logic_vector(2 downto 0);
    signal sreg_cent20: std_logic_vector(2 downto 0);
    signal sreg_cent10: std_logic_vector(2 downto 0);

begin 
    process(CLK)
    begin
        if rising_edge(CLK) then
            sreg_iniciar_compra <= sreg_iniciar_compra(1 downto 0) & iniciar_compra_in;
            sreg_confirm <= sreg_confirm(1 downto 0) & confirm_in;
            sreg_euro1 <= sreg_euro1(1 downto 0) & euro1_in;
            sreg_cent50 <= sreg_cent50(1 downto 0) & cent50_in;
            sreg_cent20 <= sreg_cent20(1 downto 0) & cent20_in;
            sreg_cent10 <= sreg_cent10(1 downto 0) & cent10_in;
        end if;
    end process;

    with sreg_iniciar_compra select
      iniciar_compra_out <= '1' when "100", '0' when others;
      
    with sreg_confirm select
      confirm_out <= '1' when "100", '0' when others;  
      
    with sreg_euro1 select
      euro1_out <= '1' when "100", '0' when others;
      
    with sreg_cent50 select
      cent50_out <= '1' when "100", '0' when others;
      
    with sreg_cent20 select
      cent20_out <= '1' when "100", '0' when others;
      
    with sreg_cent10 select
      cent10_out <= '1' when "100", '0' when others;
      
end behavioral;