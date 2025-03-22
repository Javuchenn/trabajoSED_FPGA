library IEEE;
use IEEE.std_logic_1164.all;

entity edgedtctr_tb is
end edgedtctr_tb;

architecture tb of edgedtctr_tb is
    -- Señales locales
    signal CLK : std_logic := '0';
    signal iniciar_compra_in : std_logic := '0';
    signal confirm_in : std_logic := '0';
    signal euro1_in : std_logic := '0';
    signal cent50_in : std_logic := '0';
    signal cent20_in : std_logic := '0';
    signal cent10_in : std_logic := '0';

    signal iniciar_compra_out : std_logic;
    signal confirm_out : std_logic;
    signal euro1_out : std_logic;
    signal cent50_out : std_logic;
    signal cent20_out : std_logic;
    signal cent10_out : std_logic;

    -- Instanciamos el diseño EDGEDTCTR
    component edgedtctr is
        port(
            CLK : in std_logic;
            iniciar_compra_in : in std_logic;
            confirm_in : in std_logic;
            euro1_in : in std_logic;
            cent50_in : in std_logic;
            cent20_in : in std_logic;
            cent10_in : in std_logic;

            iniciar_compra_out : out std_logic;
            confirm_out : out std_logic;
            euro1_out : out std_logic;
            cent50_out : out std_logic;
            cent20_out : out std_logic;
            cent10_out : out std_logic
        );
    end component;

begin
    -- Instanciación del DUT
    UUT: edgedtctr
        port map (
            CLK => CLK,
            iniciar_compra_in => iniciar_compra_in,
            confirm_in => confirm_in,
            euro1_in => euro1_in,
            cent50_in => cent50_in,
            cent20_in => cent20_in,
            cent10_in => cent10_in,
            iniciar_compra_out => iniciar_compra_out,
            confirm_out => confirm_out,
            euro1_out => euro1_out,
            cent50_out => cent50_out,
            cent20_out => cent20_out,
            cent10_out => cent10_out
        );

    -- Generador de reloj
    CLK_PROCESS: process
    begin
        CLK <= '0';
        wait for 5 ns;
        CLK <= '1';
        wait for 5 ns;
    end process;

    -- Aplicación de estímulos
    STIMULI_PROCESS: process
    begin
        -- Iniciar la simulación
        iniciar_compra_in <= '0';
        confirm_in <= '0';
        euro1_in <= '0';
        cent50_in <= '0';
        cent20_in <= '0';
        cent10_in <= '0';
        wait for 20 ns;

        -- Simular flanco ascendente de iniciar_compra
        -- Para la señal "iniciar_compra" vamos a mantenerla en '1' toda la simulación, así comprobaremos que, a pesar de esto, "iniciar_compraout" sólo será '1' durante un ciclo de reloj después del flanco de "iniciar_compraout", lo que significa que el detector de flanco está funcionando correctamente.
        iniciar_compra_in <= '1';
        wait for 20ns;

        -- Simular flanco ascendente de confirm
        confirm_in <= '1';
        wait for 10 ns;
        confirm_in <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de euro1
        euro1_in <= '1';
        wait for 10 ns;
        euro1_in <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent50
        cent50_in <= '1';
        wait for 10 ns;
        cent50_in <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent20
        cent20_in <= '1';
        wait for 10 ns;
        cent20_in <= '0';
        wait for 10 ns;

        -- Simular flanco ascendente de cent10
        cent10_in <= '1';
        wait for 10 ns;
        cent10_in <= '0';
        wait for 50 ns;

        -- Terminar simulación
        assert false
        report "[PASSED]: simulation finished."
        severity failure;
        wait;
    end process;
end tb;

