library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sign_10_extender is 
    port(se_ip_10 : in std_logic_vector(8 downto 0);
         current_state : in std_logic_vector(5 downto 0);
         se_op_10 : out std_logic_vector(15 downto 0);
         )
end entity;

architecture bhv of sign_10_extender is
    begin
        sign_10_extender_proc: process(se_ip_10,current_state)
        variable temp : integer;
        begin
            if (current_state = "000101" or current_state = "100000") then -- s5 s32
                temp := to_integer(se_ip_10);
                se_op_10 <= std_logic_vector(to_signed(temp,16));
            end if;
        end process;
end bhv;

