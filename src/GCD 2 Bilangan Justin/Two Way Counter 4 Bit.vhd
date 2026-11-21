--TWO-WAY COUNTER 4 BIT

--Deskripsi:
--Blok ini berfungsi untuk menghitung secara incremental atau decremental, berukuran 4 bit. way= 0 turun, way = 1 naik


--ACCUMULATOR COUNTER 5 BIT (UNTUK FAKTOR 2^k)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity two_way_counter_4_bit is
	port	(
				en			:	in		std_logic;
				add_val	:	in		std_logic_vector (2 downto 0);
				rst		:	in		std_logic;						
				clk		:	in		std_logic;						
				count		:	out	std_logic_vector (4 downto 0)
			);
end two_way_counter_4_bit;

architecture rtl of two_way_counter_4_bit is
	signal count_temp : unsigned (4 downto 0) := "00000";
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if (rst = '1') then
				count_temp <= "00000";
			elsif (en = '1') then
				count_temp <= count_temp + resize(unsigned(add_val), 5);
			end if;
		end if;
	end process;
	
	count <= std_logic_vector(count_temp);
end rtl;