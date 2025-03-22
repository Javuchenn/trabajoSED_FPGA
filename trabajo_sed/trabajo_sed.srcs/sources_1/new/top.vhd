
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top is
  port(
    cocacola       : in std_logic;
    fanta          : in std_logic;
    nestea         : in std_logic;
    iniciar_compra : in std_logic;
    confirm        : in std_logic;
    euro1          : in std_logic;
    cent50         : in std_logic;
    cent20         : in std_logic;
    cent10         : in std_logic;
    CLK            : in std_logic;
    RESET          : in std_logic;
    
    display           : out std_logic_vector(6 downto 0);
    digit_control     : out std_logic_vector(7 downto 0);
    DEVOLUCION_DINERO : out std_logic;
    led_cocacola      : out std_logic;
    led_fanta         : out std_logic;
    led_nestea        : out std_logic;
    error_compra      : out std_logic;
    led_reposo, led_WaitConfirm: out std_logic  -- DEBUG
  );
end top;

architecture behavioral of top is
  --- DECLARACIÓN DE SEÑALES ---
    -- NOTACION:
      -- se: de synchrnzr a edge_detector
      -- ef: de edge_detector a FSM
      -- ec: de edge_detector a contador
      -- fc: de FSM a contador
      -- ft: de FSM a timer
      -- fd: de FSM a decoder
      -- tf: de timer a FSM
      
    -- SYNCHRNZR --> EDGE_DTCTR
    signal iniciar_compra_se : std_logic;
    signal confirm_se        : std_logic;
    signal euro1_se          : std_logic;
    signal cent50_se         : std_logic;
    signal cent20_se         : std_logic;
    signal cent10_se         : std_logic;
    
    -- EDGE_DTCTR --> FSM
    signal iniciar_compra_ef : std_logic;
    signal confirm_ef        : std_logic;

    -- EDGE_DTCTR --> CONTADOR
    signal euro1_ec          : std_logic;
    signal cent50_ec         : std_logic;
    signal cent20_ec         : std_logic;
    signal cent10_ec         : std_logic;
    
    -- FSM --> CONTADOR
    signal enable_cont_fc    : std_logic;
    
    -- FSM --> TIMER
    signal enable_tempor_ft  : std_logic;
    
    -- FSM --> DECODER
    signal enable_DecoderFinOK_fd    : std_logic;
    signal enable_DecoderFinERROR_fd : std_logic;
    signal enable_DecoderCont_fd     : std_logic;
    signal d_acum_fd                 : integer range 0 to 201;

    -- TIMER --> FSM
    signal fin_tempor_tf             : std_logic;
  
    -- CONTADOR --> FSM
    signal d_acum_cf                 : integer range 0 to 201;
    
  --- DECLARACIÓN DE COMPONENTES ---
    COMPONENT synchrnzr
      port(
        CLK                : in std_logic;
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
    END COMPONENT;
    
    COMPONENT edgedtctr
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
    END COMPONENT;

    COMPONENT FSM
      port(
        clk                                                             : in std_logic;
        RESET                                                           : in std_logic;
        d_acum_in                                                       : in integer range 0 to 201;
        cocacola, fanta, nestea                                         : in std_logic;
        iniciar_compra, confirm                                         : in std_logic;
        fin_tempor                                                      : in std_logic;
        d_acum_ToDecoder                                                : out integer range 0 to 201;
        led_cocacola, led_fanta, led_nestea                             : out std_logic;
        DEVOLUCION_DINERO                                               : out std_logic;
        error_compra                                                    : out std_logic;
        enable_DecoderFinOK, enable_DecoderFinERROR, enable_DecoderCont : out std_logic;
        enable_cont, enable_tempor                                      : out std_logic;
        led_reposo, led_WaitConfirm                                     : out std_logic  -- DEBUG
      );
    END COMPONENT;

    COMPONENT contador
      port(
        clk                            : in std_logic;
        enable_cont                    : in std_logic;
        euro1, cent50, cent20, cent10  : in std_logic;
        d_acum                         : out integer range 0 to 201
      );
    END COMPONENT;

    COMPONENT timer
      port(
        clk           : in std_logic;
        enable_tempor : in std_logic; 
        fin_tempor    : out std_logic 
      );
    END COMPONENT;

    COMPONENT decoder
      port(
        clk                     : in std_logic; -- Reloj para la multiplexación
        enable_DecoderCont      : in std_logic;
        enable_DecoderFinOK     : in std_logic;
        enable_DecoderFinERROR  : in std_logic;
        d_acum_InDecoder        : in integer range 0 to 201;
        display                 : out std_logic_vector(6 downto 0); -- Bus de segmentos
        digit_control           : out std_logic_vector(7 downto 0)  -- Control de los dígitos
      );
    END COMPONENT;
  
begin
  -- INSTANCIACIÓN Y CONEXIÓNES ENTRE LOS COMPONENTES
  Inst_synchrnzr: synchrnzr port map(
    CLK                => CLK,
    iniciar_compra_in  => iniciar_compra,
    confirm_in         => confirm,
    euro1_in           => euro1,
    cent50_in          => cent50,
    cent20_in          => cent20,
    cent10_in          => cent10,
    iniciar_compra_out => iniciar_compra_se,
    confirm_out        => confirm_se,
    euro1_out          => euro1_se,
    cent50_out         => cent50_se,
    cent20_out         => cent20_se,
    cent10_out         => cent10_se
  );
  
  Inst_edgedtctr: edgedtctr port map(
    CLK                => CLK,
    iniciar_compra_in  => iniciar_compra_se,
    confirm_in         => confirm_se,
    euro1_in           => euro1_se,
    cent50_in          => cent50_se,
    cent20_in          => cent20_se,
    cent10_in          => cent10_se,
    iniciar_compra_out => iniciar_compra_ef,
    confirm_out        => confirm_ef,
    euro1_out          => euro1_ec,
    cent50_out         => cent50_ec,
    cent20_out         => cent20_ec,
    cent10_out         => cent10_ec
  );
  
  Inst_FSM: FSM port map(
    clk                    => CLK,
    RESET                  => RESET,
    d_acum_in              => d_acum_cf,
    cocacola               => cocacola,
    fanta                  => fanta,
    nestea                 => nestea,
    iniciar_compra         => iniciar_compra_ef,
    confirm                => confirm_ef,
    fin_tempor             => fin_tempor_tf,
    d_acum_ToDecoder       => d_acum_fd,
    led_cocacola           => led_cocacola,
    led_fanta              => led_fanta,
    led_nestea             => led_nestea,
    DEVOLUCION_DINERO      => DEVOLUCION_DINERO,
    error_compra           => error_compra,
    enable_DecoderFinOK    => enable_DecoderFinOK_fd,
    enable_DecoderFinERROR => enable_DecoderFinERROR_fd,
    enable_DecoderCont     => enable_DecoderCont_fd,
    enable_cont            => enable_cont_fc,
    enable_tempor          => enable_tempor_ft,
    led_reposo             => led_reposo,         -- DEBUG
    led_WaitConfirm        => led_WaitConfirm     -- DEBUG
  );

  Inst_contador: contador port map(
    clk         => CLK,
    enable_cont => enable_cont_fc,
    euro1       => euro1_ec,
    cent50      => cent50_ec,
    cent20      => cent20_ec,
    cent10      => cent10_ec,
    d_acum      => d_acum_cf
  );

  Inst_timer: timer port map(
    clk           => CLK,
    enable_tempor => enable_tempor_ft,
    fin_tempor    => fin_tempor_tf
  );
  
  Inst_decoder: decoder port map(
    clk                    => CLK,
    enable_DecoderCont     => enable_DecoderCont_fd,
    enable_DecoderFinOK    => enable_DecoderFinOK_fd,
    enable_DecoderFinERROR => enable_DecoderFinERROR_fd,
    d_acum_InDecoder       => d_acum_fd,
    display                => display,
    digit_control          => digit_control
  );

end behavioral;


