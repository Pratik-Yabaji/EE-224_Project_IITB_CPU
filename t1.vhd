library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t1 is
    port(
        current_state : in std_logic_vector(5 downto 0);
        reg_d1_ip : in std_logic_vector(15 downto 0);

        t1_op : out std_logic_vector(15 downto 0)
    );
end t1;

architecture bhave of t1 is
    begin
        t1_proc:process(current_state)
        begin
            t1_op <= reg_d1_ip;
        end process;
end bhave;
