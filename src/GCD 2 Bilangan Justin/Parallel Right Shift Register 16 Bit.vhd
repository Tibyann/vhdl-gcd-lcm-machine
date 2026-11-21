--PARALLEL RIGHT SHIFT REGISTER 16 BIT
--Deskripsi:
--Blok ini berfungsi untuk me-load data secara paralel, menggesernya ke kanan, dan menyimpannya dalam ukuran 32 bit.


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prl_Rshift_register_16_bit is
	port	(
				D				:	in		std_logic_vector (31 downto 0);	
				en				:	in		std_logic;
				shift_amt	:	in		std_logic_vector (2 downto 0);
				clk			:	in		std_logic;								
				Q				:	out	std_logic_vector (31 downto 0)
			);
end prl_Rshift_register_16_bit;

architecture rtl of prl_Rshift_register_16_bit is
	signal shift_reg : std_logic_vector(31 downto 0) := (others => '0');
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if (en = '1') then
				case shift_amt is
					when "001"  => shift_reg <= "0" & D(31 downto 1);
					when "010"  => shift_reg <= "00" & D(31 downto 2);
					when "011"  => shift_reg <= "000" & D(31 downto 3);
					when "100"  => shift_reg <= "0000" & D(31 downto 4);
					when others => shift_reg <= D; -- Load saja (shift 0)
				end case;
			end if;
		end if;
	end process;
	
	Q <= shift_reg;
end rtl;
