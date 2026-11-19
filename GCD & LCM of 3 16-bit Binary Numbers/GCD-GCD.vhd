--GCD

--Deskripsi:
--Blok ini berfungsi untuk mencari GCD dari 2 bilangan biner 16-bit.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity gcd is
    port (
			 A,B 				 : in std_logic_vector(15 downto 0);
			 start_GCD, clk : in std_logic; 
			 D					 : out std_logic_vector(15 downto 0);
          busy_GCD 		 : out std_logic
			);
end gcd;


--Define Architecture
architecture rtl of gcd is
	signal done_sub_shift, done_count, en_A, load_A, en_B, load_B, en_count, way, rst_count, en_D, load_D : std_logic;
	signal sub_or_shift_A, sub_or_shift_B, B_out_AB, B_out_BA, shift_A, shift_B, shift_D, en_count_real: std_logic;
	signal D_A, D_B, Q_A, Q_B, R_AB, R_BA, A_iter, B_iter, Q_A_or_Q_B, D_D, Q_D : std_logic_vector (15 downto 0);
	signal count : std_logic_vector(3 downto 0);
begin
	mux_A: entity work.mux_2_to_1_16_bit
	port map	(
				A => A_iter, B => A, sel => load_A, data => D_A
	);
	
	mux_B: entity work.mux_2_to_1_16_bit
	port map	(
				A => B_iter, B => B, sel => load_B, data => D_B
	);
	
	mux_A_iter: entity work.mux_2_to_1_16_bit
	port map	(
				A => Q_A, B => R_AB, sel => sub_or_shift_A, data => A_iter
	);
	
	mux_B_iter: entity work.mux_2_to_1_16_bit
	port map	(
				A => Q_B, B => R_BA, sel => sub_or_shift_B, data => B_iter
	);
	
	sub_or_shift_A <= B_out_BA AND Q_A(0) AND Q_B(0);
	sub_or_shift_B <= (NOT B_out_BA) AND Q_A(0) AND Q_B(0);
	
	reg_A: entity work.prl_Rshift_register_16_bit
	port map	(
				D => D_A, en => en_A, en_shift => shift_A, clk => clk, Q => Q_A
	);
	
	reg_B: entity work.prl_Rshift_register_16_bit
	port map	(
				D => D_B, en => en_B, en_shift => shift_B, clk => clk, Q => Q_B
	);	
		
	shift_A <= ((NOT Q_A(0)) OR (B_out_BA AND Q_A(0) AND Q_B(0))) AND (NOT load_A);
	shift_B <= ((NOT Q_B(0)) OR ((NOT B_out_BA) AND Q_A(0) AND Q_B(0))) AND (NOT load_B);
		
	sub_AB : entity work.subtractor_16_bit
	port map (
				A => Q_A, B => Q_B, B_out => B_out_AB, R => R_AB
	);
	
	sub_BA : entity work.subtractor_16_bit
	port map (
				A => Q_B, B => Q_A, B_out => B_out_BA, R => R_BA
	);
	
	counter : entity work.two_way_counter_4_bit
	port map (
				en	=> en_count_real, way => way, rst => rst_count, clk => clk, count => count
	);
	
	en_count_real <= en_count AND (((NOT Q_A(0)) AND (NOT Q_B(0)) AND way) XOR (NOT way)) ;
	
	reg_D : entity work.prl_Lshift_register_16_bit
	port map (
				D => D_D, en => en_D, en_shift => shift_D, clk => clk, Q => Q_D
	);
	
	shift_D <= NOT load_D;
	
	mux_D: entity work.mux_2_to_1_16_bit
	port map	(
				A => Q_D, B => Q_A_or_Q_B, sel => load_D, data => D_D
	);
	
	FSM : entity work.fsm_gcd
	port map (
				start_GCD => start_GCD, clk => clk, done_sub_shift => done_sub_shift, done_count => done_count,
				en_A => en_A, load_A => load_A, en_B => en_B, load_B => load_B, en_count => en_count, way => way, 
				rst_count => rst_count, en_D => en_D, load_D => load_D, busy_GCD => busy_GCD
	);
	
	Q_A_or_Q_B <= Q_A when (unsigned(Q_B) = 0) else Q_B;
	done_sub_shift <= '1' when (unsigned(Q_B) = 0 OR unsigned(Q_A) = 0) else '0';
	done_count <= (NOT count(3)) AND (NOT count(2)) AND (NOT count(1)) AND (NOT count(0));
	D <= Q_D;
end rtl;

