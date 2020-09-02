-- Control unit
-- State machine 

LIBRARY IEEE; 
USE IEEE.std_logic_1164.ALL; 
USE IEEE.std_logic_ARITH.ALL; 
USE IEEE.std_logic_UNSIGNED.ALL; 

entity control_unit is
	port ( 
		  CLK   			: in  std_logic;
		  reset 			: in  std_logic;
		  OPcode 		: in  std_logic_vector (5 downto 0);
		  RegDst 		: out std_logic;
		  MemToReg 		: out std_logic;
		  RegWrite 		: out std_logic;
		  MemRead		: out std_logic;
		  MemWrite 		: out std_logic;
		  PCWriteCond	: out std_logic;
		  PCWrite		: out std_logic;
		  IorD			: out std_logic;
		  IRWrite		: out std_logic;
		  ALUSrcA 		: out std_logic;
		  ALUOPcode    : out std_logic_vector (1 downto 0);
		  PCSource		: out std_logic_vector (1 downto 0);
		  ALUSrcB		: out std_logic_vector (1 downto 0);
		  Flag_State   : out std_logic_vector (3 downto 0)
		  );

end control_unit;

architecture Behavioral of control_unit is

type state is (instruction_fetch, instruction_decode, memory_adress_comp, execution, branch_complete, jump_complete, memory_ac_lw, memory_ac_sw, r_type_complete, write_back_step);
signal PS, NS : state;

begin
 
process(CLK,reset) 
begin
if reset = '1' then PS <= instruction_fetch; 
elsif rising_edge(CLK) then PS <= NS;
end if;
end process;

process (OPcode,PS) is
	begin
	case PS is
	when instruction_fetch => 	--State 0 
		  PCWrite 	  <= '1';
        PCWriteCond <= '0';
        IorD 		  <= '0';
        MemRead     <= '1';
        MemWrite    <= '0';
        IRWrite     <= '1';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="00";
        ALUSrcB     <="01";
        ALUSrcA     <= '0';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"0"; 
		  
		  NS <= instruction_decode;
		
	
	when instruction_decode =>  --State 1
		  PCWrite     <= '0';
        PCWriteCond <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="00";
        ALUSrcB     <="11";
        ALUSrcA     <= '0';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"1";  
		  
		  case OPCode is

				when "100011" => NS <= memory_adress_comp;  -- lw
				when "101011" => NS <= memory_adress_comp;  -- sw
				when "000000" => NS <= execution;			  -- R-type
				when "000100" => NS <= branch_complete;     -- beq
				when "000010" => NS <= jump_complete;		  -- j
				when OTHERS   => NS <= instruction_fetch;
			END CASE;
		  
		
	when memory_adress_comp =>  --State 2
		  PCWrite     <= '0';
        PCWriteCond <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="00";
        ALUSrcB     <="10";
        ALUSrcA     <= '1';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"2";
		  
		  case OPCode is

				when "100011" => NS <= memory_ac_lw; -- lw
				when "101011" => NS <= memory_ac_sw; -- sw
			   when OTHERS   => NS <= instruction_fetch;		
			END CASE;
		
		
	when jump_complete =>   --State 9
	     PCWrite     <= '1';
        PCWriteCond <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="10";
        ALUOPcode   <="00";
        ALUSrcB     <="00";
        ALUSrcA     <= '0';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"9";
		  
		  NS <= instruction_fetch;
	     
		
	when branch_complete =>  --State 8
	     PCWrite     <= '0';
        PCWriteCond <= '1';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="01";
        ALUOPcode   <="01";
        ALUSrcB     <="00";
        ALUSrcA     <= '1';
        RegWrite    <= '0';
        RegDst      <= '0';
	     Flag_State  <=X"8";
		  
		  NS <= instruction_fetch;
				
				
	when execution =>       --State 6 
	     PCWrite     <= '0';
        PCWriteCond <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="10";
        ALUSrcB     <="00";
        ALUSrcA     <= '1';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"6";
		  
		  NS <= r_type_complete;

		
	when r_type_complete => --State 7 
		  PCWrite     <= '0';
        PCWriteCond <= '0';
        IorD        <= '0';
        MemRead     <= '0';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="00";
        ALUSrcB     <="00";
        ALUSrcA     <= '0';
        RegWrite    <= '1';
        RegDst      <= '1';
		  Flag_State  <=X"7";
		  
		  NS <= instruction_fetch;
		   
		 
	when memory_ac_lw =>    --State 3
	     PCWrite     <= '0';
        PCWriteCond <= '0';
        IorD        <= '1';
        MemRead     <= '1';
        MemWrite    <= '0';
        IRWrite     <= '0';
        MemtoReg    <= '0';
        PCSource    <="00";
        ALUOPcode   <="00";
        ALUSrcB     <="00";
        ALUSrcA     <= '0';
        RegWrite    <= '0';
        RegDst      <= '0';
		  Flag_State  <=X"3"; 
		  
		  NS <= write_back_step;
		  
		  
	 when write_back_step => --State 4 
	      PCWrite     <= '0';
			PCWriteCond <= '0';
			IorD        <= '0';
			MemRead     <= '0';
			MemWrite    <= '0';
			IRWrite     <= '0';
			MemtoReg    <= '1';
			PCSource    <="00";
			ALUOPcode   <="00";
			ALUSrcB     <="00";
			ALUSrcA     <= '0';
			RegWrite    <= '1';
			RegDst      <= '0';
		   Flag_State  <=X"4";
			
			NS <= instruction_fetch;
	    
		
	 when memory_ac_sw =>    --State 5
			PCWrite     <= '0';
			PCWriteCond <= '0';
			IorD        <= '1';
			MemRead     <= '0';
			MemWrite    <= '1';
			IRWrite     <= '0';
			MemtoReg    <= '0';
			PCSource    <="00";
			ALUOPcode   <="00";
			ALUSrcB     <="00";
			ALUSrcA     <= '0';
			RegWrite    <= '0';
			RegDst      <= '0';
			Flag_State  <=X"5";
			
			NS <=instruction_fetch;
		
	   
	when others=> NS <=instruction_fetch;
   	
	end case;

end process;
 
end Behavioral;