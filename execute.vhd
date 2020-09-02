-- Execute unit
-- Carries out the requested action, ALU performs arithmetic and logical operations

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity execute is 
	port (	
			CLK 			: in  std_logic;					
			Reset 		: in  std_logic;
			ALUsrcA 		: in  std_logic;								--control line
			ALUOp 		: in  std_logic_vector (1  downto 0);	--control line
			ALUsrcB		: in  std_logic_vector (1  downto 0);	--control line
			IR_in 		: in  std_logic_vector (31 downto 0);
			pc_out 		: in  std_logic_vector (31 downto 0);
			RegA 			: in  std_logic_vector (31 downto 0);
			RegB			: in  std_logic_vector (31 downto 0);
			imm  			: in  std_logic_vector (31 downto 0); 	--sign exstend
			imm_shift  	: in  std_logic_vector (31 downto 0); 	--sign extend with SL2
			zero			: out std_logic;
			ALUOut		: out std_logic_vector (31 downto 0);
			ALU_result 	: out std_logic_vector (31 downto 0)
			);
end  execute;

architecture behavioral of execute is 
signal ALU_control 	 : std_logic_vector (2  downto 0);
signal ALUin_1 		 : std_logic_vector (31 downto 0);
signal ALUin_2		    : std_logic_vector (31 downto 0);
signal ALU_result_sig : std_logic_vector (31 downto 0);
signal ALU_out_sig 	 : std_logic_vector (31 downto 0);
	
begin

ALUin_1 <= RegA when ALUSrcA = '1'  				--ALU MUX_A
		else PC_out ;
       
ALUin_2 <= RegB        when ALUSrcB = "00"		--ALU MUX_B
		else X"00000004" when ALUSrcB = "01"
		else imm         when ALUSrcB = "10"
		else imm_shift   when ALUSrcB = "11";	
			
ALU_control(0) <= (IR_in(0) OR IR_in(3)) AND ALUOp(1); 
ALU_control(1) <= (NOT IR_in(2)) OR (NOT ALUOp(1)); 
ALU_control(2) <= (IR_in(1) AND ALUOp(1)) OR ALUOp(0);

Zero <= '1' when ALU_result_sig = X"00000000" 	--in branch instruction when beq=1
   else '0';
				
			
process(ALU_control, ALUin_1, ALUin_2) 
begin
	case ALU_control is
          when "010" =>	ALU_result_sig <= ALUin_1+ALUin_2;				--add   
          when "110" => ALU_result_sig <= ALUin_1+(not(ALUin_2))+1;	--sub/subi  
          when "000" => ALU_result_sig <= ((ALUin_1)and(ALUin_2));		--and   
          when "001" => ALU_result_sig <= ((ALUin_1)or(ALUin_2));		--or
          when "111" =>	if (ALUin_1 < ALUin_2) then 							--slt
									ALU_result_sig	 <= X"00000001"; 
								else 
									ALU_result_sig <= X"00000000";
								end if;																 
          
			 when others => ALU_result_sig <= X"00000000";  
    end case;
end process;

process(CLK, Reset) is
begin
if Reset='1' then
	ALU_out_sig <= (others => '0');
	
elsif rising_edge(CLK) then 
   ALU_out_sig <= ALU_result_sig;
end if;
end process;

ALU_result <= ALU_result_sig;
ALUOut     <= ALU_out_sig;

end behavioral;