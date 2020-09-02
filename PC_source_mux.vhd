-- PC source MUX

LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_ARITH.ALL; 
USE IEEE.std_logic_UNSIGNED.ALL; 

entity PC_source_mux is 
  port  (
			ALU_result : in  std_logic_vector (31 downto 0);
			ALUOut 	  : in  std_logic_vector (31 downto 0);
			jumpAddr	  : in  std_logic_vector (31 downto 0);
         PCSource	  : in  std_logic_vector (1  downto 0);
         pc_in	     : out std_logic_vector (31 downto 0)
			);
end PC_source_mux;

architecture behavioral of PC_source_mux is 
  begin 
    with (PCSource) select
       pc_in <=  ALU_result  when "00",
					  ALUOut      when "01",
					  jumpAddr    when "10",
                 X"00000000" when others;
            
end behavioral;