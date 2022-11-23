library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_7_shifter is
    port (shift_ip_7 : in std_logic_vector(8 downto 0);
          current_state : in std_logic_vector(5 downto 0);
          shift_op_7 : out std_logic_vector(15 downto 0)
          );
end bit_7_shifter;

architecture bhv of bit_7_shifter is
    begin
        bit_7_shifter_proc: process(shift_ip_7)
        variable i : integer;
        begin
            if (current_state = "000111") then --s7
                shift_op_7(6 downto 0) <= "0000000";
                for i in 0 to 8 loop
                    shift_op_7(i + 7) <= shift_ip_7(i);
                end loop;
            end if;
        end process;
end bhv;