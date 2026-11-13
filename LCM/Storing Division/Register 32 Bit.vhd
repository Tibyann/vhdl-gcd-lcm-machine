--REGISTER 32 BIT

--Deskripsi:
--Blok ini berfungsi untuk menyimpan data berukuran 32 bit.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity register_32_bit is
	port	(
				D		:	in		std_logic_vector (31 downto 0);	
				en		:	in		std_logic;								
				clk	:	in		std_logic;								
				Q		:	out	std_logic_vector (31 downto 0)
			);
end register_32_bit;


-- Define Architecture
architecture rtl of register_32_bit is
	signal reg : std_logic_vector(31 downto 0) := (others => '0');
begin
	process (clk)
	begin
		if rising_edge (clk) then
			if(en = '1') then
				reg <= D;
			end if;
		end if;
	end process;
	
	Q <= reg;
end rtl;
	