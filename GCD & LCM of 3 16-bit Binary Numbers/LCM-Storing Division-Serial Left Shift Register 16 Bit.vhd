--SERIAL LEFT SHIFT REGISTER 16 BIT

--Deskripsi:
--Blok ini berfungsi untuk menerima data secara serial, menggeser ke kiri, dan menyimpannya dalam ukuran 16 bit.


--Library
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


--Define Entity
entity srl_Lshift_register_16_bit is
	port	(
				D_srl	:	in		std_logic;	
				en		:	in		std_logic;								
				clk	:	in		std_logic;								
				Q		:	out	std_logic_vector (15 downto 0)
			);
end srl_Lshift_register_16_bit;


--Define Architecture
architecture rtl of srl_Lshift_register_16_bit is
	signal shift_reg : std_logic_vector(15 downto 0) := (others => '0');
begin
    process (clk)
    begin
        if rising_edge(clk) then
            if en = '1' then
                -- Geser ke kiri 1 bit, masukkan D_srl di posisi LSB 
                shift_reg <= shift_reg(14 downto 0) & D_srl;
            end if;
        end if;
    end process;
	 
    Q <= shift_reg;
end rtl;
	