library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity alu_ip_mux is
    port(
        current_state : in std_logic_vector(15 downto 0); -- Selector

        t1 : in std_logic_vector(15 downto 0); 
        t2 : in std_logic_vector(15 downto 0);
        pc : in std_logic_vector(15 downto 0);
        se_op_10 : in std_logic_vector(15 downto 0);

        alu_a_ip : out std_logic_vector(15 downto 0);
        alu_b_ip : out std_logic_vector(15 downto 0);
        alu_ir_ip : out std_logic_vector(2 downto 0);
    );
end alu_ip_mux;

architecture bhave of alu_ip_mux is

constant zero: std_logic_vector(15 downto 0) := "0000000000000000";
constant one : std_logic_vector(15 downto 0) := "0000000000000001";

begin
    alu_ip_mux_proc:process(current_state,t1,t2,pc,se_op_10)
    begin
        case current_state is
            when "000001" => -- s1
                alu_a_ip <= pc;
                alu_b_ip <= one;
                alu_ir_ip <= "00"; -- ADD
            when "000011" => -- s3
                alu_a_ip <= t1;
                alu_b_ip <= t2;
                alu_ir_ip <= "00"; -- ADD
            when "000101" => -- s5
                alu_a_ip <= t1;
                alu_b_ip <= se_op_10;
                alu_ir_ip <= "00"; -- ADD
            when "000111" => -- s7
                alu_a_ip <= t1;
                alu_b_ip <= t2;
                alu_ir_ip <= "10"; -- NAND
            when "010011" => -- s19
                alu_a_ip <= t1;
                alu_b_ip <= one;
                alu_ir_ip <= "00"; -- ADD
            when "011111" => -- s31
                alu_a_ip <= t1;
                alu_b_ip <= t2;
                alu_ir_ip <= "01"; -- SUB
            when "100000" => -- s32
                alu_a_ip <= pc;
                alu_b_ip <= se_op_10;
                alu_ir_ip <= "00"; -- ADD
            when "100001" => -- s33
                alu_a_ip <= pc;
                alu_b_ip <= one;
                alu_ir_ip <= "01"; -- SUB
            when others =>
                null;
        end case;

end bhave;