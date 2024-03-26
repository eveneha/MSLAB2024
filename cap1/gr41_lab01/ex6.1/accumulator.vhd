-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.constants.all;
-------------------------------------------------------------------------------

entity accumulator is
 generic (NBIT   : integer      := numBit); 
 port (
      A          : in           std_logic_vector(numBit - 1 downto 0);
      B          : in           std_logic_vector(numBit - 1 downto 0);
      CLK        : in           std_logic;
      RST_n      : in           std_logic;
      ACCUMULATE : in           std_logic;
      Y          : out          std_logic_vector(numBit - 1 downto 0));
end accumulator;

-------------------------------------------------------------------------------

architecture structural of accumulator is


  component mux21_generic
    generic( NBIT       : integer       := numBit;
             DELAY_MUX  : time          := 0 ns);  
    port(    A_mux      : in            std_logic_vector(NBIT-1 downto 0);
             B_mux      : in            std_logic_vector(NBIT-1 downto 0);
             S_mux      : in            std_logic;
             Y_mux      : out           std_logic_vector(NBIT-1 downto 0)); 
  end component;

  component rca_generic
    generic( DRCAS      : time          := 0 ns;
             DRCAC      : time          := 0 ns;
             NBIT       : integer       := numBit);
    port(    A_add      : in            std_logic_vector(NBIT-1 downto 0);
             B_add      : in            std_logic_vector(NBIT-1 downto 0);
             S_add      : out           std_logic_vector(NBIT-1 downto 0));
  end component; 
  
  component fd
    generic( NBIT       : integer       := numBit);
    port(    D_reg      : in            std_logic_vector(NBIT-1 downto 0);
             CK_reg     : in            std_logic;
             RESET_reg  : in            std_logic;
             Q_reg      : out           std_logic_vector(NBIT-1 downto 0)); 
  end component;

  signal mux_out  : std_logic_vector(NBIT-1 downto 0);
  signal adder_out: std_logic_vector(NBIT-1 downto 0);

begin
  
  mux_inst: mux21_generic
    generic map (
      NBIT      => NBIT,
      DELAY_MUX => 0 ns
    );
    port map (
      A_mux => A,
      B_mux => B,
      S_mux => ACCUMULATE,
      Y_mux => mux_out
    );

  adder_inst: rca_generic
    generic map (
      NBIT => NBIT
    );
    port map (
      A_add => A,
      B_add => B,
      S_add => adder_out
    );

  reg_inst: fd
    generic map (
      NBIT => NBIT
    );
    port map (
      D_reg     => adder_out,
      CK_reg    => CLK,
      RESET_reg => RST_n,
      Q_reg     => Y
    );


end structural;

-------------------------------------------------------------------------------


configuration CFG_ACC_STRUCTURAL of accumulator is
  for structural 
      for mux_inst : mux21_generic
        use configuration WORK.MUX21_GENERIC_STRUCTURAL;
      end for;
      for adder_inst: rca_generic
        use configuration WORK.CFG_RCA_STRUCTURAL;
      end for;
      for reg_inst: fd
        use configuration WORK.PIPPO;
      end for;
  end for;
end CFG_ACC_STRUCTURAL;

configuration CFG_ACC_BEHAVIORAL of accumulator is
    for behavioral
      for mux_inst: mux21_generic
        use configuration WORK.CFG_MUX21_GENERIC_BEHAVIORAL;
      end for;
      for adder_inst: rca_generic
        use configuration WORK.CFG_RCA_BEHAVIORAL;
      end for;
      for reg_inst: fd
        use configuration WORK.PIPPO;
      end for;
  end for;
end CFG_ACC_BEHAVIORAL;
