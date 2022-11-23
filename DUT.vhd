library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port (input_vector : in std_logic_vector(0 downto 0);
        output_vector: out std_logic_vector(6 downto 0)
        );
end entity;

architecture DutWrap of DUT is
    signal current_state: std_logic_vector(5 downto 0 ):="000001";
	signal next_state: std_logic_vector(5 downto 0 ):="000001";
    signal current_ir:std_logic_vector(15 downto 0 )
    signal clock: std_logic;
	signal reset: std_logic;
    signal carry, zero: std_logic;

    component ir_setter is
        port(   reset,clock:in std_logic;
                next_state: in std_logic_vector(5 downto 0);
                current_state: out std_logic_vector(5 downto 0)
                  );
    end component;

    component ir_decoder is
        port(
                next_state: out std_logic_vector(5 downto 0);
                current_state: in std_logic_vector(5 downto 0);
                op_code: in std_logic_vector(3 downto 0);
                cz: in std_logic_vector(1 downto 0);
                imm: in std_logic_vector(8 downto 0);
                op_out: out std_logic_vector(3 downto 0);
                carry: in std_logic;
                zero: in std_logic;
                );
        end component;

    component ir is
            port(
                current_state : in std_logic_vector(5 downto 0);
                ir_mem_data : in std_logic_vector(15 downto 0);
                clock    : in std_logic;
        
                ir_out : out std_logic_vector(15 downto 0);
                shift_ip_7 : out std_logic_vector(15 downto 0);
                se_ip_10 : out std_logic_vector(8 downto 0);
                );
        end component;
    
    component memory is
            port(
                t3_addr : in std_logic_vector(15 downto 0);
                t2_data : in std_logic_vector(15 downto 0);
                t1_add : in std_logic_vector(15 downto 0);
                t1_data : out std_logic_vector(15 downto 0);
                ir_addr: in std_logic_vector(15 downto 0);        
                ir_data: out std_logic_vector(15 downto 0);
                data_out: out std_logic_vector(15 downto 0);
        
                clock : in std_logic;
                current_state : in std_logic_vector(5 downto 0);
            );
        end component;

    component register_file is
            port(
                reg_a1 : in std_logic_vector(2 downto 0);
                reg_a2 : in std_logic_vector(2 downto 0);
                reg_a3 : in std_logic_vector(2 downto 0);
                reg_d3 : in std_logic_vector(15 downto 0);
                clock  : in std_logic;
        
                reg_d1 : out std_logic_vector(15 downto 0);
                reg_d2 : out std_logic_vector(15 downto 0);
                
            );
        end component;

    component pc is
            port(
                alu_in : in std_logic_vector(15 downto 0); -- from alu
                alu_out : in std_logic_vector(15 downto 0); -- to alu
                reg_in_d2 : in std_logic_vector(15 downto 0);
                reg_out_d1 : out std_logic_vector(15 downto 0);
                pc_mem : out std_logic_vector(15 downto 0);
                current_state : in std_logic_vector(5 downto 0);
                clock : in std_logic;
            )
        end component;
    
    component register_control_file is
            port(
                ir     : in  std_logic_vector(15 downto 0);
                reg_a1 : out std_logic_vector(2 downto 0);
                reg_a2 : out std_logic_vector(2 downto 0);
                reg_a3 : out std_logic_vector(2 downto 0);
        
                clock  : in  std_logic;
                current_state  : in std_logic_vector(5 downto 0);
            );
        end component;
    
    component sign_10_extender is 
        port(se_ip_10 : in std_logic_vector(8 downto 0);
             current_state : in std_logic_vector(5 downto 0);
             se_op_10 : out std_logic_vector(15 downto 0);
             )
        end component;

    component t1 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                reg_d1_ip : in std_logic_vector(15 downto 0);
        
                t1_op : out std_logic_vector(15 downto 0);
            );
        end component;

    component t2 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                reg_d2_ip : in std_logic_vector(15 downto 0);
                memory_data : in std_logic_vector(15 downto 0);

                t2_op : out std_logic_vector(15 downto 0);
            );
        end component;
    
    component t3 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                alu_out : in std_logic_vector(15 downto 0);
        
                t3_op : out std_logic_vector(15 downto 0);
            );
        end component;
    
    component d3_mux is
            port(
                current_state : in std_logic_vector(5 downto 0);
                t1 : in std_logic_vector(15 downto 0);
                t2 : in std_logic_vector(15 downto 0);
                t3 : in std_logic_vector(15 downto 0);
                pc : in std_logic_vector(15 downto 0);
                shift_op_7 : in std_logic_vector(15 downto 0);
        
                reg_d3 : out std_logic_vector(15 downto 0);
            );
        end component;

    component bit_1_shifter is
            port (shift_ip_7 : in std_logic_vector(15 downto 0);
                  current_state : in std_logic_vector(5 downto 0);
                  shift_op_7 : out std_logic_vector(15 downto 0);
                  );
        end component;

    component alu is
            port (
                alu_a : in std_logic_vector(15 downto 0);
                alu_b : in std_logic_vector(15 downto 0);
                alu_ir : in std_logic_vector(2 downto 0);
                alu_out : out std_logic_vector(15 downto 0);
        
                alu_carry : out std_logic;
                alu_zero : out std_logic;
            );
        end component;

    component alu_ip_mux is
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
        end component;

begin
    output_vector(5 downto 0) <= current_state;
    output_carry(6) <= carry;

    instiate_ir_decoder:ir_decoder
        port map(
                next_state <= next_state;
                current_state <= current_state;
                op_code <= current_ir(15 downto 12);
                cz <= current_ir(1 downto 0);
                imm <= current_ir(8 downto 0);
                op_out <= 
                carry <= carry;
                zero <= zero;
        );