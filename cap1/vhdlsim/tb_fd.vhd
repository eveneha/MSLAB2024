library IEEE;
use IEEE.std_logic_1164.all;
use work.constants.all;


entity TBFD is
end TBFD;

architecture TEST of TBFD is

	signal	CK:		std_logic :='0';
	signal	RESET:		std_logic :='0';
	signal	D:		std_logic_vector(3 downto 0) := (others => '0');
	signal	QSYNCH:		std_logic_vector(3 downto 0);
	signal	QASYNCH:	std_logic_vector(3 downto 0);
	
	component FD
	generic (NBIT : integer := numBit);
	Port (	CK:	In	std_logic;
		RESET:	In	std_logic;
		D:	In	std_logic_vector(3 downto 0);
		Q:	Out	std_logic_vector(3 downto 0));
	end component;

begin 
		
	UFD1 : FD
        generic map (NBIT => 4)
	Port Map ( CK, RESET, D, QSYNCH); -- sinc

	UFD2 : FD
        generic map (NBIT => 4)
	Port Map ( CK, RESET, D, QASYNCH); -- asinc
	

	RESET <= '0', '1' after 0.6 ns, '0' after 1.1 ns, '1' after 2.2 ns, '0' after 3.2 ns;	
	
	
	D <= "0000", "1111" after 0.4 ns, "0010" after 1.1 ns,"1010" after 1.4 ns, "0001" after 1.7 ns, "1101" after 1.9 ns;

	
	PCLOCK : process(CK)
	begin
		CK <= not(CK) after 0.5 ns;	
	end process;
end TEST;

configuration FDTEST of TBFD is
   for TEST
      for UFD1 : FD
         use configuration WORK.CFG_FD_PIPPO; -- sincrono
      end for;
      for UFD2 : FD
         use configuration WORK.CFG_FD_PLUTO; -- asincrono
      end for;
   end for;
end FDTEST;

