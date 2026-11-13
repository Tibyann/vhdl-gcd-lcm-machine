--STORING DIVISION

--Deskripsi:
--Blok ini berfungsi untuk membagi bilangan biner 16-bit dengan 16-bit.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity storing_division is
    port (
			 A,B 			: in std_logic_vector(15 downto 0);
			 start, clk : in std_logic; 
			 D				: out std_logic_vector(15 downto 0);
          busy 		: out std_logic
			);
end storing_division;


--Define Architecture
architecture rtl of storing_division is
	signal last, en_A, load_A, en_B, en_D, en_count, rst_count, B_out, D_srl : std_logic;
	signal A_init, A_iter, D_A, Q_A : std_logic_vector(31 downto 0);
	signal A_window, Q_B : std_logic_vector(15 downto 0);
	signal R, B_pad : std_logic_vector(16 downto 0);
	signal count : std_logic_vector(3 downto 0);
begin
	mux_A: entity work.mux_2_to_1_32_bit
	port map	(
				A => A_iter, B => A_init, sel => load_A, data => D_A
	);
	
	mux_A_window: entity work.mux_2_to_1_16_bit
	port map	(
				A => R(15 downto 0), B => Q_A(30 downto 15), sel => B_out, data => A_window
	);
	
	reg_A: entity work.register_32_bit 
	port map	(
				D => D_A, en => en_A, clk => clk, Q => Q_A
	);
	
	reg_B: entity work.register_16_bit 
	port map	(
				D => B, en => en_B, clk => clk, Q => Q_B
	);	
			
	sub_AB : entity work.subtractor_17_bit
	port map (
				A => Q_A(31 downto 15), B => B_pad, B_out => B_out, R => R
	);
	
	counter : entity work.counter_4_bit
	port map (
				en	=> en_count, rst => rst_count, clk => clk, count => count
	);
	
	shift_reg_D : entity work.srl_Lshift_register_16_bit
	port map (
				D_srl => D_srl, en	=> en_D, clk => clk, Q => D
	);
	
	FSM : entity work.fsm_storing_division
	port map (
				start => start, clk => clk, last => last,
				en_A => en_A, load_A => load_A, en_B => en_B, en_D => en_D, en_count => en_count, rst_count => rst_count, busy => busy
	);
	
	A_init <= "0000000000000000" & A;
	A_iter <= A_window & Q_A(14 downto 0) & '0';
	B_pad <= '0' & Q_B;
	D_srl <= NOT(B_out);
	last <= count(3) AND count(2) AND count(1) AND count(0);
end rtl;

