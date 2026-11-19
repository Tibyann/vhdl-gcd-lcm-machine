--TOP OF GCD & LCM

--Deskripsi:
--Blok ini berfungsi untuk mencari GCD dan LCM dari 3 bilangan biner 16 bit.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity top_gcd_lcm is
    port (
			 A,B,C 		: in std_logic_vector(15 downto 0);
			 start, clk : in std_logic; 
			 GCD			: out std_logic_vector(15 downto 0);
			 LCM  		: out std_logic_vector(47 downto 0);
          busy		 	: out std_logic
			);
end top_gcd_lcm;


--Define Architecture
architecture rtl of top_gcd_lcm is
	signal busy_GCD_1, busy_GCD_2, busy_GCD_3, busy_div_1, busy_div_2, busy_div_3, one_is_zero : std_logic; 
   signal en_A, en_B, en_C, en_GCD_AB, en_GCD_BC, en_GCD_CA, en_GCD_ABC, en_Rdiv_1, en_Rdiv_2, en_Rdiv_3, en_LCM_ABC : std_logic;
	signal start_GCD_1, start_GCD_2, start_GCD_3, start_div_1, start_div_2, start_div_3, sel_load2, sel_LCM_zero : std_logic;
	signal Q_A, Q_B, Q_C, D_GCD_1, D_GCD_2, D_GCD_3, Q_GCD_AB, Q_GCD_BC, Q_GCD_CA, Q_GCD_ABC, data_mux_load2, data_0_demux_load2, data_1_demux_load2 : std_logic_vector(15 downto 0);
	signal D_A_div_GCD_AB, D_B_div_GCD_BC, D_C_div_GCD_CA, Q_A_div_GCD_AB, Q_B_div_GCD_BC, Q_C_div_GCD_CA : std_logic_vector(15 downto 0);
	signal M_mult_1, M_mult_2 : std_logic_vector(31 downto 0);
	signal M_mult_3, data_mux_LCM_zero: std_logic_vector(47 downto 0);
	
begin
	reg_A: entity work.register_16_bit
	port map	(
				D => A, en => en_A, clk => clk, Q => Q_A
	);
	
	reg_B: entity work.register_16_bit
	port map	(
				D => B, en => en_B, clk => clk, Q => Q_B
	);
	
	reg_C: entity work.register_16_bit
	port map	(
				D => C, en => en_C, clk => clk, Q => Q_C
	);
	
	GCD_1: entity work.gcd
	port map	(
				A => Q_A, B => Q_B, start_GCD => start_GCD_1, clk => clk, D => D_GCD_1, busy_GCD => busy_GCD_1
	);
	
	GCD_2: entity work.gcd
	port map	(
				A => Q_B, B => Q_C, start_GCD => start_GCD_2, clk => clk, D => D_GCD_2, busy_GCD => busy_GCD_2
	);
	
	GCD_3: entity work.gcd
	port map	(
				A => Q_C, B => data_mux_load2, start_GCD => start_GCD_3, clk => clk, D => D_GCD_3, busy_GCD => busy_GCD_3
	);
	
	reg_GCD_AB: entity work.register_16_bit
	port map	(
				D => D_GCD_1, en => en_GCD_AB, clk => clk, Q => Q_GCD_AB
	);
	
	reg_GCD_BC: entity work.register_16_bit
	port map	(
				D => D_GCD_2, en => en_GCD_BC, clk => clk, Q => Q_GCD_BC
	);
	
	reg_GCD_CA: entity work.register_16_bit
	port map	(
				D => data_0_demux_load2, en => en_GCD_CA, clk => clk, Q => Q_GCD_CA
	);
	
	reg_GCD_ABC: entity work.register_16_bit
	port map	(
				D => data_1_demux_load2, en => en_GCD_ABC, clk => clk, Q => Q_GCD_ABC
	);
	
	mux_load2: entity work.mux_2_to_1_16_bit
	port map	(
				A => Q_A, B => Q_GCD_AB, sel => sel_load2, data => data_mux_load2
	);
	
	demux_load2: entity work.demux_1_to_2_16_bit
	port map	(
				A => D_GCD_3, sel => sel_load2, data_0 => data_0_demux_load2, data_1 => data_1_demux_load2
	);
	
	div_1: entity work.storing_division
	port map	(
				A => Q_A, B => Q_GCD_AB, start => start_div_1, clk => clk, D => D_A_div_GCD_AB, busy => busy_div_1
	);
	
	div_2: entity work.storing_division
	port map	(
				A => Q_B, B => Q_GCD_BC, start => start_div_2, clk => clk, D => D_B_div_GCD_BC, busy => busy_div_2
	);
	
	div_3: entity work.storing_division
	port map	(
				A => Q_C, B => Q_GCD_CA, start => start_div_3, clk => clk, D => D_C_div_GCD_CA, busy => busy_div_3
	);
	
	reg_A_div_GCD_AB: entity work.register_16_bit
	port map	(
				D => D_A_div_GCD_AB, en => en_Rdiv_1, clk => clk, Q => Q_A_div_GCD_AB
	);
	
	reg_B_div_GCD_BC: entity work.register_16_bit
	port map	(
				D => D_B_div_GCD_BC, en => en_Rdiv_2, clk => clk, Q => Q_B_div_GCD_BC
	);
	
	reg_C_div_GCD_CA: entity work.register_16_bit
	port map	(
				D => D_C_div_GCD_CA, en => en_Rdiv_3, clk => clk, Q => Q_C_div_GCD_CA
	);
	
	mult_1: entity work.mult_16x16_bit
	port map	(
				A => Q_A_div_GCD_AB, B => Q_GCD_ABC, M => M_mult_1
	);
	
	mult_2: entity work.mult_16x16_bit
	port map	(
				A => Q_B_div_GCD_BC, B => Q_C_div_GCD_CA, M => M_mult_2
	);
	
	mult_3: entity work.mult_16x32_bit
	port map	(
				A => M_mult_1(15 downto 0), B => M_mult_2, M => M_mult_3
	);
	
	reg_LCM_ABC: entity work.register_48_bit
	port map	(
				D => data_mux_LCM_zero, en => en_LCM_ABC, clk => clk, Q => LCM
	);
	
	mux_LCM_zero: entity work.mux_2_to_1_48_bit
	port map	(
				A => M_mult_3, B => x"000000000000", sel => sel_LCM_zero, data => data_mux_LCM_zero
	);
	
	FSM: entity work.fsm_top_gcd_lcm
	port map	(
				start => start, clk => clk, busy_GCD_1 => busy_GCD_1, busy_GCD_2 => busy_GCD_2, busy_GCD_3 => busy_GCD_3, busy_div_1 => busy_div_1, busy_div_2 => busy_div_2, busy_div_3 => busy_div_3, one_is_zero => one_is_zero,
				en_A => en_A, en_B => en_B, en_C => en_C, en_GCD_AB => en_GCD_AB, en_GCD_BC => en_GCD_BC, en_GCD_CA => en_GCD_CA, en_GCD_ABC => en_GCD_ABC, en_Rdiv_1 => en_Rdiv_1, en_Rdiv_2 => en_Rdiv_2, en_Rdiv_3 => en_Rdiv_3, en_LCM_ABC => en_LCM_ABC,
				start_GCD_1 => start_GCD_1, start_GCD_2 => start_GCD_2, start_GCD_3 => start_GCD_3, start_div_1 => start_div_1, start_div_2 => start_div_2, start_div_3 => start_div_3, sel_load2 => sel_load2, sel_LCM_zero => sel_LCM_zero, busy => busy
	);
	
	one_is_zero <= '1' when (unsigned(Q_A) = 0 OR unsigned(Q_B) = 0 OR unsigned(Q_C) = 0) else '0';
	GCD <= Q_GCD_ABC;
end rtl;

