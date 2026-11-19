--PARALLEL RIGHT SHIFT REGISTER 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk me-load data secara paralel, menggesernya ke kanan, dan menyimpannya dalam ukuran 16 bit.


--Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity prl_Rshift_register_16_bit is
	port	(
				D				:	in		std_logic_vector (15 downto 0);	
				en				:	in		std_logic;
				en_shift    :  in 	std_logic;
				clk			:	in		std_logic;								
				Q				:	out	std_logic_vector (15 downto 0)
			);
end prl_Rshift_register_16_bit;


--Define Architecture
architecture rtl of prl_Rshift_register_16_bit is
	signal shift_reg : std_logic_vector(15 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if ((en AND en_shift) = '1') then
               --Load dan geser ke kanan 1 bit
               shift_reg <= '0' & D(15 downto 1);
				elsif ((en AND (NOT en_shift)) = '1') then
					--Load saja
               shift_reg <= D;
            end if;
        end if;
    end process;
	 
    Q <= shift_reg;
end rtl;
	