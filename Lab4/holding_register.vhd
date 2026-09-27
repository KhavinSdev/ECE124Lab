library ieee;
use ieee.std_logic_1164.all;


entity holding_register is port (

			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
 end holding_register;
 
 architecture circuit of holding_register is

	Signal sreg				: std_logic;	
	

BEGIN

	dout <= sreg;
	
	sync_system : process(clk)
		BEGIN
	
			if (rising_edge(clk)) then 
				
				sreg <= (din OR sreg) AND (NOT(register_clr OR reset));
				
			end if;
			
			
		end process;


end;