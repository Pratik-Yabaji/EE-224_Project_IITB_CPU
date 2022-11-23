library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_UNSIGNED.all;
library work;
use ieee.numeric_std.all;

entity alu is
    port (
        alu_a : in std_logic_vector(15 downto 0);
        alu_b : in std_logic_vector(15 downto 0);
        alu_ir : in std_logic_vector(1 downto 0);
        alu_out : out std_logic_vector(15 downto 0);

        alu_carry : out std_logic;
        alu_zero : out std_logic


    );
end alu;

architecture bhave of alu is

constant zero: std_logic_vector(15 downto 0) := "0000000000000000";
constant one : std_logic_vector(15 downto 0) := "0000000000000001";
signal temp_out: std_logic_vector(15 downto 0);

begin
    -- Performing Operation
alu_proc:process(alu_a, alu_b,alu_ir)
begin
    if (alu_ir = "00") then
        alu_out <= alu_a + alu_b;
		  temp_out <= alu_a + alu_b;
        -- Modifying Carry flag
            if (((alu_a(15) and alu_b(15)) or 
                ((not temp_out(15)) and (( alu_a(15) and (not alu_b(15))) or (alu_b(15) and (not alu_a(15)))))) = '1') then
                alu_carry <= '1';
            else
                alu_carry <= '0';
            end if;
    elsif (alu_ir = "01") then -- sub
        alu_out <= alu_a - alu_b;
        temp_out <= alu_a - alu_b;
    elsif (alu_ir = "10") then -- nand
        alu_out <= alu_a nand alu_b;
        temp_out <= alu_a nand alu_b;
    else
        null;
    end if;

    -- Modifying Zero flag
    if (temp_out = zero) then
        alu_zero <= '1';
    else
        alu_zero <= '0';
    end if;
	end process;
end bhave;