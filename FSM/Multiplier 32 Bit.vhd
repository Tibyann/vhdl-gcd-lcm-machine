--MULTIPLIER 32 BIT

--Deskripsi:
--Blok ini berfungsi untuk mengalikan hasil pembagian 16 bit dengan bilangan 32 bit untuk mencari nilai LCM.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity multiplier_32_bit is
	port	(
				A		:	in		std_logic_vector (15 downto 0);	
				B		:	in		std_logic_vector (31 downto 0);
				R		:	out	std_logic_vector (31 downto 0)		
			);
end multiplier_32_bit;


-- Define Architecture
architecture rtl of multiplier_32_bit is
	signal mult_temp : unsigned (47 downto 0);
begin
	mult_temp <= unsigned(A) * unsigned(B);
	R <= std_logic_vector(mult_temp(31 downto 0));
end rtl;