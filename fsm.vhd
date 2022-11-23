library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir_setter is
    port(   reset,clock:in std_logic;
            next_state: in std_logic_vector(5 downto 0);
            current_state: out std_logic_vector(5 downto 0)
              );
end ir_setter;

architecture bhave of ir_setter is
begin
clock_proc:process(clock,reset)
	begin
        if (clock='1' and clock' event) then
            if(reset = '1') then
                current_state <= "000000";
            else
                current_state <= next_state;
            end if;
        end if;
    end process;
end bhave;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ir_decoder is
    port(
            next_state: out std_logic_vector(5 downto 0);
            current_state: in std_logic_vector(5 downto 0);
            op_code: in std_logic_vector(3 downto 0);
            cz: in std_logic_vector(1 downto 0);
            imm: in std_logic_vector(8 downto 0);
            carry: in std_logic;
            zero: in std_logic
            );
    end ir_decoder;

architecture bhave of ir_decoder is
    begin
        state_proc:process(current_state)
        begin
            case current_state is
                when "111111" =>
                    next_state <= "111111";

                when "000001" => --s1
                    if (op_code = "0011") then 
                        next_state <= "001000";--s8
                    elsif(op_code = "1001") then
                        next_state <= "100011";--s35
                    elsif(op_code = "1000") then
                        next_state <= "100010";--s34
                    else
                        next_state <="000010"; --s2
                    end if;
                
                when "000010" => --s2
                    if(op_code = "0000") then
                        next_state <= "000011"; --s3
                    elsif(op_code = "0001") then 
                        next_state <= "000101"; --s5
                    elsif(op_code = "0010") then
                        next_state <= "000111"; --s7
                    elsif(op_code = "0110") then
                        if((imm(0) or imm(1) or imm(2) or imm(3) or imm(4) or imm(5) or imm(6) or imm(7)) = '1') then
                            next_state <= "001100"; --s12
                        end if;
                    elsif(op_code = "0111") then
                        if(imm(0) = '1') then
                            next_state <= "010111"; --s23
                        elsif(imm(1) = '1') then
                            next_state <= "011000"; --s24
                        elsif(imm(2) = '1') then
                            next_state <= "011001"; --s25
                        elsif(imm(3) = '1') then
                            next_state <= "011010"; --s26
                        elsif(imm(4) = '1') then
                            next_state <= "011011"; --s27
                        elsif(imm(5) = '1') then
                            next_state <= "011100"; --s28
                        elsif(imm(6) = '1') then
                            next_state <= "011101"; --s29
                        elsif(imm(7) = '1') then
                            next_state <= "011110"; --s30
                        end if;
                    elsif(op_code = "1100") then
                        next_state <= "011111"; --s31
                    end if;

                when "000011" => --s3
                    if(op_code = "0000") then
                        next_state <= "000100";--s4
                    end if;
                
                when "000100" => --s4
                    if(op_code = "0000" or op_code = "0010") then
                        next_state <= "000001"; --s1
                    end if;

                
                when "000101" => --s5
                    if(op_code = "0001") then
                        next_state <= "000110"; --s6
                    elsif(op_code = "0100") then
                        next_state <= "001001"; --s9
                    elsif(op_code = "0101") then
                        next_state <= "001011"; --s11
                    end if;
                
                when "000110" => --s6
                    if(op_code = "0001") then
                        next_state <= "000001"; -- s1
                    end if;

                when "000111" => --s7
                    if(op_code = "0010") then
                        next_state <= "000100"; -- s4
                    end if;

                when "001000" => --s8
                    if(op_code = "0011") then
                        next_state <= "000001"; -- s1
                    end if;

                when "001001" => --s9
                    if(op_code = "0100") then
                        next_state <= "001010"; -- s10
                    end if;

                when "001010" => --s10
                    if(op_code = "0100") then
                        next_state <= "000001"; -- s1
                    end if;

                when "001011" => --s11
                    if(op_code = "0101") then
                        next_state <= "000001"; -- s1
                    end if;

                when "001100" => --s12
                    if(imm(0) = '1') then
                        next_state <= "001101"; -- s13
                    elsif(imm(1) = '1') then
                        next_state <= "001110"; -- s14
                    elsif(imm(2) = '1') then
                        next_state <= "001111"; -- s15
                    elsif(imm(3) = '1') then
                        next_state <= "010000"; -- s16
                    elsif(imm(4) = '1') then
                        next_state <= "010001"; -- s17
                    elsif(imm(5) = '1') then
                        next_state <= "010010"; -- s18
                    elsif(imm(6) = '1') then
                        next_state <= "010100"; -- s20
                    elsif(imm(7) = '1') then
                        next_state <= "010101"; -- s21
                    end if;

                when "001101" ! "001110" ! "001111" ! "010000" ! "010001" ! "010010" ! "010100" ! "010110" => --s13 to 20 (exclude s19) and 22
                    next_state <= "010011";--s19
                
                when "010011" => --s19
                    next_state <= "000001"; -- s1

                when "010101" => --s21
                    next_state <= "000001";--s1

                when "010111" ! "011000" ! "011001" ! "011010" ! "011011" ! "011100" ! "011101" ! "011110" => --s23 to 30 --> s22
                    next_state <= "010110"; --s22
                    
                when "011111" => --s31
                    if (cz(0)='1') then 
                        next_state <= "100000"; --s32
							end if;
							
                when "100000" => --s32
                    if(op_code = "1100") then
                        next_state <= "100001"; -- s33
                    elsif(op_code = "1000") then
                        next_state <= "000001"; -- s1
							end if;
				when "100001" => --s33
                    next_state <= "000001"; --s1
                when "100010" => --s34
                    next_state <= "100000"; -- s32
                when "100011" => --s35
                    next_state <= "000001"; --s1
				when others =>
					null;
            end case;
        end process;
    end bhave;