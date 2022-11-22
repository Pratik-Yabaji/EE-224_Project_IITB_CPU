library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bit_1_shifter is
    port (shift_ip_1 : in std_logic_vector(15 downto 0);
          current_state : in std_logic_vector(5 downto 0);
          shift_op_1 : out std_logic_vector(15 downto 0)
          );
end entity;

architecture bhv of bit_1_shifter is
    begin
        bit_1_shifter_proc: process(shift_ip_1)
        variable i : integer;
        begin
            if (current_state = "000000") then --s0
                shift_op_1(0) <= '0';
                for i in 0 to 14 loop
                    shift_op_1(i + 1) <= shift_ip_1(i);
                end loop;
            end if;
        end process;
end bhv;