-- Write back unit test bench

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 
USE IEEE.NUMERIC_STD.ALL; 


entity  write_back_tb is
end write_back_tb;

architecture bench of write_back_tb is

component write_back 
  port (
  			MemtoReg   : in  std_logic;
			MDR_out    : in  std_logic_vector (31 downto 0);
			ALUOut_in  : in  std_logic_vector (31 downto 0);
  			Write_Data : out std_logic_vector (31 downto 0)
  			);
  end component;

  signal MemtoReg   : std_logic := '0';
  signal MDR_out    : std_logic_vector (31 downto 0) := X"00000000";
  signal ALUOut_in  : std_logic_vector (31 downto 0) := X"00000000";
  signal Write_Data : std_logic_vector (31 downto 0) ; 

begin

  uut: write_back 
  port map ( 
				MDR_out    => MDR_out,
            ALUOut_in  => ALUOut_in,
            MemtoReg   => MemtoReg,
            Write_Data => Write_Data 
				);
									  
									  
    stimulus: process
   begin
       wait for 10 ns;
       MDR_out <= X"00000001";
       wait for 10 ns;
       MemtoReg <= '1';
       wait for 10 ns;
       MemtoReg <= '0';     
       wait for 10 ns; 
       ALUOut_in <= X"00000011";
       wait for 10 ns; 
       wait;
   end process stimulus;
end architecture bench;
  
  

