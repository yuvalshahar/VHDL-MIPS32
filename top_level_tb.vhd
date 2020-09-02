-- Top level test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 


entity top_level_tb is
end;

architecture bench of top_level_tb is

component top_level 
  port (	
  			CLK             : in  std_logic;					
    		Reset           : in  std_logic;
  			Zero_flag       : out std_logic;
			PC_in_flag      : out std_logic_vector (31 downto 0);
  			adress_in_flag  : out std_logic_vector (31 downto 0);
  			RegB_flag       : out std_logic_vector (31 downto 0);
  			PC_out_flag     : out std_logic_vector (31 downto 0);
  			MDR_out_flag    : out std_logic_vector (31 downto 0);
  			IR_flag         : out std_logic_vector (31 downto 0);
  			Write_Data_flag : out std_logic_vector (31 downto 0);
  			RegA_flag       : out std_logic_vector (31 downto 0);
  			jumpAddr_flag   : out std_logic_vector (31 downto 0);
  			Opcode_flag     : out std_logic_vector (5  downto 0);
  			imm_flag        : out std_logic_vector (31 downto 0);
  			imm_shift_flag  : out std_logic_vector (31 downto 0);
  			ALUOut_flag     : out std_logic_vector (31 downto 0);
  			ALU_result_flag : out std_logic_vector (31 downto 0);
  			Flag_State_flag : out std_logic_vector (3  downto 0)
  			);
  end component;

  signal CLK             : std_logic;
  signal Reset           : std_logic;
  signal Zero_flag       : std_logic;  
  signal PC_in_flag      : std_logic_vector (31 downto 0);
  signal adress_in_flag  : std_logic_vector (31 downto 0);
  signal RegB_flag       : std_logic_vector (31 downto 0);
  signal PC_out_flag     : std_logic_vector (31 downto 0);
  signal MDR_out_flag    : std_logic_vector (31 downto 0);
  signal IR_flag         : std_logic_vector (31 downto 0);
  signal Write_Data_flag : std_logic_vector (31 downto 0);
  signal RegA_flag       : std_logic_vector (31 downto 0);
  signal jumpAddr_flag   : std_logic_vector (31 downto 0);
  signal Opcode_flag     : std_logic_vector (5  downto 0);
  signal imm_flag        : std_logic_vector (31 downto 0);
  signal imm_shift_flag  : std_logic_vector (31 downto 0);
  signal ALUOut_flag     : std_logic_vector (31 downto 0);
  signal ALU_result_flag : std_logic_vector (31 downto 0);
  signal Flag_State_flag : std_logic_vector (3  downto 0);
  
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;


begin

  uut: top_level 
  port map ( 
			   CLK             => CLK,
			   Reset           => Reset,
			   PC_in_flag      => PC_in_flag,
			   adress_in_flag  => adress_in_flag,
			   RegB_flag       => RegB_flag,
			   Zero_flag       => Zero_flag,
	  		   PC_out_flag     => PC_out_flag,
			   MDR_out_flag    => MDR_out_flag,
			   IR_flag         => IR_flag,
			   Write_Data_flag => Write_Data_flag,
			   RegA_flag       => RegA_flag,
			   jumpAddr_flag   => jumpAddr_flag,
			   Opcode_flag     => Opcode_flag,
			   imm_flag        => imm_flag,
			   imm_shift_flag  => imm_shift_flag,
			   ALUOut_flag     => ALUOut_flag,
			   ALU_result_flag => ALU_result_flag,
			   Flag_State_flag => Flag_State_flag );

stimulus: process
  begin
  
    -- Put initialisation code here

    Reset <= '1';
    wait for 5 ns;
    Reset <= '0';
    wait for 600 ns;

    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      CLK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process clocking;
END architecture bench;	