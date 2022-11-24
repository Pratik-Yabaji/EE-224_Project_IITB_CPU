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
        current_state : in std_logic_vector(5 downto 0);

        reg_d1 : out std_logic_vector(15 downto 0);
        reg_d2 : out std_logic_vector(15 downto 0)
        
    );
end register_file;

architecture bhave of register_file is
type mem_array is array (0 to 7 ) of std_logic_vector (15 downto 0);
signal registers: mem_array :=(
    x"0001",b"0000000000001111", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000"
    );
begin
    read_proc: process( reg_a1, reg_a2)
    begin
        reg_d1 <= registers(to_integer(unsigned(reg_a1)));
        reg_d2 <= registers(to_integer(unsigned(reg_a2)));
    end process;

    write_proc: process(clock)
    begin
        if (falling_edge(clock)) then
            case current_state is
                when "001101" | "001110" | "001111" | "010000" | "010001" | "010010" | "010100" | "010101" | "000100" | "001010" | "001000" | "100010" | "100011" =>
                registers(to_integer(unsigned(reg_a3))) <= reg_d3;
                when others =>
                null;
            end case;
        end if;
    end process;
end bhave;











