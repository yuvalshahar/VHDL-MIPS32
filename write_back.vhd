-- Write back

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity write_back is  --MemtoReg MUX
	port (
			MemtoReg   : in  std_logic;
			MDR_out    : in  std_logic_vector (31 downto 0);
			ALUOut_in  : in  std_logic_vector (31 downto 0);
			Write_Data : out std_logic_vector (31 downto 0)
			);
end write_back;

architecture behavioral of write_back is
begin
 
Write_Data <= ALUOut_in when	MemtoReg = '0'
			else MDR_out;

end behavioral;