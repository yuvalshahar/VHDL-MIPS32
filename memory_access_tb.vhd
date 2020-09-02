-- Memory access unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 

entity memory_access_tb is
end;

architecture bench of memory_access_tb is

component memory_access 
  port (
  			IorD      : in  std_logic;
			pc_out    : in  std_logic_vector (31 downto 0);
			ALUOut_in : in  std_logic_vector (31 downto 0);
  			adress_in : out std_logic_vector (31 downto 0)
  			);
  end component;

  signal IorD      : std_logic:= '0';
  signal pc_out    : std_logic_vector (31 downto 0):= X"00000000";
  signal ALUOut_in : std_logic_vector (31 downto 0):= X"00000000";
  signal adress_in : std_logic_vector (31 downto 0) ;

begin

  uut: memory_access 
  port map ( 
				pc_out    => pc_out,
            ALUOut_in => ALUOut_in,
            IorD      => IorD,
            adress_in => adress_in 
				);
				
stimulus: process
   begin
       wait for 10 ns;
       ALUOut_in <= X"00000001";
       wait for 10 ns;
       IorD <= '1';
       wait for 10 ns;
       IorD <= '0';     
       wait for 10 ns; 
       pc_out <= X"00000011";
       wait for 10 ns; 
		 IorD <= '1';     
       wait for 10 ns; 
       wait;
   end process stimulus;
end architecture bench;
  
  

