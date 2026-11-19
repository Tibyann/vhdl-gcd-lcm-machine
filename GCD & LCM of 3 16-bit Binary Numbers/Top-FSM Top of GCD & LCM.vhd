--FSM TOP OF GCD & LCM

--Deskripsi:
--Blok ini berfungsi sebagai unit control top of GCD & LCM.
--PHASE 1: GCD(A,B), GCD(B,C), GCD(C,A)
--PHASE 2: GCD(A,B,C), A/GCD(A,B), B/GCD(B,C), C/GCD(C,A)
--PHASE 3: A/GCD(A,B) x GCD(A,B,C) x B/GCD(B,C) x C/GCD(C,A) = LCM(A,B,C)


--Library
library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity fsm_top_gcd_lcm is
    port (
			 start, clk, busy_GCD_1, busy_GCD_2, busy_GCD_3, busy_div_1, busy_div_2, busy_div_3, one_is_zero : in std_logic; 
          en_A, en_B, en_C, en_GCD_AB, en_GCD_BC, en_GCD_CA, en_GCD_ABC, en_Rdiv_1, en_Rdiv_2, en_Rdiv_3, en_LCM_ABC : out std_logic;
			 start_GCD_1, start_GCD_2, start_GCD_3, start_div_1, start_div_2, start_div_3, sel_load2, sel_LCM_zero, busy : out std_logic
			 ); 
end fsm_top_gcd_lcm;


--Define Architecture
architecture behavioral of fsm_top_gcd_lcm is
	type state_type is (IDLE, LOAD_1, PHASE_1, LOAD_2, PHASE_2, LOAD_3, PHASE_3);
	signal current_state, next_state : state_type := IDLE;
begin
	process (clk)
	begin
		if rising_edge (clk) then
			current_state <= next_state;
		end if;
	end process;
	
	process (start, busy_GCD_1, busy_GCD_2, busy_GCD_3, busy_div_1, busy_div_2, busy_div_3, one_is_zero, current_state)
	begin
		case current_state is
			when IDLE =>
				sel_load2 <= '0';
				busy <= '0';
				
				if (start = '1') then
					en_A <= '1';
					en_B <= '1';
					en_C <= '1';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='0';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= LOAD_1;
				else
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='0';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= IDLE;
				end if;			
			
			when LOAD_1 =>
				sel_load2 <= '0';
				busy <= '1';
				
				en_A <= '0';
				en_B <= '0';
				en_C <= '0';
				en_GCD_AB <= '0';
				en_GCD_BC <= '0';
				en_GCD_CA <= '0';
				en_GCD_ABC <= '0';
				en_Rdiv_1 <= '0';
				en_Rdiv_2 <= '0';
				en_Rdiv_3 <= '0';
				en_LCM_ABC <= '0';
				start_GCD_1 <= '1';
				start_GCD_2 <= '1';
				start_GCD_3 <='1';
				start_div_1 <= '0';
				start_div_2 <= '0';
				start_div_3 <= '0';
				sel_LCM_zero <= '0';
					
				next_state <= PHASE_1;
				
			when PHASE_1 =>
				sel_load2 <= '0';
				busy <= '1';
				
				if ((busy_GCD_1 OR busy_GCD_2 OR busy_GCD_3) = '1') then
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='0';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= PHASE_1;
				else
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '1';
					en_GCD_BC <= '1';
					en_GCD_CA <= '1';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='0';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= LOAD_2;
				end if;
				
			when LOAD_2 =>
				sel_load2 <= '1';
				busy <= '1';
				
				if (one_is_zero = '1') then
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='1';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= PHASE_2;
				else
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='1';
					start_div_1 <= '1';
					start_div_2 <= '1';
					start_div_3 <= '1';
					sel_LCM_zero <= '0';
					
					next_state <= PHASE_2;
				end if;	
				
			when PHASE_2 =>
				sel_load2 <= '1';
				busy <= '1';
				
				if ((busy_GCD_3 OR busy_div_1 OR busy_div_2 OR busy_div_3) = '1') then
					en_A <= '0';
					en_B <= '0';
					en_C <= '0';
					en_GCD_AB <= '0';
					en_GCD_BC <= '0';
					en_GCD_CA <= '0';
					en_GCD_ABC <= '0';
					en_Rdiv_1 <= '0';
					en_Rdiv_2 <= '0';
					en_Rdiv_3 <= '0';
					en_LCM_ABC <= '0';
					start_GCD_1 <= '0';
					start_GCD_2 <= '0';
					start_GCD_3 <='0';
					start_div_1 <= '0';
					start_div_2 <= '0';
					start_div_3 <= '0';
					sel_LCM_zero <= '0';
					
					next_state <= PHASE_2;
				else
					if (one_is_zero = '1') then
						en_A <= '0';
						en_B <= '0';
						en_C <= '0';
						en_GCD_AB <= '0';
						en_GCD_BC <= '0';
						en_GCD_CA <= '0';
						en_GCD_ABC <= '1';
						en_Rdiv_1 <= '0';
						en_Rdiv_2 <= '0';
						en_Rdiv_3 <= '0';
						en_LCM_ABC <= '1';
						start_GCD_1 <= '0';
						start_GCD_2 <= '0';
						start_GCD_3 <='0';
						start_div_1 <= '0';
						start_div_2 <= '0';
						start_div_3 <= '0';
						sel_LCM_zero <= '1';
					
						next_state <= IDLE;
					else
						en_A <= '0';
						en_B <= '0';
						en_C <= '0';
						en_GCD_AB <= '0';
						en_GCD_BC <= '0';
						en_GCD_CA <= '0';
						en_GCD_ABC <= '1';
						en_Rdiv_1 <= '1';
						en_Rdiv_2 <= '1';
						en_Rdiv_3 <= '1';
						en_LCM_ABC <= '0';
						start_GCD_1 <= '0';
						start_GCD_2 <= '0';
						start_GCD_3 <='0';
						start_div_1 <= '0';
						start_div_2 <= '0';
						start_div_3 <= '0';
						sel_LCM_zero <= '0';
					
						next_state <= LOAD_3;
					end if;
				end if;
				
			when LOAD_3 =>
				sel_load2 <= '1';
				busy <= '1';
				
				en_A <= '0';
				en_B <= '0';
				en_C <= '0';
				en_GCD_AB <= '0';
				en_GCD_BC <= '0';
				en_GCD_CA <= '0';
				en_GCD_ABC <= '0';
				en_Rdiv_1 <= '0';
				en_Rdiv_2 <= '0';
				en_Rdiv_3 <= '0';
				en_LCM_ABC <= '0';
				start_GCD_1 <= '0';
				start_GCD_2 <= '0';
				start_GCD_3 <='0';
				start_div_1 <= '0';
				start_div_2 <= '0';
				start_div_3 <= '0';
				sel_LCM_zero <= '0';
					
				next_state <= PHASE_3;
			
			when PHASE_3 =>
				sel_load2 <= '1';
				busy <= '1';
				
				en_A <= '0';
				en_B <= '0';
				en_C <= '0';
				en_GCD_AB <= '0';
				en_GCD_BC <= '0';
				en_GCD_CA <= '0';
				en_GCD_ABC <= '0';
				en_Rdiv_1 <= '0';
				en_Rdiv_2 <= '0';
				en_Rdiv_3 <= '0';
				en_LCM_ABC <= '1';
				start_GCD_1 <= '0';
				start_GCD_2 <= '0';
				start_GCD_3 <='0';
				start_div_1 <= '0';
				start_div_2 <= '0';
				start_div_3 <= '0';
				sel_LCM_zero <= '0';
					
				next_state <= IDLE;
				
		end case;
	end process;
end behavioral;
