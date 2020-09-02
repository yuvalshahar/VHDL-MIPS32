-- Fetch unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

entity fetch_tb is
end;

architecture bench of fetch_tb is

component fetch 
  port (	
			CLK   		: in  std_logic;					
  			Reset 		: in  std_logic;
  			PCWriteCond : in  std_logic;
			PCWrite 		: in  std_logic;
			Zero 			: in  std_logic;
			MemRead 		: in  std_logic;
			IRWrite 		: in  std_logic;
			MemWrite 	: in  std_logic;			
  			PC_in 		: in  std_logic_vector (31 downto 0);
			adress_in 	: in  std_logic_vector (31 downto 0);
			RegB 			: in  std_logic_vector (31 downto 0);
  			PC_out 		: out std_logic_vector (31 downto 0);
			MDR_out 		: out std_logic_vector (31 downto 0);
  			IR_out 		: out std_logic_vector (31 downto 0)
  			);
  end component;

  signal CLK			: std_logic;
  signal Reset			: std_logic;
  signal PCWriteCond : std_logic :='0';
  signal PCWrite		: std_logic :='0';
  signal Zero			: std_logic :='0';
  signal MemRead		: std_logic :='0';
  signal IRWrite		: std_logic :='0';
  signal MemWrite		: std_logic :='0';  
  signal PC_out		: std_logic_vector (31 downto 0);
  signal MDR_out		: std_logic_vector (31 downto 0);
  signal IR_out		: std_logic_vector (31 downto 0);
  signal PC_in			: std_logic_vector (31 downto 0) :=X"00000001";
  signal adress_in	: std_logic_vector (31 downto 0) :=X"00000000";
  signal RegB			: std_logic_vector (31 downto 0) :=X"00005555";
  
  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: fetch 
  port map ( 
				CLK         => CLK,
				Reset       => Reset,
				PC_in       => PC_in,
				adress_in   => adress_in,
				RegB        => RegB,
				PCWriteCond => PCWriteCond,
				PCWrite     => PCWrite,
				Zero        => Zero,
				MemRead     => MemRead,
				IRWrite     => IRWrite,
				MemWrite    => MemWrite,
				PC_out      => PC_out,
				MDR_out     => MDR_out,
				IR_out      => IR_out 
				);

stimulus: process
  begin
  
    -- Put initialisation code here

    Reset <= '1';
    wait for 5 ns;
    Reset <= '0';
    wait for 10 ns;
	 PCWrite <= '1' ; ---pc_out=pc_in
	 wait for 10 ns;
	 PCWrite <= '0';
	 MemRead <= '1';
    IRWrite <= '1'; ------LOAD of instruction from the memory IR_in=index[0]
	 wait for 10 ns;
	 IRWrite <= '0';
	 adress_in <= "00000000000000000000000000010100";--MDR_out =mem(5) =X"00000001"
	 wait for 10 ns;
	 MemRead <= '0';
	 MemWrite <='1';--store date mem(5) =regb =X"00005555"
	 wait for 10 ns;
	 MemRead <= '1';
	 MemWrite <='0'; --read from mem(5) =reg b
	 wait for 10 ns;
	 
	 
	 
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