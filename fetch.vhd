-- Fetch unit 
-- Gets the next program command from the computer’s memory

LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity fetch is 
	port (	
			CLK 			:in  std_logic;					
			Reset 		:in  std_logic;
			PCWriteCond :in  std_logic;								--control line
			PCWrite 		:in  std_logic;								--control line
			Zero			:in  std_logic;								--ALU Zero
			MemRead 		:in  std_logic;								--control line
			IRWrite 		:in  std_logic;								--control line
			MemWrite 	:in  std_logic;								--control line
			PC_in 		:in  std_logic_vector(31 downto 0);
			adress_in 	:in  std_logic_vector(31 downto 0);
			RegB			:in  std_logic_vector(31 downto 0);			
			PC_out 		:out std_logic_vector(31 downto 0);
			MDR_out 		:out std_logic_vector(31 downto 0);
			IR_out 		:out std_logic_vector(31 downto 0)
			);
end fetch;

architecture behavioral of fetch is
type Memory is array (0 to 15) of std_logic_vector(31 downto 0);  --block of memory

signal IMEM : Memory:=(															--examples for instructions
X"8c070014", -- lw $7, 20($0)                          /0
X"AC0A0020", -- sw r10 0x20 r0                         /1
X"01074820", -- add $9, $7, $8                         /2
X"10000002", -- beq $0, $0, 2 (branch back 2 words)    /3 
X"08000013", --j 19					/jump to 19           /4
X"00000001", ------------Data---------------           /5
X"08000009", --j 10					/jump to 10           /6
X"00000003",                                   --      /7  
X"00000004",                                   --      /8    
X"00822022", --sub $4, $4, $2		/$4 = 0x22222222      /9
X"00632024", --and $4, $3, $3		/$4 = 0x33333333      /10
X"020F8825", --or  $17,$16,$15   /$17 =0x7777777B      /11
X"03BEF82A", --slt $31,$29,$30   /$31 =0X00000001      /12
X"00000000",                                 --        /13
X"00000000",                                 --        /14
X"00000000"                                  --        /15
);


signal PC_EN 		: std_logic; 
signal PC_out_sig : std_logic_vector (31 downto 0);
signal IR_out_sig : std_logic_vector (31 downto 0);
signal MDRout_sig : std_logic_vector (31 downto 0);

begin
PC_EN <= (PCWrite or (PCWriteCond and Zero ));  

process (CLK, Reset) is 
begin
if Reset = '1' then
	PC_out_sig <= (others => '0');
	IR_out_sig <= (others => '0');
	MDRout_sig <= (others => '0');
	
elsif rising_edge(CLK) then 
	if PC_EN = '1' then
		PC_out_sig <= PC_in;
	end if;
	
if (MemRead = '1' and IRWrite = '1') then 							--load instruction
		IR_out_sig <= IMEM(conv_integer(adress_in(5 downto 2)));
end if;

if (MemRead = '1') then 													--load word
    MDRout_sig <= IMEM(conv_integer(adress_in(5 downto 2)));
end if;
	 
if(MemWrite = '1') then 													--store word
   IMEM(conv_integer(adress_in(5 downto 2))) <= RegB;
end if;
end if;
end process;

PC_out  <= PC_out_sig;
IR_out  <= IR_out_sig;
MDR_out <= MDRout_sig;
end behavioral;