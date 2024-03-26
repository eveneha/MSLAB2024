library IEEE;
use IEEE.std_logic_1164.all; 
use WORK.constants.all;

entity MUX21_GENERIC  is
         generic (NBIT : integer := numBit;
                  DELAY_MUX: time := tp_mux);
         port ( A:      in      std_logic_vector(NBIT-1 downto 0);
                B:      in      std_logic_vector(NBIT-1 downto 0);
                S:      in      std_logic;
                Y:      out     std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;


architecture BEHAVIORAL of MUX21_GENERIC is

begin
  
	Y <= A when S='1' else B after DELAY_MUX;

end BEHAVIORAL;

architecture STRUCTURAL of MUX21_GENERIC is

	
        component mux21
          port ( A: in std_logic;
                 B: in std_logic;
                 S: in std_logic;
                 Y: out std_logic);
        end component mux21; 

begin
  mux_machine:
    for i in 0 to NBIT-1 generate
      begin
        MUX21_i : MUX21 port map (A=>A(i), B=>B(i), S=>S, Y => Y(i));
      end generate mux_machine;      


end STRUCTURAL;

-------------------------------------------------------------------------

configuration CFG_MUX21_GENERIC_STRUCTURAL of MUX21_GENERIC is
  for STRUCTURAL
    for mux_machine
       for all : MUX21
         use configuration WORK.CFG_MUX21_STRUCTURAL;
       end for;
    end for;
  end for;
end CFG_MUX21_GENERIC_STRUCTURAL;

configuration CFG_MUX21_GENERIC_BEHAVIORAL of MUX21_GENERIC is
  for BEHAVIORAL  
  end for;
end CFG_MUX21_GENERIC_BEHAVIORAL;


  




