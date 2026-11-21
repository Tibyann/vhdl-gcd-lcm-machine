--FSM GCD

--Deskripsi:
--Blok ini berfungsi sebagai unit control GCD.


--FSM GCD (2 State - Fast Barrel Shift)

library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_gcd is
	port (
			start_GCD, clk, done_sub_shift : in std_logic; 
			en_A, load_A, en_B, load_B, en_count, rst_count, en_D, busy_GCD : out std_logic
		  ); 
end fsm_gcd;

architecture behavioral of fsm_gcd is
	type state_type is (IDLE, SUB_SHIFT);
	signal current_state, next_state : state_type := IDLE;
begin
	process (clk)
	begin
		if rising_edge (clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process (start_GCD, done_sub_shift, current_state)
	begin
		case current_state is
			when IDLE =>
				load_A <= '1';
				load_B <= '1';
				busy_GCD <= '0';
				rst_count <= '1';
				en_D <= '0';
				en_count <= '0';
				
				if (start_GCD = '1') then
					en_A <= '1';
					en_B <= '1';
					next_state <= SUB_SHIFT;
				else
					en_A <= '0';
					en_B <= '0';
					next_state <= IDLE;
				end if;			
			
			when SUB_SHIFT =>
				load_A <= '0';
				load_B <= '0';
				busy_GCD <= '1';
				rst_count <= '0';
				
				if (done_sub_shift = '1') then
					en_A <= '0';
					en_B <= '0';
					en_D <= '1';
					en_count <= '0';
					next_state <= IDLE;
				else
					en_A <= '1';
					en_B <= '1';
					en_D <= '0';
					en_count <= '1';
					next_state <= SUB_SHIFT;
				end if;
		end case;
	end process;
end behavioral;
