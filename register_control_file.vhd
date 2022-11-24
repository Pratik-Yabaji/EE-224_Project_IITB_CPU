library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register_control_file is
    port(
        ir     : in  std_logic_vector(15 downto 0);
        reg_a1 : out std_logic_vector(2 downto 0);
        reg_a2 : out std_logic_vector(2 downto 0);
        reg_a3 : out std_logic_vector(2 downto 0);

        clock  : in  std_logic;
        current_state  : in std_logic_vector(5 downto 0)
    );
end register_control_file;

architecture bhave of register_control_file is

begin
    register_control_file_proc_a1_and_a2:process(current_state, ir)
    begin
        case current_state is
            when "000010" | "100011"=> -- s2 -- s35
                reg_a1 <= ir(11 downto 9);
                reg_a2 <= ir(8 downto 6);
            when "010111" => --s23
                reg_a2 <= "000";
            when "011000" => --s24
                reg_a2 <= "001";
            when "011001" => --s25
                reg_a2 <= "010";
            when "011010" => --s26
                reg_a2 <= "011";
            when "011011" => --s27
                reg_a2 <= "100";
            when "011100" => --s28
                reg_a2 <= "101";
            when "011101" => --29
                reg_a2 <= "110";
            when "011110" => --30
                reg_a2 <= "111";
            when others =>
                null;
        end case;
    end process;

    register_control_file_proc_a3:process(current_state,ir)
    begin
        case current_state is
            when "000100" => -- s4
                reg_a3 <= ir(5 downto 3);
				when "000110" => -- s6
                reg_a3 <= ir(8 downto 6);
            when "001000" | "001010" | "100010" => -- s8 --s10 --s34
                reg_a3 <= ir(11 downto 9);
            when "001101" => --s13
                reg_a3 <= "000";
            when "001110" => --s14
                reg_a3 <= "001";
            when "001111" => --s15
                reg_a3 <= "010";
            when "010000" => --s16
                reg_a3 <= "011";
            when "010001" => --s17
                reg_a3 <= "100";
            when "010010" => --s18
                reg_a3 <= "101";
            when "010100" => --20
                reg_a3 <= "110";
            when "010101" => --21
                reg_a3 <= "111";
            when others =>
                null;
        end case;
    end process;
end bhave;