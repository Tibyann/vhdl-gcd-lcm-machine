--FSM GCD LCM

--Deskripsi:
--Blok ini berfungsi sebagai unit control utama untuk mengatur kerja blok GCD, division, dan multiplier.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity fsm_gcd_lcm is
	port (
			start, clk, busy_GCD, busy_div : in std_logic;
			sel_gcd : out std_logic_vector(1 downto 0);
			sel_div, sel_mult : out std_logic;
			start_GCD, start_div : out std_logic;
			en_in, en_G1, en_GCD_tot, en_G_lcm, en_Q1, en_Q2, en_LCM1, en_LCM_tot : out std_logic;
			en_cycle, rst_cycle, busy_all, done : out std_logic
			);
end fsm_gcd_lcm;


--Define Architecture
architecture behavioral of fsm_gcd_lcm is
	type state_type is (IDLE, TRIG_1, WAIT_1, TRIG_2, WAIT_2, MULT_1, TRIG_3, WAIT_3, TRIG_4, WAIT_4, MULT_2, FINISH);
	signal current_state, next_state : state_type := IDLE;
begin
	process (clk)
	begin
		if rising_edge (clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process (start, busy_GCD, busy_div, current_state)
	begin
		-- Nilai default supaya tidak muncul latch
		sel_gcd <= "00";
		sel_div <= '0';
		sel_mult <= '0';
		start_GCD <= '0';
		start_div <= '0';
		en_in <= '0';
		en_G1 <= '0';
		en_GCD_tot <= '0';
		en_G_lcm <= '0';
		en_Q1 <= '0';
		en_Q2 <= '0';
		en_LCM1 <= '0';
		en_LCM_tot <= '0';
		en_cycle <= '0';
		rst_cycle <= '0';
		busy_all <= '1';
		done <= '0';
		
		case current_state is
			when IDLE =>
				busy_all <= '0';
				if (start = '1') then
					en_in <= '1';
					rst_cycle <= '1';
					next_state <= TRIG_1;
				else
					next_state <= IDLE;
				end if;
				
			-- Tahap 1: Cari G1 = GCD(A, B)
			when TRIG_1 =>
				sel_gcd <= "00";
				start_GCD <= '1';
				en_cycle <= '1';
				next_state <= WAIT_1;
				
			when WAIT_1 =>
				sel_gcd <= "00";
				en_cycle <= '1';
				if (busy_GCD = '0') then
					en_G1 <= '1';
					next_state <= TRIG_2;
				else
					next_state <= WAIT_1;
				end if;
				
			-- Tahap 2 (Paralel): Cari GCD_tot = GCD(G1, C) sekaligus Q1 = A / G1
			when TRIG_2 =>
				sel_gcd <= "01";
				sel_div <= '0';
				start_GCD <= '1';
				start_div <= '1';
				en_cycle <= '1';
				next_state <= WAIT_2;
				
			when WAIT_2 =>
				sel_gcd <= "01";
				sel_div <= '0';
				en_cycle <= '1';
				if (busy_GCD = '0' AND busy_div = '0') then
					en_GCD_tot <= '1';
					en_Q1 <= '1';
					next_state <= MULT_1;
				else
					next_state <= WAIT_2;
				end if;
				
			-- Hitung LCM1 = Q1 * B
			when MULT_1 =>
				sel_mult <= '0';
				en_LCM1 <= '1';
				en_cycle <= '1';
				next_state <= TRIG_3;
				
			-- Tahap 3: Cari G_lcm = GCD(LCM1, C)
			when TRIG_3 =>
				sel_gcd <= "10";
				start_GCD <= '1';
				en_cycle <= '1';
				next_state <= WAIT_3;
				
			when WAIT_3 =>
				sel_gcd <= "10";
				en_cycle <= '1';
				if (busy_GCD = '0') then
					en_G_lcm <= '1';
					next_state <= TRIG_4;
				else
					next_state <= WAIT_3;
				end if;
				
			-- Tahap 4: Cari Q2 = C / G_lcm
			when TRIG_4 =>
				sel_div <= '1';
				start_div <= '1';
				en_cycle <= '1';
				next_state <= WAIT_4;
				
			when WAIT_4 =>
				sel_div <= '1';
				en_cycle <= '1';
				if (busy_div = '0') then
					en_Q2 <= '1';
					next_state <= MULT_2;
				else
					next_state <= WAIT_4;
				end if;
				
			-- Hitung LCM_tot = Q2 * LCM1
			when MULT_2 =>
				sel_mult <= '1';
				en_LCM_tot <= '1';
				en_cycle <= '1';
				next_state <= FINISH;
				
			when FINISH =>
				busy_all <= '0';
				done <= '1';
				if (start = '1') then
					en_in <= '1';
					rst_cycle <= '1';
					next_state <= TRIG_1;
				else
					next_state <= FINISH;
				end if;
		end case;
	end process;
end behavioral;