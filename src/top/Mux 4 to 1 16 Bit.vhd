--MUX 4 to 1 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk memilih salah satu dari 4 jalur data 16 bit yang akan diteruskan.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity mux_4_to_1_16_bit is
	port	(
				A		:	in		std_logic_vector (31 downto 0);	
				B		:	in		std_logic_vector (31 downto 0);	
				C		:	in		std_logic_vector (31 downto 0);	
				D		:	in		std_logic_vector (31 downto 0);	
				sel	:	in		std_logic_vector (1 downto 0);								
				data	:	out	std_logic_vector (31 downto 0)
			);
end mux_4_to_1_16_bit;


-- Define Architecture
architecture rtl of mux_4_to_1_16_bit is
begin
	process (sel, A, B, C, D)
	begin
		case sel is
			when "00" =>
				data <= A;
			when "01" =>
				data <= B;
			when "10" =>
				data <= C;
			when others =>
				data <= D;
		end case;
	end process;
end rtl;