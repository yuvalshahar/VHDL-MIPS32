-- Decode unit
-- Deciphers what the program is telling the computer to do

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity decode is 
	port (	
			CLK 			: in  std_logic;					
			Reset 		: in  std_logic;
			RegWrite 	: in  std_logic;							--control line
			RegDst		: in  std_logic;							--control line
			IR_in 		: in  std_logic_vector(31 downto 0);
			pc_out 		: in  std_logic_vector(31 downto 0);
			Write_Data 	: in  std_logic_vector(31 downto 0);
			RegA 			: out std_logic_vector(31 downto 0);
			RegB 			: out std_logic_vector(31 downto 0);
			jumpAddr    : out std_logic_vector(31 downto 0);
			Opcode 		: out std_logic_vector(5  downto 0);
			imm  			: out std_logic_vector(31 downto 0); --sign exstend
			imm_shift  	: out std_logic_vector(31 downto 0)  --sign extend with shift left 2
			);
end  decode;

architecture behavioral of decode is 
type Block_of_Registers is array (0 to 31) of std_logic_vector(31 downto 0);

signal BOR : Block_of_Registers:=( 		--block of registers for example
 X"00000000",
 X"11111111",
 X"22222222",
 X"33333333",
 X"44444444",
 X"55555555",
 X"66666666",
 X"77777777",
 X"0000000A",
 X"1111111A",
 X"2222222A",
 X"3333333A",
 X"4444444A",
 X"5555555A",
 X"6666666A",
 X"7777777A",
 X"0000000B",
 X"1111111B",
 X"2222222B",
 X"3333333B",
 X"4444444B",
 X"5555555B",
 X"6666666B",
 X"7777777B",
 X"000000BA",
 X"111111BA",
 X"222222BA",
 X"333333BA",
 X"444444BA",
 X"555555BA",
 X"666666BA",
 X"777777BA"
 );
 
signal RegRs		 	: std_logic_vector (4  downto 0);
signal RegRt 	 	 	: std_logic_vector (4  downto 0);
signal RegRd 		 	: std_logic_vector (4  downto 0);
signal imm_initial 	: std_logic_vector (31 downto 0);
signal Reg_A       	: std_logic_vector (31 downto 0);
signal Reg_B       	: std_logic_vector (31 downto 0);
signal MDR 			 	: std_logic_vector (31 downto 0);
signal write_register: std_logic_vector (4  downto 0);

begin
opcode <= IR_in (31 downto 26);
RegRs  <= IR_in (25 downto 21);
RegRt  <= IR_in (20 downto 16);
RegRd  <= IR_in (15 downto 11);


imm_initial <= X"0000" & IR_in(15 downto 0) when IR_in(15) = '0'  --sign extand
			 else X"FFFF" & IR_in(15 downto 0);
			 
imm <= imm_initial;
					
imm_shift <= imm_initial(29 downto 0) & "00";							--sign extand with SL2
				
write_register <= IR_in(15 downto 11) when RegDst = '1' 				--gets RegRd
				else  IR_in(20 downto 16) ; 									--gets RegRt
				  
jumpAddr <= pc_out(31 downto 28) & IR_in(25 downto 0) & "00";		--jump address line		  
				  
process(CLK) is
begin
if reset = '1' then
	Reg_A <= (others => '0');
	Reg_B <= (others => '0');
	
elsif  rising_edge(CLK) then
	Reg_A <= BOR(conv_integer(RegRs));										--regs init
	Reg_B <= BOR(conv_integer(RegRt));
	
	if RegWrite = '1' then 
        BOR(CONV_INTEGER(write_register)) <= Write_Data; 
	end if;
end if;
end process;

RegA <= Reg_A;
RegB <= Reg_B;

end behavioral;