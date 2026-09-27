
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
    clkin_50	    : in	std_logic;							-- The 50 MHz FPGA Clockinput
	rst_n			: in	std_logic;							-- The RESET input (ACTIVE LOW)
	pb_n			: in	std_logic_vector(3 downto 0); -- The push-button inputs (ACTIVE LOW)
 	sw   			: in  	std_logic_vector(7 downto 0); -- The switch inputs
    leds			: out 	std_logic_vector(7 downto 0);	-- for displaying the the lab4 project details
	
	-------------------------------------------------------------
	-- you can add temporary output ports here if you need to debug your design 
	-- or to add internal signals for your simulations
	-------------------------------------------------------------
	
--	sm_clken_top, blink_sig_top 			: out std_logic;
--	a_NS, g_NS, d_NS, a_EW, g_EW, d_EW 	: out std_logic;
	
   seg7_data 	: out 	std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	);
END LogicalStep_Lab4_top;

ARCHITECTURE SimpleCircuit OF LogicalStep_Lab4_top IS
   component segment7_mux port (
             clk        	: in  	std_logic := '0';
			 DIN2 			: in  	std_logic_vector(6 downto 0);	--bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DIN1 			: in  	std_logic_vector(6 downto 0); --bits 6 to 0 represent segments G,F,E,D,C,B,A
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
   );
   end component;
	
	
	component holding_register port (
			clk					: in std_logic;
			reset				: in std_logic;
			register_clr		: in std_logic;
			din					: in std_logic;
			dout				: out std_logic
  );
	end component holding_register;
	
	
	component synchronizer port (
			clk				: in std_logic;
			reset				: in std_logic;
			din				: in std_logic;
			dout				: out std_logic
  );
 end component synchronizer;
 
 	component State_Machine is port
(
	clk_input, reset, enable, blink_sig, mode			: IN std_logic;
	holdingregNS, holdingregEW								: IN std_logic;
	
	green, yellow, red, greenEW, yellowEW, redEW		: OUT std_logic;
	NS_CROSSING, EW_CROSSING, NSregclear, EWregclear: OUT std_logic;
	state_out													: OUT std_logic_vector (3 downto 0)
	
);	

 end component State_Machine;
	

   component clock_generator port (
			sim_mode			: in boolean;
			reset				: in std_logic;
            clkin      		    : in  std_logic;
			sm_clken			: out	std_logic;
			blink		  		: out std_logic
  );
   end component;

    component pb_filters port (
			clkin				: in std_logic;
			rst_n				: in std_logic;
			rst_n_filtered	    : out std_logic;
			pb_n				: in  std_logic_vector (3 downto 0);
			pb_n_filtered	    : out	std_logic_vector(3 downto 0)							 
 );
   end component;

	component pb_inverters port (
			rst_n				: in  std_logic;
			rst				    : out	std_logic;							 
			pb_n_filtered	    : in  std_logic_vector (3 downto 0);
			pb					: out	std_logic_vector(3 downto 0)							 
  );
   end component;
	
--	component synchronizer port(
--			clk					: in std_logic;
--			reset					: in std_logic;
--			din					: in std_logic;
--			dout					: out std_logic
--  );
--   end component; 
--  component holding_register port (
--			clk					: in std_logic;
--			reset					: in std_logic;
--			register_clr		: in std_logic;
--			din					: in std_logic;
--			dout					: out std_logic
--  );
--  end component;			
----------------------------------------------------------------------------------------------------
	CONSTANT	sim_mode								: boolean := FALSE;  -- set to FALSE for LogicalStep board downloads																						-- set to TRUE for SIMULATIONS
	SIGNAL rst, rst_n_filtered, synch_rst			    : std_logic;
	SIGNAL sm_clken, blink_sig							: std_logic; 
	SIGNAL pb_n_filtered, pb							: std_logic_vector(3 downto 0); 
	SIGNAL synch0OUT, synch1OUT						: std_logic; -- Part A synchronizer for pb(x) output signals
	
	SIGNAL gsolidNS, ysolidNS, rsolidNS										: std_logic;
	SIGNAL gsolidEW, ysolidEW, rsolidEW										: std_logic;
	
	SIGNAL lightNS, lightEW									: std_logic_vector(6 downto 0);
	
	SIGNAL NS_CROSSINGREQ, EW_CROSSINGREQ, NSregclear, EWregclear						: std_logic;
	
	SIGNAL NS_CROSSING, EW_CROSSING							: std_logic;
	
	SIGNAL mode_ctrl 									: std_logic;

	
	
BEGIN
----------------------------------------------------------------------------------------------------

leds(0) <= NS_CROSSING;
leds(2) <= EW_CROSSING;

leds(1) <= NS_CROSSINGREQ;
leds(3) <= EW_CROSSINGREQ;

--sm_clken_top <= sm_clken;
--blink_sig_top <= blink_sig;
--
--a_NS <= rsolidNS;
--g_NS <= ysolidNS;
--d_NS <= gsolidNS;
--
--a_EW <= rsolidEW;
--g_EW <= ysolidEW;
--d_EW <= gsolidEW;


lightNS <= ysolidNS & "00" & gsolidNS & "00" & rsolidNS;
lightEW <= ysolidEW & "00" & gsolidEW & "00" & rsolidEW;




INST0: pb_filters		port map (clkin_50, rst_n, rst_n_filtered, pb_n, pb_n_filtered);
INST1: pb_inverters		port map (rst_n_filtered, rst, pb_n_filtered, pb);
INST2: synchronizer     port map (clkin_50,'0', rst, synch_rst);	
INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, sm_clken, blink_sig);

INST4: synchronizer port map (clkin_50, synch_rst, pb(0), synch0OUT); -- synchronizers for pb(0) and pb(1)
INST5: synchronizer port map (clkin_50, synch_rst, pb(1), synch1OUT);
--INST3: clock_generator 	port map (sim_mode, synch_rst, clkin_50, leds(2), leds(0));

INST6: holding_register port map (clkin_50, synch_rst, NSregclear, synch0OUT, NS_CROSSINGREQ); -- holding register for pb(0) outputs to leds(3)
INST7: holding_register port map (clkin_50, synch_rst, EWregclear, synch1OUT, EW_CROSSINGREQ);

INST8: State_Machine port map (clkin_50, synch_rst, sm_clken, blink_sig, mode_ctrl, NS_CROSSINGREQ, EW_CROSSINGREQ, gsolidNS, ysolidNS, rsolidNS, gsolidEW, ysolidEW, rsolidEW, NS_CROSSING, EW_CROSSING, NSregclear, EWregclear, leds(7 downto 4));

INST9: segment7_mux port map (clkin_50, lightEW, lightNS, seg7_data (6 downto 0), seg7_char1, seg7_char2);

INST10: synchronizer port map (clkin_50, synch_rst, sw(0), mode_ctrl);


END SimpleCircuit;
