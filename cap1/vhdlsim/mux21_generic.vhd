library IEEE;
use IEEE.std_logic_1164.all; --  libreria IEEE con definizione tipi standard logic
use WORK.constants.all; -- libreria WORK user-defined

entity MUX21_GENERIC is
	Generic (NBIT: integer := numBit;
                 DELAY_MUX: time := tp_mux);
	Port (	A:	In	std_logic_vector(NBIT-1 downto 0);
		B:	In	std_logic_vector(NBIT-1 downto 0);
		S:	In	std_logic;
		Y:	Out	std_logic_vector(NBIT-1 downto 0));
end MUX21_GENERIC;


architecture BEHAVIORAL_1 of MUX21_GENERIC is

begin

  
  
  process(A, S, B)
  begin
    for i in Y'range loop
      Y(i) <= (A(i) and S) or (B(i) and not(S));
    end loop;
  end process; 


end BEHAVIORAL_1;


architecture BEHAVIORAL_2 of MUX21_GENERIC is

begin
  
	Y <= A when S='1' else B after DELAY_MUX;

end BEHAVIORAL_2;


architecture BEHAVIORAL_3 of MUX21_GENERIC is

begin
  
	pmux: process(A,B,S)
	begin
        
		if S='1' then
			Y <= A;
		else
			Y <= B;
		end if;

	end process;

end BEHAVIORAL_3;



architecture STRUCTURAL of MUX21_GENERIC is

	
        component mux21 is
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


configuration CFG_MUX21_BEHAVIORAL_1 of MUX21_GENERIC is
	for BEHAVIORAL_1
	end for;
end CFG_MUX21_BEHAVIORAL_1;

configuration CFG_MUX21_GEN_BEHAVIORAL of MUX21_GENERIC is
	for BEHAVIORAL_2
	end for;
end CFG_MUX21_GEN_BEHAVIORAL;

configuration CFG_MUX21_BEHAVIORAL_3 of MUX21_GENERIC is
	for BEHAVIORAL_3
	end for;
end CFG_MUX21_BEHAVIORAL_3;

configuration CFG_MUX21_GEN_STRUCTURAL of MUX21_GENERIC is
	for STRUCTURAL
		for all : MUX21
			use configuration WORK.CFG_MUX21_STRUCTURAL;
		end for;
	        
	end for;
end CFG_MUX21_GEN_STRUCTURAL;
