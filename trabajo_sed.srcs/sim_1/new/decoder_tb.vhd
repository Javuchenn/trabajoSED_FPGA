library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity decoder_tb is
end decoder_tb;

architecture tb of decoder_tb is
  signal enable_DecoderCont           : std_logic := '0';
  signal enable_DecoderFinOK          : std_logic := '0';
  signal enable_DecoderFinERROR       : std_logic := '0';
  signal d_acum_InDecoder             : integer range 0 to 201 := 0;
  signal display1, display2, display3 : std_logic_vector(6 downto 0);

  component decoder
    port(
      enable_DecoderCont           : in std_logic;
      enable_DecoderFinOK          : in std_logic;
      enable_DecoderFinERROR       : in std_logic;
      d_acum_InDecoder             : in integer range 0 to 201;
      display1, display2, display3 : out std_logic_vector(6 downto 0)
    );
  end component;

begin
  uut: decoder
    port map(
      enable_DecoderCont           => enable_DecoderCont,
      enable_DecoderFinOK          => enable_DecoderFinOK,
      enable_DecoderFinERROR       => enable_DecoderFinERROR,
      d_acum_InDecoder             => d_acum_InDecoder,
      display1                     => display1,
      display2                     => display2,
      display3                     => display3
    );

  stim_proc: process
  begin
    -- Test caso 1: Test enable_DecoderCont con valores ded_acum_InDecoder
    enable_DecoderCont <= '1';
    enable_DecoderFinOK <= '0';
    enable_DecoderFinERROR <= '0';
        
    -- Test para valores específicos de d_acum_InDecoder
    d_acum_InDecoder <= 0;
    wait for 10 ns;
        
    d_acum_InDecoder <= 10;
    wait for 10 ns;
        
    d_acum_InDecoder <= 20;
    wait for 10 ns;
        
    d_acum_InDecoder <= 30;
    wait for 10 ns;
        
    d_acum_InDecoder <= 100;
    wait for 10 ns;
        
    -- Test caso 2: Test enable_DecoderFinOK
    enable_DecoderCont <= '0';
    enable_DecoderFinOK <= '1';
    enable_DecoderFinERROR <= '0';
    wait for 10 ns;
        
    -- Test caso 3: Test enable_DecoderFinERROR
    enable_DecoderFinOK <= '0';
    enable_DecoderFinERROR <= '1';
    wait for 10 ns;
        
    -- Test caso 4: Todas las señales reset
    enable_DecoderCont <= '0';
    enable_DecoderFinOK <= '0';
    enable_DecoderFinERROR <= '0';
    d_acum_InDecoder <= 0;
    wait for 10 ns;
        
    -- Terminar simulación
    assert false
    report "[PASSED]: simulation finished."
    severity failure;
    wait;
  end process;
end tb;
