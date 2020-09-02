-- Execute unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

entity execute_tb is
end;

architecture bench of execute_tb is

component execute 
  port (	
			CLK        : in  std_logic;					
  			Reset      : in  std_logic;
  			ALUsrcA    : in  std_logic;
  			ALUOp      : in  std_logic_vector (1  downto 0);
			ALUsrcB    : in  std_logic_vector (1  downto 0);
  			IR_in      : in  std_logic_vector (31 downto 0);
			pc_out     : in  std_logic_vector (31 downto 0);
  			RegA       : in  std_logic_vector (31 downto 0);
			RegB       : in  std_logic_vector (31 downto 0);
  			imm        : in  std_logic_vector (31 downto 0);
  			imm_shift  : in  std_logic_vector (31 downto 0);
  			zero       : out std_logic;
  			ALUOut     : out std_logic_vector (31 downto 0);
			ALU_result : out std_logic_vector (31 downto 0)
  			);
  end component;

  signal CLK        : std_logic;
  signal Reset      : std_logic;
  signal zero       : std_logic;  
  signal ALUsrcA    : std_logic:= '0';
  signal ALUOp      : std_logic_vector (1  downto 0):= "00";
  signal ALUsrcB    : std_logic_vector (1  downto 0):= "00";
  signal IR_in      : std_logic_vector (31 downto 0):= X"00000000";
  signal pc_out     : std_logic_vector (31 downto 0):= X"000000AA";
  signal RegA       : std_logic_vector (31 downto 0):= X"000000BB";
  signal RegB       : std_logic_vector (31 downto 0):= X"000000CC";
  signal imm        : std_logic_vector (31 downto 0):= X"000000DD";
  signal imm_shift  : std_logic_vector (31 downto 0):= X"000000EE";
  signal ALUOut     : std_logic_vector (31 downto 0);
  signal ALU_result : std_logic_vector (31 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: execute 
	port map ( 
				CLK        => CLK,
			   Reset      => Reset,
			   ALUsrcA    => ALUsrcA,
			   ALUOp      => ALUOp,
			   ALUsrcB    => ALUsrcB,
			   IR_in      => IR_in,
			   pc_out     => pc_out,
			   RegA       => RegA,
		 	   RegB       => RegB,
			   imm        => imm,
			   imm_shift  => imm_shift,
			   zero       => zero,
			   ALUOut     => ALUOut,
			   ALU_result => ALU_result );

stimulus: process
  begin
 Reset <= '1'; 
    wait for 5 ns;
    Reset <= '0'; --pcout+regb=X"176"
    wait for 10 ns;
	 ALUsrcB	<= "01";--pcout+4=X"AE"
	 wait for 10 ns;
	 ALUsrcB	<= "10";--pcout+SE=X"187"
	 wait for 10 ns;
	 ALUsrcB	<= "11";--pcout+SESL=X"198"
	 wait for 10 ns;
	 ALUsrcA	<= '1';--regA+SESL=X"1A9"
	 wait for 10 ns;
	 ALUsrcB	<= "10";--regA+SEL=X"198"
	 wait for 10 ns;
	 ALUsrcB	<= "01";--regA+4=X"BF"
	 wait for 10 ns;
	 ALUsrcB	<= "00";--regA+regB=X"187"
	 --------------------------------------ALU Computation---------------------------------
	 wait for 10 ns;
	 ALUOp<= "10";
	 IR_in<= X"00000002";
	 wait for 10 ns;--regA-regB=X"FFFFFFEF"
	 IR_in<= X"00000004";
	 wait for 10 ns;--regA and regB=X"00000088"
	 IR_in<= X"0000000C";
	 wait for 10 ns;--regA or regB=X"000000FF"
	 IR_in<= X"0000000B";
	 wait for 10 ns;--regA SLT regB=X"00000001"
	 RegB<= X"000000BB";
	 wait for 10 ns;--regA SLT regB=X"00000000" , ZERO should be turn on
	
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