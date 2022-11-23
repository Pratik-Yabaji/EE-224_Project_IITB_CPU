library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
    port(
        alu_in : in std_logic_vector(15 downto 0); -- from alu
        alu_out : out std_logic_vector(15 downto 0); -- to alu
        reg_in_d2 : in std_logic_vector(15 downto 0);
        reg_out_d1 : out std_logic_vector(15 downto 0);
        pc_mem : out std_logic_vector(15 downto 0);
        current_state : in std_logic_vector(5 downto 0);
        clock : in std_logic
    );
end pc;

architecture bhave of pc is
    signal pc: std_logic_vector(15 downto 0) := x"0000";
    begin
        pc_read: process(current_state)
        begin 
            case current_state is
                when "000001" =>
                    pc_mem <= pc;
                    alu_out <= pc;
                when "100001"  |  "100000" =>
                    alu_out <=pc;
                when "100010"  |  "100011" =>
                    reg_out_d1<=pc;
                when others =>
                    null;
            end case;
         end process;
        
         regs_write: process(clock)
        begin
            if (falling_edge(clock)) then
                case  current_state is
                    when "000001"  |  "100000"  |  "100101"  =>
                        pc <= alu_in;
                    when "100011" =>
                        pc <= reg_in_d2;
                    when others =>
                        null;
                end case;
            end if;	
        end process;
end bhave;