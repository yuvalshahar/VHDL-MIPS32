-- Memory access unit

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity memory_access is --IorD MUX
	port (
			IorD 		 : in  std_logic;
			pc_out 	 : in  std_logic_vector (31 downto 0);
			ALUOut_in : in  std_logic_vector (31 downto 0);
			adress_in : out std_logic_vector (31 downto 0)
			);
end memory_access;

architecture behavioral of memory_access is
begin
 
adress_in <= pc_out when IorD ='0'
		  else ALUOut_in;

end behavioral;