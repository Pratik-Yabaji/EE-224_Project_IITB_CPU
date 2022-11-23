library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity t3 is
    port(
        current_state : in std_logic_vector(5 downto 0);
        alu_out : in std_logic_vector(15 downto 0);

        t3_op : out std_logic_vector(15 downto 0)
    );
end t3;

architecture bhave of t3 is
    begin
        t3_proc:process(current_state,alu_out)
        begin
            t3_op <= alu_out;
        end process;
end bhave;