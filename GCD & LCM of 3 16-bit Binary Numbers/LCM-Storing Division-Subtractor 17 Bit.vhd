--SUBTRACTOR 17 BIT

--Deskripsi:
--Blok ini berfungsi untuk mengurangi bilangan biner 17 bit dengan bilangan biner 17 bit, dibuat khusus 
--untuk restoring division. Jika B_out 1, hasilnya negatif.


-- Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Define Entity
entity subtractor_17_bit is
	port	(
				A		 :	in		std_logic_vector (16 downto 0);	
				B		 :	in		std_logic_vector (16 downto 0);
				B_out  : out  	std_logic;
				R		 :	out	std_logic_vector (16 downto 0)		
			);
end subtractor_17_bit;


-- Define Architecture
architecture rtl of subtractor_17_bit is
	signal diff : unsigned (17 downto 0); --Sinyal diff sengaja dibuat 18 bit agar dapat menampung B_out
begin
	diff <= resize(unsigned(A), 18) - resize(unsigned(B), 18);
	B_out <= diff(17);  
	R <= std_logic_vector(diff(16 downto 0));
end rtl;