--GCD LCM 3 BILANGAN

--Deskripsi:
--Blok ini berfungsi untuk mencari nilai GCD dan LCM dari 3 bilangan biner 16-bit beserta jumlah clock cycle-nya.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity gcd_lcm_3_bilangan is
	port (
			A, B, C			: in std_logic_vector(15 downto 0);
			start, clk		: in std_logic;
			GCD_out			: out std_logic_vector(15 downto 0);
			LCM_out			: out std_logic_vector(31 downto 0);
			cycle_count		: out std_logic_vector(15 downto 0);
			busy, done		: out std_logic
			);
end gcd_lcm_3_bilangan;


--Define Architecture
architecture rtl of gcd_lcm_3_bilangan is
	signal start_GCD, busy_GCD, start_div, busy_div : std_logic;
	signal sel_div, sel_mult : std_logic;
	signal sel_gcd : std_logic_vector(1 downto 0);
	signal en_in, en_G1, en_GCD_tot, en_G_lcm, en_Q1, en_Q2, en_LCM1, en_LCM_tot : std_logic;
	signal en_cycle, rst_cycle : std_logic;
	
	signal Q_A, Q_B, Q_C : std_logic_vector(15 downto 0);
	signal Q_G1, Q_GCD_tot, Q_G_lcm, Q_Q1, Q_Q2 : std_logic_vector(15 downto 0);
	
	signal gcd_in_A, gcd_in_B, gcd_res : std_logic_vector(31 downto 0);
	signal A_pad_32, B_pad_32, C_pad_32, G1_pad_32 : std_logic_vector(31 downto 0);
	
	signal div_in_A, div_in_B, div_res : std_logic_vector(15 downto 0);
	signal mult_in_A : std_logic_vector(15 downto 0);
	signal mult_in_B, mult_res, Q_LCM1, Q_LCM_tot : std_logic_vector(31 downto 0);
begin
	-- Register penyimpan 3 input awal
	reg_in_A: entity work.register_16_bit
	port map (D => A, en => en_in, clk => clk, Q => Q_A);
	
	reg_in_B: entity work.register_16_bit
	port map (D => B, en => en_in, clk => clk, Q => Q_B);
	
	reg_in_C: entity work.register_16_bit
	port map (D => C, en => en_in, clk => clk, Q => Q_C);
	
	-- tnambahin 0 dibelakang 16 bit biar jadi 32 bit
	A_pad_32  <= "0000000000000000" & Q_A;
	B_pad_32  <= "0000000000000000" & Q_B;
	C_pad_32  <= "0000000000000000" & Q_C;
	G1_pad_32 <= "0000000000000000" & Q_G1;
	
	-- Mux untuk memilih input 32-bit ke blok GCD 
	mux_gcd_A: entity work.mux_4_to_1_16_bit
	port map (
				A => A_pad_32, B => G1_pad_32, C => Q_LCM1, D => A_pad_32,
				sel => sel_gcd, data => gcd_in_A
	);
	
	mux_gcd_B: entity work.mux_4_to_1_16_bit
	port map (
				A => B_pad_32, B => C_pad_32, C => C_pad_32, D => B_pad_32,
				sel => sel_gcd, data => gcd_in_B
	);
	
	-- Blok utama Binary GCD (32-bit)
	unit_gcd: entity work.gcd
	port map (
				A => gcd_in_A, B => gcd_in_B,
				start_GCD => start_GCD, clk => clk,
				D => gcd_res, busy_GCD => busy_GCD
	);
	
	-- Register penyimpan hasil GCD tiap tahap 
	reg_G1: entity work.register_16_bit
	port map (D => gcd_res(15 downto 0), en => en_G1, clk => clk, Q => Q_G1);
	
	reg_GCD_tot: entity work.register_16_bit
	port map (D => gcd_res(15 downto 0), en => en_GCD_tot, clk => clk, Q => Q_GCD_tot);
	
	reg_G_lcm: entity work.register_16_bit
	port map (D => gcd_res(15 downto 0), en => en_G_lcm, clk => clk, Q => Q_G_lcm);
	
	-- Mux untuk memilih input ke blok Storing Division
	mux_div_A: entity work.mux_2_to_1_16_bit
	port map (A => Q_A, B => Q_C, sel => sel_div, data => div_in_A);
	
	mux_div_B: entity work.mux_2_to_1_16_bit
	port map (A => Q_G1, B => Q_G_lcm, sel => sel_div, data => div_in_B);
	
	-- Blok utama Storing Division 16-bit
	unit_div: entity work.storing_division
	port map (
				A => div_in_A, B => div_in_B,
				start => start_div, clk => clk,
				D => div_res, busy => busy_div
	);
	
	-- Register penyimpan hasil bagi Q1 dan Q2
	reg_Q1: entity work.register_16_bit
	port map (D => div_res, en => en_Q1, clk => clk, Q => Q_Q1);
	
	reg_Q2: entity work.register_16_bit
	port map (D => div_res, en => en_Q2, clk => clk, Q => Q_Q2);
	
	-- Mux dan blok Multiplier penghitung LCM
	mux_mult_A: entity work.mux_2_to_1_16_bit
	port map (A => Q_Q1, B => Q_Q2, sel => sel_mult, data => mult_in_A);
	
	mux_mult_B: entity work.mux_2_to_1_32_bit
	port map (A => B_pad_32, B => Q_LCM1, sel => sel_mult, data => mult_in_B);
	
	unit_mult: entity work.multiplier_32_bit
	port map (A => mult_in_A, B => mult_in_B, R => mult_res);
	
	reg_LCM1: entity work.register_32_bit
	port map (D => mult_res, en => en_LCM1, clk => clk, Q => Q_LCM1);
	
	reg_LCM_tot: entity work.register_32_bit
	port map (D => mult_res, en => en_LCM_tot, clk => clk, Q => Q_LCM_tot);
	
	-- Counter penghitung clock cycle
	timer_cycle: entity work.counter_16_bit
	port map (en => en_cycle, rst => rst_cycle, clk => clk, count => cycle_count);
	
	-- Unit Control Master FSM
	FSM_Master: entity work.fsm_gcd_lcm
	port map (
				start => start, clk => clk, busy_GCD => busy_GCD, busy_div => busy_div,
				sel_gcd => sel_gcd, sel_div => sel_div, sel_mult => sel_mult,
				start_GCD => start_GCD, start_div => start_div,
				en_in => en_in, en_G1 => en_G1, en_GCD_tot => en_GCD_tot, en_G_lcm => en_G_lcm,
				en_Q1 => en_Q1, en_Q2 => en_Q2, en_LCM1 => en_LCM1, en_LCM_tot => en_LCM_tot,
				en_cycle => en_cycle, rst_cycle => rst_cycle, busy_all => busy, done => done
	);
	
	GCD_out <= Q_GCD_tot;
	LCM_out <= Q_LCM_tot;
end rtl;
