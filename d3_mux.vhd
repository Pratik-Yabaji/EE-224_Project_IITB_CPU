library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_mux is
    port(
        current_state : in std_logic_vector(5 downto 0);
        t1 : in std_logic_vector(15 downto 0);
        t2 : in std_logic_vector(15 downto 0);
        t3 : in std_logic_vector(15 downto 0);
        pc : in std_logic_vector(15 downto 0);
        shift_op_7 : in std_logic_vector(15 downto 0);

        reg_d3 : out std_logic_vector(15 downto 0)
    );
end d3_mux;

architecture bhave of d3_mux is
    begin
        d3_mux_proc:process(current_state)
        begin
            case current_state is
                when "000100" => --s4
                    reg_d3 <= t3;
                when "001010" => --s10
                    reg_d3 <= t1;
                when ("001101" or "001110" or "001111" or "010000" or "010001" or "010010" or "010100" or "010101")=> --s13 14 15 16 17 18 20 21
                    reg_d3 <= t2;
                when "001000" => --s8
                    reg_d3 <= shift_op_7;
                when ("100010" or "100011") => --s34 35
                    reg_d3 <= pc;
                when others =>
                    null;
            end case;
        end process;
end bhave;