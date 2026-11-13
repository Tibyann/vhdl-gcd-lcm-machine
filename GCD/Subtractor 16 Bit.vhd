--SUBTRACTOR 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk mengurangi bilangan biner 16 bit dengan bilangan biner 16 bit. Jika B_out 1, hasilnya negatif.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity subtractor_16_bit is
	port	(
				A		 :	in		std_logic_vector (15 downto 0);	
				B		 :	in		std_logic_vector (15 downto 0);
				B_out  : out  	std_logic;
				R		 :	out	std_logic_vector (15 downto 0)		
			);
end subtractor_16_bit;


-- Define Architecture
architecture rtl of subtractor_16_bit is
	signal diff : unsigned (16 downto 0); --Sinyal Diff sengaja dibuat 17 bit agar dapat menampung B_out
begin
	diff <= resize(unsigned(A), 17) - resize(unsigned(B), 17);
	B_out <= diff(16);  
	R <= std_logic_vector(diff(15 downto 0));
end rtl;