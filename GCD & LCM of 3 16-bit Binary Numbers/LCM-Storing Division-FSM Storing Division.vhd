--FSM STORING DIVISION

--Deskripsi:
--Blok ini berfungsi sebagai unit control storing divison.


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity fsm_storing_division is
    port (
			 start, clk, last : in std_logic; 
          en_A, load_A, en_B, en_D, en_count, rst_count, busy : out std_logic
			 ); 
end fsm_storing_division;


--Define Architecture
architecture behavioral of fsm_storing_division is
	type state_type is (IDLE, COUNT);
	signal current_state, next_state : state_type := IDLE;
begin
	process (clk)
	begin
		if rising_edge (clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process (start, last, current_state)
	begin
		case current_state is
			when IDLE =>
				load_A <= '1';
				busy <= '0';
				en_D <= '0';
				en_count <= '0';
				rst_count <= '1';
				
				if (start = '1') then
					en_A <= '1';
					en_B <= '1';
					next_state <= COUNT;
				else
					en_A <= '0';
					en_B <= '0';
					next_state <= IDLE;
				end if;
			
			when COUNT =>
				load_A <= '0';
				busy <= '1';
				en_D <= '1';
				en_count <= '1';
				rst_count <= '0';
				
				if (last = '0') then
					en_A <= '1';
					en_B <= '0';
					next_state <= COUNT;
				else
					en_A <= '1';
					en_B <= '0';
					next_state <= IDLE;
				end if;
		end case;
	end process;
end behavioral;
