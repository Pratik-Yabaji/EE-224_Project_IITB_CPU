library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t2 is
    port(
        current_state : in std_logic_vector(5 downto 0);
        reg_d2_ip : in std_logic_vector(15 downto 0);
        memory_data : in std_logic_vector(15 downto 0);

        t2_op : out std_logic_vector(15 downto 0)
    );
end t2;

architecture bhave of t2 is
    begin
        t2_proc:process(current_state, reg_d2_ip, memory_data)
        begin
            case current_state is
                when "001100" =>
                    t2_op <= memory_data;
                when others =>
                    t2_op <= reg_d2_ip;
            end case;
        end process;
end bhave;
