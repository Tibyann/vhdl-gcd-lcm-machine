--MULTIPLIER 16x16 BIT

--Deskripsi:
--Blok ini berfungsi untuk mengalikan bilangan biner 16 bit dengan bilangan biner 16 bit.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity mult_16x16_bit is
	port	(
				A		 :	in		std_logic_vector (15 downto 0);	
				B		 :	in		std_logic_vector (15 downto 0);
				M		 :	out	std_logic_vector (31 downto 0)		
			);
end mult_16x16_bit;


-- Define Architecture
architecture rtl of mult_16x16_bit is
begin
	M <= std_logic_vector(unsigned(A)*unsigned(B));
end rtl;