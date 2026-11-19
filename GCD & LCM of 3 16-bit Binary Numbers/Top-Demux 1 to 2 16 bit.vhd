--DEMUX 1 to 2 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk memilih jalur data 16 bit yang akan diteruskan.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity demux_1_to_2_16_bit is
	port	(
				A			:		in		std_logic_vector (15 downto 0);	
				sel		:		in		std_logic;								
				data_0	:		out	std_logic_vector (15 downto 0);
				data_1	: 		out	std_logic_vector (15 downto 0)
			);
end demux_1_to_2_16_bit;


-- Define Architecture
architecture rtl of demux_1_to_2_16_bit is
begin
	process (sel, A)
	begin
		if (sel = '1') then
			data_0 <= (others => '0');
			data_1 <= A;
		else
			data_1 <= (others => '0');
			data_0 <= A;
		end if;
	end process;
end rtl;
	