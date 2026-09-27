library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity State_Machine is port
(
	clk_input, reset, enable, blink_sig, mode			: IN std_logic;
	holdingregNS, holdingregEW								: IN std_logic;
	
	green, yellow, red, greenEW, yellowEW, redEW		: OUT std_logic;
	NS_CROSSING, EW_CROSSING, NSregclear, EWregclear: OUT std_logic;
	state_out													: OUT std_logic_vector (3 downto 0)
	
);	

end State_Machine;

Architecture SM of State_Machine is
 


 
 TYPE STATE_NAMES IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11, S12, S13, S14, S15);   -- list all the STATE_NAMES values

 
 SIGNAL current_state, next_state	:  STATE_NAMES;     	-- signals of type STATE_NAMES


BEGIN  
 

 -------------------------------------------------------------------------------
 --State Machine:
 -------------------------------------------------------------------------------

 -- REGISTER_LOGIC PROCESS 
 
Register_Section: PROCESS (clk_input)  -- this process updates with a clock
BEGIN
	IF(rising_edge(clk_input)) THEN
		IF (reset = '1') THEN
			current_state <= S0;
		ELSIF (reset = '0' and enable = '1') THEN
			current_state <= next_State;
		END IF;
	END IF;
END PROCESS;	


Transition_Section: PROCESS (current_state) 

BEGIN
  CASE current_state IS
        WHEN S0 =>
		
				if (holdingregEW = '1' and holdingregNS = '0') then
				next_state <= s6;
				else
				next_state <= s1;
				end if;

         WHEN s1 =>
					
				if (holdingregEW = '1' and holdingregNS = '0') then
				next_state <= s6;
				else
				next_state <= s2;
				end if;
			
         WHEN S2 =>		
					next_state <= s3;
				
         WHEN S3 =>		
					next_state <= s4;
					
         WHEN S4 =>		
					next_state <= S5;

         WHEN S5 =>		
					next_state <= S6;
				
         WHEN S6 =>		
					next_state <= s7;
				
         WHEN S7 =>		
					next_state <= s8;
						
			
			WHEN S8 =>		
				if (holdingregNS = '1' and holdingregEW = '0') then
				next_state <= s14;
				else
				next_state <= s9;
				end if;

         
         WHEN S9 =>		
				if (holdingregNS = '1' and holdingregEW = '0') then
				next_state <= s14;
				else
				next_state <= s10;
				end if;
				
         WHEN S10 =>		
					next_state <= s11;
					
         WHEN S11 =>		
					next_state <= S12;

         WHEN s12 =>		
					next_state <= S13;
				
         WHEN S13 =>		
					next_state <= s14;
				
         WHEN S14 =>		
					next_state <= s15;
					
			WHEN S15 =>		
					if (mode = '1') then 
						next_state <= s15;
					else
						next_state <= s0;
					
					end if;
			

			WHEN OTHERS =>
             next_state <= S0;
				 
				 
	  END CASE;
 END PROCESS;
 
 
 Decoder_Section: PROCESS (current_state) 

BEGIN

		NSregclear <= '0';
		EWregclear <= '0';

     CASE current_state IS
	  
         WHEN S0 =>		
				green <= blink_sig;
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				NS_CROSSING <= '0';
				EW_CROSSING <= '0';
				
				state_out <= "0000";
			
         WHEN S1 =>		
				green <= blink_sig;
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				state_out <= "0001";
				

         WHEN S2 =>		
				green <= '1';
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '1';
				
				state_out <= "0010";
			
         WHEN S3 =>		
				green <= '1';
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';	
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '1';
				
				state_out <= "0011";

         WHEN S4 =>		
				green <= '1';
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '1';
				
				state_out <= "0100";

         WHEN S5 =>		
				green <= '1';
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '1';
				
				state_out <= "0101";

				
         WHEN S6 =>		
				green <= '0';
				yellow <= '1';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				NSregclear <= '1';
				EWregclear <= '0';
				
				
				state_out <= "0110";

				
         WHEN S7 =>		
				green <= '0';
				yellow <= '1';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '1';

				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				state_out <= "0111";
			
			
			WHEN S8 =>
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				greenEW <= blink_sig;
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				
				state_out <= "1000";
			
         WHEN S9 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				greenEW <= blink_sig;
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				state_out <= "1001";
				

         WHEN S10 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				greenEW <= '1';
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '1';
				NS_CROSSING <= '0';
				
				
				state_out <= "1010";

			
         WHEN S11 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				greenEW <= '1';
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '1';
				NS_CROSSING <= '0';
				
				state_out <= "1011";


         WHEN S12 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				greenEW <= '1';
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '1';
				NS_CROSSING <= '0';
				
				
				state_out <= "1100";


         WHEN S13 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
			
				greenEW <= '1';
				yellowEW <= '0';
				redEW <= '0';
				
				EW_CROSSING <= '1';
				NS_CROSSING <= '0';
				
				
				state_out <= "1101";
				

				
         WHEN S14 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				
				greenEW <= '0';
				yellowEW <= '1';
				redEW <= '0';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				NSregclear <= '0';
				EWregclear <= '1';
				
				
				state_out <= "1110";
				
				
         WHEN S15 =>		
				green <= '0';
				yellow <= '0';
				red <= '1';
				
				
				greenEW <= '0';
				yellowEW <= '1';
				redEW <= '0';
				
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';
				
				state_out <= "1111";
				

				
         WHEN others =>		
 				green <= '0';
				yellow <= '0';
				red <= '0';
				
				greenEW <= '0';
				yellowEW <= '0';
				redEW <= '0';
							
				EW_CROSSING <= '0';
				NS_CROSSING <= '0';

			
	  END CASE;
 END PROCESS;
 
END ARCHITECTURE SM;