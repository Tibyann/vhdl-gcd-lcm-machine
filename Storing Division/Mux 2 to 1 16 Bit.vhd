--MUX 2 to 1 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk memilih jalur data 16 bit yang akan diteruskan.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity mux_2_to_1_16_bit is
	port	(
				A		:		in		std_logic_vector (15 downto 0);	
				B		:		in		std_logic_vector (15 downto 0);	
				sel	:		in		std_logic;								
				data	:		out	std_logic_vector (15 downto 0)
			);
end mux_2_to_1_16_bit;


-- Define Architecture
architecture rtl of mux_2_to_1_16_bit is
begin
	process (sel, A, B)
	begin
		if (sel = '1') then
			data <= B;
		else
			data <= A;
		end if;
	end process;
end rtl;
	