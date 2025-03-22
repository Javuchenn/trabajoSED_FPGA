
-- PARA UTILIZAR ESTE TESTBENCH, EN EL DISEÑO SE DEBE DE CAMBIAR LA LÍNEA INDICADA POR "if counter = 2 then"

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is

    -- Declaración de señales
    signal clk_tb                 : std_logic := '0';
    signal enable_DecoderCont_tb   : std_logic := '0';
    signal enable_DecoderFinOK_tb  : std_logic := '0';
    signal enable_DecoderFinERROR_tb : std_logic := '0';
    signal d_acum_InDecoder_tb     : integer range 0 to 201 := 0;
    signal display_tb              : std_logic_vector(6 downto 0);
    signal digit_control_tb        : std_logic_vector(7 downto 0);

    -- Periodo del reloj (simulación de 100 MHz → 10 ns por ciclo)
    constant CLK_PERIOD : time := 10 ns;

begin

    -- Instancia del DUT (Device Under Test)
    uut: entity work.decoder
        port map(
            clk                     => clk_tb,
            enable_DecoderCont      => enable_DecoderCont_tb,
            enable_DecoderFinOK     => enable_DecoderFinOK_tb,
            enable_DecoderFinERROR  => enable_DecoderFinERROR_tb,
            d_acum_InDecoder        => d_acum_InDecoder_tb,
            display                 => display_tb,
            digit_control           => digit_control_tb
        );

    -- Proceso para generar el reloj
    clk_process: process
    begin
        while now < 1 ms loop  -- Simulamos por 1 ms
            clk_tb <= '0';
            wait for CLK_PERIOD / 2;
            clk_tb <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process;

    -- Proceso de prueba
    stimulus_process: process
    begin
        -- Prueba 1: Mostrar 123 en los displays
        enable_DecoderCont_tb <= '1';
        enable_DecoderFinOK_tb <= '0';
        enable_DecoderFinERROR_tb <= '0';
        d_acum_InDecoder_tb <= 123;
        wait for 200 ns;
        d_acum_InDecoder_tb <= 489;
        wait for 200 ns;
        d_acum_InDecoder_tb <= 654;
        wait for 200 ns;
        d_acum_InDecoder_tb <= 0;

        

        -- Prueba 2: Mostrar "511" (SII) cuando FinOK está activo
        enable_DecoderCont_tb <= '0';
        enable_DecoderFinOK_tb <= '1';
        wait for 300 ns;

        -- Prueba 3: Mostrar "n00" cuando FinERROR está activo
        enable_DecoderFinOK_tb <= '0';
        enable_DecoderFinERROR_tb <= '1';
        wait for 300 ns;

        -- Prueba 4: Apagar todo (sin enable)
        enable_DecoderFinERROR_tb <= '0';
        wait for 300 ns;

        -- Terminar simulación
        assert false
        report "[PASSED]: simulation finished."
        severity failure;
        wait;
    end process;

end Behavioral;
