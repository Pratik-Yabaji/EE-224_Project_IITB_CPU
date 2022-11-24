library ieee;
use ieee.std_logic_1164.all;

entity DUT is
    port (input_vector : in std_logic_vector(0 downto 0);
          output_vector: out std_logic_vector(7 downto 0)
        );
end entity;

architecture DutWrap of DUT is
    signal current_state: std_logic_vector(5 downto 0 ):="000001";
	signal next_state: std_logic_vector(5 downto 0 ):="000001";
    signal se_10_op, t1_op,ir_mem_data, t2_op, t3_op, pc_mem,s_op_7, reg_d3_s, alu_a_ip,alu_b_ip,reg_d1,reg_d2,data_out,t3_ip,ir_data, alu_pc, reg_out_d1:std_logic_vector(15 downto 0 );
--    signal current_ir:std_logic_vector(15 downto 0 );
    signal alu_ir: std_logic_vector(1 downto 0);
    signal clock: std_logic;
	signal reset: std_logic:='0';
    signal carry, zero: std_logic:='0';
    signal se_10: std_logic_vector(5 downto 0); 
	signal s_ip_7: std_logic_vector(8 downto 0);
    signal reg_a1,reg_a2,reg_a3 :std_logic_vector(2 downto 0);

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
                carry: in std_logic;
                zero: in std_logic
                );
        end component;

    component ir is
            port(
                current_state : in std_logic_vector(5 downto 0);
                ir_mem_data : in std_logic_vector(15 downto 0);
                clock    : in std_logic;
        
                ir_out : out std_logic_vector(15 downto 0);
                shift_ip_7 : out std_logic_vector(8 downto 0);
                se_ip_10 : out std_logic_vector(5 downto 0)
                );
        end component;
    
    component memory is
            port(
                t3_addr : in std_logic_vector(15 downto 0);
                t2_data : in std_logic_vector(15 downto 0);
                t1_addr : in std_logic_vector(15 downto 0);
                -- t1_data : out std_logic_vector(15 downto 0);
                ir_addr: in std_logic_vector(15 downto 0);        
                ir_data: out std_logic_vector(15 downto 0);
                data_out: out std_logic_vector(15 downto 0);
        
                clock : in std_logic;
                current_state : in std_logic_vector(5 downto 0)
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
                reg_d2 : out std_logic_vector(15 downto 0)
                
            );
        end component;

    component pc is
            port(
                alu_in : in std_logic_vector(15 downto 0); -- from alu
                alu_out : out std_logic_vector(15 downto 0); -- to alu
                reg_in_d2 : in std_logic_vector(15 downto 0);
                reg_out_d1 : out std_logic_vector(15 downto 0);
                pc_mem : out std_logic_vector(15 downto 0);
                current_state : in std_logic_vector(5 downto 0);
                clock : in std_logic
            );
        end component;
    
    component register_control_file is
            port(
                ir     : in  std_logic_vector(15 downto 0);
                reg_a1 : out std_logic_vector(2 downto 0);
                reg_a2 : out std_logic_vector(2 downto 0);
                reg_a3 : out std_logic_vector(2 downto 0);
        
                clock  : in  std_logic;
                current_state  : in std_logic_vector(5 downto 0)
            );
        end component;
    
    component sign_10_extender is 
        port(se_ip_10 : in std_logic_vector(5 downto 0);
             current_state : in std_logic_vector(5 downto 0);
             se_op_10 : out std_logic_vector(15 downto 0)
             );
        end component;

    component t1 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                reg_d1_ip : in std_logic_vector(15 downto 0);
        
                t1_op : out std_logic_vector(15 downto 0)
            );
        end component;

    component t2 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                reg_d2_ip : in std_logic_vector(15 downto 0);
                memory_data : in std_logic_vector(15 downto 0);

                t2_op : out std_logic_vector(15 downto 0)
            );
        end component;
    
    component t3 is
            port(
                current_state : in std_logic_vector(5 downto 0);
                alu_out : in std_logic_vector(15 downto 0);
        
                t3_op : out std_logic_vector(15 downto 0)
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
        
                reg_d3 : out std_logic_vector(15 downto 0)
            );
        end component;

    component bit_7_shifter is
            port (shift_ip_7 : in std_logic_vector(8 downto 0);
                  current_state : in std_logic_vector(5 downto 0);
                  shift_op_7 : out std_logic_vector(15 downto 0)
                  );
        end component;

    component alu is
            port (
                alu_a : in std_logic_vector(15 downto 0);
                alu_b : in std_logic_vector(15 downto 0);
                alu_ir : in std_logic_vector(1 downto 0);
                alu_out : out std_logic_vector(15 downto 0);
        
                alu_carry : out std_logic;
                alu_zero : out std_logic
            );
        end component;

component alu_ip_mux is
            port(
                current_state : in std_logic_vector(5 downto 0); -- Selector
        
                t1 : in std_logic_vector(15 downto 0); 
                t2 : in std_logic_vector(15 downto 0);
                pc : in std_logic_vector(15 downto 0);
                se_op_10 : in std_logic_vector(15 downto 0);
        
                alu_a_ip : out std_logic_vector(15 downto 0);
                alu_b_ip : out std_logic_vector(15 downto 0);
                alu_ir_ip : out std_logic_vector(1 downto 0)
            );
end component;

begin
    output_vector(5 downto 0) <= current_state;
    -- output_vector(5 downto 0) <= "000001";
    output_vector(6) <= carry;
    output_vector(7) <= zero;

    ins_ir_setter:ir_setter
        port map(
            reset => reset,
            clock => input_vector(0),
            next_state => next_state,
            current_state => current_state  
        );
    
    ins_ir_decoder:ir_decoder
        port map(
			next_state => next_state,
            current_state => current_state,
            op_code => ir_mem_data(15 downto 12),
            cz => ir_mem_data(1 downto 0),
            imm => ir_mem_data(8 downto 0),
            carry => carry,
            zero => zero
        );

    ins_memory:memory
        port map(
            t3_addr => t3_op,
            t2_data => t2_op,
            t1_addr => t1_op,
            ir_addr => pc_mem,
            ir_data => ir_mem_data,
            data_out => data_out,

            clock => input_vector(0),
            current_state => current_state
        );

    ins_register_file:register_file
        port map(
            reg_a1 => reg_a1,
            reg_a2 => reg_a2,
            reg_a3 => reg_a3,
            reg_d3 => reg_d3_s,
            clock  => input_vector(0),

            reg_d1 => reg_d1,
            reg_d2 => reg_d2
        );
    
    ins_register_control:register_control_file
        port map(
            ir     => ir_data,
            reg_a1 => reg_a1,
            reg_a2 => reg_a2,
            reg_a3 => reg_a3,
    
            clock  => input_vector(0),
            current_state  =>  current_state
        );

    ins_t1:t1
        port map(
            current_state => current_state ,
            reg_d1_ip => reg_d1,

            t1_op => t1_op
        );

    ins_t2:t2
        port map(
            current_state => current_state ,
            reg_d2_ip => reg_d2,
            memory_data => data_out,

            t2_op => t2_op
        );

    ins_t3:t3
        port map(
            current_state => current_state ,
            alu_out => t3_ip,

            t3_op => t3_op
        );
        
    ins_pc :pc
        port map(
            alu_in => t3_ip,
            alu_out => alu_pc,
            reg_in_d2 => reg_d2,
            reg_out_d1 => reg_out_d1,
            pc_mem => pc_mem,
            current_state => current_state ,
            clock => clock
        );

    ins_ir:ir
        port map(
            current_state => current_state ,
            ir_mem_data => ir_mem_data,
            clock  => input_vector(0),

            ir_out => ir_data,
            shift_ip_7 => s_ip_7,
            se_ip_10 => se_10
        );
        
    ins_alu_ip_mux: alu_ip_mux
        port map(        
            current_state => current_state ,
            t1 => t1_op,
            t2 => t2_op,
            pc => alu_pc,
            se_op_10 => se_10_op,
            alu_a_ip => alu_a_ip,
            alu_b_ip => alu_b_ip,
            alu_ir_ip => alu_ir
        );
        
    ins_alu: alu
        port map(        
            alu_a => alu_a_ip,
            alu_b => alu_b_ip,
            alu_ir => alu_ir,
            alu_out => t3_ip,
            alu_carry => carry,
            alu_zero => zero
        );

    ins_bit_7_shifter: bit_7_shifter
        port map(
            shift_ip_7 => s_ip_7,
            current_state => current_state ,
            shift_op_7 => s_op_7
        );
    
    ins_d3_mux: d3_mux
        port map(
            current_state => current_state,
            t1 => t1_op,
            t2 => t2_op,
            t3 => t3_op,
            pc => reg_out_d1,
            shift_op_7 => s_op_7,
            reg_d3 => reg_d3_s
        );

    ins_sign_10_extender: sign_10_extender
        port map(
            se_ip_10 => se_10,
            current_state => current_state ,
            se_op_10 => se_10_op
        );
end DutWrap;