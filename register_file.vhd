library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_file is
    port(
        reg_a1 : in std_logic_vector(2 downto 0);
        reg_a2 : in std_logic_vector(2 downto 0);
        reg_a3 : in std_logic_vector(2 downto 0);
        reg_d3 : in std_logic_vector(15 downto 0);
        clock  : in std_logic;

        reg_d1 : out std_logic_vector(15 downto 0);
        reg_d2 : out std_logic_vector(15 downto 0)
        
    );
end register_file;

architecture bhave of register_file is
type mem_array is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal registers: mem_array :=(
    x"0000",x"0000", x"0000", x"0000",
    x"0000",x"0000", x"0000", x"0000"
    );
begin
    read_proc: process( reg_a1, reg_a2)
    begin
        reg_d1 <= registers(to_integer(unsigned(reg_a1)));
        reg_d2 <= registers(to_integer(unsigned(reg_a2)));
    end process;

    write_proc: process(reg_a3)
    begin
        if (falling_edge(clock)) then
            registers(to_integer(unsigned(reg_a3))) <= reg_d3;
        else
            null;
        end if;
    end process;
end bhave;











