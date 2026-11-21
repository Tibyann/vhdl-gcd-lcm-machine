--GCD
--Deskripsi:
--Blok ini berfungsi untuk mencari GCD dari 2 bilangan biner up to 32 bit.
--fast shift dan early exit

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity gcd is
	port (
			A, B 				: in std_logic_vector(31 downto 0);
			start_GCD, clk : in std_logic; 
			D					: out std_logic_vector(31 downto 0);
			busy_GCD 		: out std_logic
		  );
end gcd;

architecture rtl of gcd is
	signal done_sub_shift, en_A, load_A, en_B, load_B, en_count, rst_count, en_D : std_logic;
	signal sub_or_shift_A, sub_or_shift_B, B_out_AB, B_out_BA : std_logic;
	signal D_A, D_B, Q_A, Q_B, R_AB, R_BA, A_iter, B_iter, base_res, Q_D : std_logic_vector (31 downto 0);
	signal shift_A, shift_B, k_add : std_logic_vector(2 downto 0);
	signal or_AB_4 : std_logic_vector(3 downto 0);
	signal count : std_logic_vector(4 downto 0);
begin
	mux_A: entity work.mux_2_to_1_32_bit
	port map (A => A_iter, B => A, sel => load_A, data => D_A);
	
	mux_B: entity work.mux_2_to_1_32_bit
	port map (A => B_iter, B => B, sel => load_B, data => D_B);
	
	mux_A_iter: entity work.mux_2_to_1_32_bit
	port map (A => Q_A, B => R_AB, sel => sub_or_shift_A, data => A_iter);
	
	mux_B_iter: entity work.mux_2_to_1_32_bit
	port map (A => Q_B, B => R_BA, sel => sub_or_shift_B, data => B_iter);
	
	-- Pilih hasil pengurangan jika keduanya ganjil
	sub_or_shift_A <= B_out_BA AND Q_A(0) AND Q_B(0);
	sub_or_shift_B <= (NOT B_out_BA) AND Q_A(0) AND Q_B(0);
	
	-- Detektor trailing-zero 4-bit pada A_iter dan B_iter (geser 1 sampe 4 bit sekaligus)
	shift_A <= "000" when load_A = '1' else
	           "100" when A_iter(3 downto 0) = "0000" else
	           "011" when A_iter(2 downto 0) = "000" else
	           "010" when A_iter(1 downto 0) = "00" else
	           "001" when A_iter(0) = '0' else
	           "000";
	           
	shift_B <= "000" when load_B = '1' else
	           "100" when B_iter(3 downto 0) = "0000" else
	           "011" when B_iter(2 downto 0) = "000" else
	           "010" when B_iter(1 downto 0) = "00" else
	           "001" when B_iter(0) = '0' else
	           "000";
	
	-- Jumlah faktor 2 bersama = trailing-zero dari (Q_A OR Q_B)
	or_AB_4 <= Q_A(3 downto 0) OR Q_B(3 downto 0);
	k_add   <= "100" when or_AB_4 = "0000" else
	           "011" when or_AB_4(2 downto 0) = "000" else
	           "010" when or_AB_4(1 downto 0) = "00" else
	           "001" when or_AB_4(0) = '0' else
	           "000";
	
	reg_A: entity work.prl_Rshift_register_16_bit
	port map (D => D_A, en => en_A, shift_amt => shift_A, clk => clk, Q => Q_A);
	
	reg_B: entity work.prl_Rshift_register_16_bit
	port map (D => D_B, en => en_B, shift_amt => shift_B, clk => clk, Q => Q_B);
	
	sub_AB : entity work.subtractor_16_bit
	port map (A => Q_A, B => Q_B, B_out => B_out_AB, R => R_AB);
	
	sub_BA : entity work.subtractor_16_bit
	port map (A => Q_B, B => Q_A, B_out => B_out_BA, R => R_BA);
	
	counter : entity work.two_way_counter_4_bit
	port map (en => en_count, add_val => k_add, rst => rst_count, clk => clk, count => count);
	
	-- Nilai dasar sebelum dikali 2^count (saat ada yang hasilnya = 1 atau Q_A = Q_B)
	base_res <= Q_A when (unsigned(Q_B) = 0 OR Q_A = Q_B) else
	            Q_B when (unsigned(Q_A) = 0) else
	            std_logic_vector(to_unsigned(1, 32));
	
	-- Barrel shifter langsung mengunci (base_res << count) dalam 1 siklus
	reg_D : entity work.prl_Lshift_register_16_bit
	port map (D => base_res, en => en_D, shift_amt => count, clk => clk, Q => Q_D);
	
	FSM : entity work.fsm_gcd
	port map (
				start_GCD => start_GCD, clk => clk, done_sub_shift => done_sub_shift,
				en_A => en_A, load_A => load_A, en_B => en_B, load_B => load_B,
				en_count => en_count, rst_count => rst_count, en_D => en_D, busy_GCD => busy_GCD
	);
	
	done_sub_shift <= '1' when (unsigned(Q_A) = 0 OR unsigned(Q_B) = 0 OR
	                            Q_A = Q_B OR
	                            unsigned(Q_A) = 1 OR unsigned(Q_B) = 1) else '0';
	D <= Q_D;
end rtl;
