-- Decode unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

entity decode_tb is
end;

architecture bench of decode_tb is

component decode 
  port (	
			CLK        : in  std_logic;					
  			Reset      : in  std_logic;
  			RegWrite   : in  std_logic;
			RegDst     : in  std_logic;
  			IR_in      : in  std_logic_vector (31 downto 0);
			pc_out 	  : in  std_logic_vector (31 downto 0);
  			Write_Data : in  std_logic_vector (31 downto 0);
  			RegA       : out std_logic_vector (31 downto 0); 
			RegB       : out std_logic_vector (31 downto 0);
  			jumpAddr   : out std_logic_vector (31 downto 0);
  			Opcode     : out std_logic_vector (5  downto 0);
  			imm        : out std_logic_vector (31 downto 0);
  			imm_shift  : out std_logic_vector (31 downto 0)
  			);
  end component;

  signal CLK        : std_logic;
  signal Reset      : std_logic;
  signal RegWrite   : std_logic:='0';
  signal RegDst     : std_logic:='0';
  signal IR_in      : std_logic_vector (31 downto 0):= "00000000011001010001100000100000";
  signal pc_out     : std_logic_vector (31 downto 0):= X"30000000";
  signal Write_Data : std_logic_vector (31 downto 0):= X"00000000";
  signal RegA, RegB : std_logic_vector (31 downto 0);
  signal jumpAddr   : std_logic_vector (31 downto 0);
  signal Opcode     : std_logic_vector (5  downto 0);
  signal imm        : std_logic_vector (31 downto 0);
  signal imm_shift  : std_logic_vector (31 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: decode 
  port map ( 
				CLK        => CLK,
				Reset      => Reset,
				RegWrite   => RegWrite,
				RegDst     => RegDst,
				IR_in      => IR_in,
				pc_out     => pc_out,
				Write_Data => Write_Data,
				RegA       => RegA,
				RegB       => RegB,
				jumpAddr   => jumpAddr,
				Opcode     => Opcode,
				imm        => imm,
				imm_shift  => imm_shift 
				);

  stimulus: process
  begin
  
    -- Put initialisation code here

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 10 ns;
----regA = 33333333
---- regB =55555555
----opcode = 000000
----imm =X"00001820
----imm_shift =X"00006080
----jumpAddr= X"31946080
---- Put test bench stimulus code here
    Write_Data <= X"00008888";
	 RegWrite <= '1';   ---store in reg rt 8888
	  wait for 10 ns;
	  RegWrite <='0';  --read the data frome regb
    wait for 10 ns;
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
  end process;

end;