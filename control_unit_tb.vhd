-- Control unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 


entity control_unit_tb is
end;

architecture bench of control_unit_tb is

component control_unit
      port ( 
				CLK 			: in  std_logic;
				reset 		: in  std_logic;
				OPcode 		: in  std_logic_vector (5 downto 0);
            RegDst 		: out std_logic;
            MemToReg 	: out std_logic;
            RegWrite 	: out std_logic;
            MemRead		: out std_logic;
            MemWrite 	: out std_logic;
  			   PCWriteCond	: out std_logic;
  			   PCWrite		: out std_logic;
  			   IorD			: out std_logic;
  			   IRWrite		: out std_logic;
  			   ALUSrcA 		: out std_logic;
  			   ALUOPcode   : out std_logic_vector (1 downto 0);
  			   PCSource		: out std_logic_vector (1 downto 0);
            ALUSrcB		: out std_logic_vector (1 downto 0);
  			   Flag_State  : out std_logic_vector (3 downto 0)
				);
  end component;

  signal CLK         : std_logic;
  signal reset       : std_logic; 
  signal OPcode      : std_logic_vector (5 downto 0):="000000";
  signal RegDst      : std_logic;
  signal MemToReg    : std_logic;
  signal RegWrite    : std_logic;
  signal MemRead     : std_logic;
  signal MemWrite    : std_logic;
  signal PCWriteCond : std_logic;
  signal PCWrite     : std_logic;
  signal IorD        : std_logic;
  signal IRWrite     : std_logic;
  signal ALUSrcA     : std_logic;  
  signal ALUOPcode   : std_logic_vector (1 downto 0);
  signal PCSource    : std_logic_vector (1 downto 0);
  signal ALUSrcB     : std_logic_vector (1 downto 0);
  signal Flag_State  : std_logic_vector (3 downto 0);


  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: control_unit 
  port map ( 
				OPcode      => OPcode,
				RegDst      => RegDst,
				MemToReg    => MemToReg,
				RegWrite    => RegWrite,
				MemRead     => MemRead,
				MemWrite    => MemWrite,
				PCWriteCond => PCWriteCond,
				PCWrite     => PCWrite,
				IorD        => IorD,
				IRWrite     => IRWrite,
				ALUOPcode   => ALUOPcode,
				PCSource    => PCSource,
				ALUSrcB     => ALUSrcB,
				ALUSrcA     => ALUSrcA,
				Flag_State  => Flag_State,
				CLK         => CLK,
				reset       => reset 
				);

stimulus: process
  begin
  
    -- Put initialisation code here

    Reset <= '1';
    wait for 5 ns;
    Reset <= '0';
    wait for 10 ns;
	 OPCode<="000100"; ---brunch instruction
	 wait for 30 ns;
	 OPCode<="000010"; ---jump instruction
	 wait for 30 ns;
	 OPCode<="000000"; ---r-type instruction
	 wait for 40 ns;
	 OPCode<="101011"; ---sw instruction
	 wait for 40 ns;
	 OPCode<="100011"; ---lw instruction
	 wait for 50 ns;

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
  end process;

end;