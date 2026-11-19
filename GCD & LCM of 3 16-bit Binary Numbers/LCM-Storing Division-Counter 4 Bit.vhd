--COUNTER 4 BIT

--Deskripsi:
--Blok ini berfungsi untuk menghitung secara incremental, berukuran 4 bit.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity counter_4_bit is
	port	(
				en		:	in		std_logic;						
				rst	:	in		std_logic;						
				clk	:	in		std_logic;						
				count	:	out	std_logic_vector (3 downto 0)
			);
end counter_4_bit;


-- Define Architecture
architecture rtl of counter_4_bit is
	signal count_temp	:	unsigned (3 downto 0):="0000";
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				count_temp <= "0000";
			else
				if(en = '1') then
					count_temp <= count_temp + 1;
				end if;
			end if;
		end if;
	end process;
	
	count <= std_logic_vector(count_temp);
end rtl;