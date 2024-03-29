library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;

entity FD is
        generic (NBIT : integer := numBit);
	Port (	D:	In	std_logic_vector(NBIT - 1 downto 0);
		CK:	In	std_logic;
		RESET:	In	std_logic;
		Q:	Out	std_logic_vector(NBIT - 1 downto 0));
end FD;


architecture PIPPO of FD is -- flip flop D with syncronous reset

begin
  
	PSYNCH: process(CK,RESET)
	begin
	  if CK'event and CK='1' then -- positive edge triggered:
	    if RESET='1' then -- active high reset 
	      Q <= (others => '0'); 
	    else
	      Q <= D; -- input is written on output
	    end if;
	  end if;
	end process;

end PIPPO;

architecture PLUTO of FD is -- flip flop D with asyncronous reset

begin
	
	PASYNCH: process(CK,RESET)
	begin
	  if RESET='1' then
	    Q <= (others => '0');
	  elsif CK'event and CK='1' then -- positive edge triggered:
	    Q <= D; 
	  end if;
	end process;

end PLUTO;


configuration CFG_FD_PIPPO of FD is
	for PIPPO
	end for;
end CFG_FD_PIPPO;


configuration CFG_FD_PLUTO of FD is
	for PLUTO
	end for;
end CFG_FD_PLUTO;
