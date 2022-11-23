library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
    port(
        t3_addr : in std_logic_vector(15 downto 0);
        t2_data : in std_logic_vector(15 downto 0);
        t1_addr : in std_logic_vector(15 downto 0);
        t1_data : out std_logic_vector(15 downto 0);
	    ir_addr: in std_logic_vector(15 downto 0);        
        ir_data: out std_logic_vector(15 downto 0);
        data_out: out std_logic_vector(15 downto 0);

        clock : in std_logic;
        current_state : in std_logic_vector(5 downto 0);
    );
end memory;

architecture bhave of memeory is
    type mem_array is array (0 to 31 ) of std_logic_vector (15 downto 0);
    signal mem_data: mem_array :=(
    x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
    x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000"
   ); 
	
	
	signal mem_ir: mem_array := (
	b"0000001011111000", x"FFFF", x"FFFF", x"0000",
	x"FFFF",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
    x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000",
	x"0000",x"0000", x"0000", x"0000"
	);

    begin
    data_write_proc:process(clock)
    begin
        if (falling_edge(clock)) then
            if(state="001011") then
                mem_data(to_integer(unsigned(t3_addr))) <= data_t2;
            elsif(state="010110") then
                 mem_data(to_integer(unsigned(t1_addr))) <= data_t2;
            end if;
        end if;
    end process;
    mem_read: process(current_state, t1_addr, t3_addr)
	begin
		if(state ="001100" or state="011000") then --s12 s22
			data_out <= mem_data(to_integer(unsigned(t1_addr)));
		elsif (state="001001") then --s9
			data_out<= mem_data(to_integer(unsigned(t3_addr)));
		end if;
	end process;
end bhave;