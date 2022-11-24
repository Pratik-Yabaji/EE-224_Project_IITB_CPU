library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity d3_mux is
    port(
		  clock  : in std_logic;
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
        d3_mux_proc:process(clock)
        begin
		  if (falling_edge(clock)) then
            case current_state is
                when "000100" | "000110" => --s4 --s6
                    reg_d3 <= t3;
                    -- reg_d3 <= "0000000011111111";
                when "001010" => --s10
                    reg_d3 <= t1;
                when "001101" | "001110" | "001111" | "010000" | "010001" | "010010" | "010100" | "010101"=> --s13 14 15 16 17 18 20 21
                    reg_d3 <= t2;
                when "001000" => --s8
                    reg_d3 <= shift_op_7;
                when "100010" | "100011" => --s34 35
                    reg_d3 <= pc;
                when others =>
                    null;
            end case;
			end if;
        end process;
end bhave;