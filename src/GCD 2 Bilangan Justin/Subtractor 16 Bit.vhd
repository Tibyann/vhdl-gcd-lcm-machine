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
				A		 :	in		std_logic_vector (31 downto 0);	
				B		 :	in		std_logic_vector (31 downto 0);
				B_out  : out  	std_logic;
				R		 :	out	std_logic_vector (31 downto 0)		
			);
end subtractor_16_bit;

architecture rtl of subtractor_16_bit is
	signal diff : unsigned (32 downto 0); --33 bit untuk menampung B_out
begin
	diff <= resize(unsigned(A), 33) - resize(unsigned(B), 33);
	B_out <= diff(32);  
	R <= std_logic_vector(diff(31 downto 0));
end rtl;