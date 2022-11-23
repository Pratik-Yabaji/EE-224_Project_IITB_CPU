library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir is
    port(
        current_state : in std_logic_vector(5 downto 0);
        ir_mem_data : in std_logic_vector(15 downto 0);
        clock    : in std_logic;

        ir_out : out std_logic_vector(15 downto 0);
        shift_ip_7 : out std_logic_vector(8 downto 0);
        se_ip_10 : out std_logic_vector(5 downto 0)
        );
end ir;

architecture bhave of ir is

    begin
    write_proc: process(clock)
        begin
            if(falling_edge(clock)) then
                if(current_state="000001") then
                    ir_out <= ir_mem_data;
                end if;
            end if;
        end process;
    
    read_proc: process(clock)
        begin
            case current_state is
                when ("000101" or "100000") => --s5 --s32
                    se_ip_10 <= ir_mem_data(5 downto 0);
                when "001000" => --s8
                    shift_ip_7 <= ir_mem_data(8 downto 0);
                when others =>
                    null;
            end case;
        end process;
end bhave;