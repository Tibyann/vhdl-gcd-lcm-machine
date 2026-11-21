--PARALLEL LEFT SHIFT REGISTER 32 BIT

--Deskripsi:
--Blok ini berfungsi untuk me-load data secara paralel, menggesernya ke kiri, dan menyimpannya dalam ukuran 32 bit.
--Barrel Left Shift Register 32 bit 

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prl_Lshift_register_16_bit is
	port	(
				D				:	in		std_logic_vector (31 downto 0);	
				en				:	in		std_logic;
				shift_amt	:	in		std_logic_vector (4 downto 0);
				clk			:	in		std_logic;								
				Q				:	out	std_logic_vector (31 downto 0)
			);
end prl_Lshift_register_16_bit;

architecture rtl of prl_Lshift_register_16_bit is
	signal shift_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if (en = '1') then
				shift_reg <= std_logic_vector(shift_left(unsigned(D), to_integer(unsigned(shift_amt))));
			end if;
		end if;
	end process;
	
	Q <= shift_reg;
end rtl;
