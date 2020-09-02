-- Top level
-- combine all units of the proccesor
LIBRARY IEEE; 
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_ARITH.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity top_level is 
	port (	
			CLK 				 : in  std_logic;					
  			Reset 			 : in  std_logic;
			Zero_flag		 : out std_logic;
			PC_in_flag      : out std_logic_vector (31 downto 0);
			adress_in_flag  : out std_logic_vector (31 downto 0);
			RegB_flag 	    : out std_logic_vector (31 downto 0);
			PC_out_flag		 : out std_logic_vector (31 downto 0);
			MDR_out_flag	 : out std_logic_vector (31 downto 0);
			IR_flag			 : out std_logic_vector (31 downto 0);
			Write_Data_flag : out std_logic_vector (31 downto 0);
			RegA_flag 		 : out std_logic_vector (31 downto 0);
			jumpAddr_flag	 : out std_logic_vector (31 downto 0);
			Opcode_flag		 : out std_logic_vector (5  downto 0);
			imm_flag  		 : out std_logic_vector (31 downto 0);
			imm_shift_flag  : out std_logic_vector (31 downto 0);
			ALUOut_flag 	 : out std_logic_vector (31 downto 0);
			ALU_result_flag : out std_logic_vector (31 downto 0);
			Flag_State_flag : out std_logic_vector (3  downto 0)
			);
end top_level;

architecture behavioral of top_level is

component fetch 
   PORT (	
			CLK			: in  std_logic;					
  			Reset			: in  std_logic;
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

component decode 
   PORT (	
			CLK 		  : in  std_logic;					
  			Reset		  : in  std_logic;
  			RegWrite   : in  std_logic;
			RegDst 	  : in  std_logic;
  			IR_in 	  : in  std_logic_vector (31 downto 0);
			pc_out 	  : in  std_logic_vector (31 downto 0);
  			Write_Data : in  std_logic_vector (31 downto 0);
  			Opcode	  : out std_logic_vector (5  downto 0);
			RegA 	 	  : out std_logic_vector (31 downto 0);
			RegB 		  : out std_logic_vector (31 downto 0);
  			jumpAddr   : out std_logic_vector (31 downto 0);
  			imm  		  : out std_logic_vector (31 downto 0);
  			imm_shift  : out std_logic_vector (31 downto 0)
  			);
end component;

component execute 
   PORT (	
			CLK        : in  std_logic;					
  			Reset      : in  std_logic;
  			ALUsrcA    : in  std_logic;
  			ALUOp      : in  std_logic_vector (1  downto 0);
			ALUsrcB    : in  std_logic_vector (1  downto 0);
  			IR_in      : in  std_logic_vector (31 downto 0);
			pc_out 	  : in  std_logic_vector (31 downto 0);
  			RegA       : in  std_logic_vector (31 downto 0);
			RegB       : in  std_logic_vector (31 downto 0);
  			imm        : in  std_logic_vector (31 downto 0);
  			imm_shift  : in  std_logic_vector (31 downto 0);
  			zero		  : out std_logic;
  			ALUOut	  : out std_logic_vector (31 downto 0);
			ALU_result : out std_logic_vector (31 downto 0)
  			);
end component;

component memory_access 
	PORT (
  			IorD      : in  std_logic;
			pc_out    : in  std_logic_vector (31 downto 0);
			ALUOut_in : in  std_logic_vector (31 downto 0);
  			adress_in : out std_logic_vector (31 downto 0)
  			);
end component;

component write_back 
  PORT 	(
  			MemtoReg   : in  std_logic;
			MDR_out    : in  std_logic_vector (31 downto 0);
			ALUOut_in  : in  std_logic_vector (31 downto 0);
  			Write_Data : out std_logic_vector (31 downto 0)
  			);
end component;

component control_unit
	PORT ( 
			CLK			: in  std_logic;
			reset 		: in  std_logic;
			OPcode 		: in  std_logic_vector (5 downto 0);
			RegDst 		: out std_logic;
			MemToReg 	: out std_logic;
			RegWrite 	: out std_logic;
			MemRead		: out std_logic;
			MemWrite 	: out std_logic;
			PCWriteCond	: out std_logic;
			PCWrite		: out std_logic;
			IorD			: out std_logic;
			IRWrite		: out std_logic;
			ALUSrcA 		: out std_logic;
			ALUOPcode   : out std_logic_vector (1 downto 0);
			PCSource		: out std_logic_vector (1 downto 0);
			ALUSrcB		: out std_logic_vector (1 downto 0);
			Flag_State  : out std_logic_vector (3 downto 0)
			);
end component;

component PC_source_mux 
	PORT  (
			PCSource   : in  std_logic_vector (1  downto 0);
			ALU_result : in  std_logic_vector (31 downto 0);
			ALUOut     : in  std_logic_vector (31 downto 0); 
			jumpAddr   : in  std_logic_vector (31 downto 0);
			pc_in      : out std_logic_vector (31 downto 0)
			);
end component;

 
--signals that are necessary:

------------- Fetch -----------------

signal PCWriteCond : std_logic;
signal PCWrite		 : std_logic;
signal Zero			 : std_logic;
signal MemRead 	 : std_logic;
signal IRWrite     : std_logic;
signal MemWrite    : std_logic;
signal PC_in		 : std_logic_vector (31 downto 0);
signal adress_in	 : std_logic_vector (31 downto 0);
signal RegB			 : std_logic_vector (31 downto 0);
signal PC_out      : std_logic_vector (31 downto 0);
signal MDR_out     : std_logic_vector (31 downto 0);
signal IR			 : std_logic_vector (31 downto 0);

------------- Decode -----------------

signal RegWrite   : std_logic;
signal RegDst     : std_logic;
signal Opcode     : std_logic_vector (5  downto 0);
signal Write_Data : std_logic_vector (31 downto 0);
signal RegA       : std_logic_vector (31 downto 0);
signal jumpAddr   : std_logic_vector (31 downto 0);
signal imm        : std_logic_vector (31 downto 0);
signal imm_shift  : std_logic_vector (31 downto 0);
--signal IR_in    : std_logic_vector (31 downto 0);

------------- Excecute -----------------
 
signal ALUsrcA 	: std_logic;
signal ALUOp   	: std_logic_vector (1  downto 0);
signal ALUsrcB 	: std_logic_vector (1  downto 0);
signal ALUOut  	: std_logic_vector (31 downto 0);
signal ALU_result : std_logic_vector (31 downto 0);

-------------- Memory Access -----------------

signal IorD :std_logic;

-------------- Write Back -----------------

signal MemtoReg :std_logic;

-------------- Control Unit -----------------

signal  PCSource   : std_logic_vector (1 downto 0);
signal  Flag_State : std_logic_vector (3 downto 0);


begin
 
--connections between units:

fetch_unit : fetch 
	port map (
				CLK 		   => CLK,
				Reset 	   => Reset, 
				PC_in 	   => PC_in, 
				adress_in   => adress_in, 
				RegB		   => RegB, 
				PCWriteCond => PCWriteCond,
				PCWrite 		=> PCWrite,
				Zero			=> Zero, 
				MemRead	   => MemRead, 
				MemWrite 	=> MemWrite, 
				IRWrite     => IRWrite,
				PC_out      => PC_out, 
				MDR_out     => MDR_out,
				IR_out      => IR
				);

decode_unit : decode 
	port map (
				CLK 	     => CLK,
				Reset 	  => Reset, 
				RegWrite   => RegWrite,
				RegDst 	  => RegDst,
				IR_in		  => IR,
				Write_Data => Write_Data,
				RegA		  => RegA, 
				RegB 		  => RegB, 
				jumpAddr	  => jumpAddr, 
				Opcode 	  => Opcode,
				PC_out     => PC_out, 
				imm 		  => imm,
				imm_shift  => imm_shift
				);

execute_unit : execute 
	port map (
				CLK        => CLK,
				Reset      => Reset, 
				ALUOp      => ALUOp,
				ALUsrcA    => ALUsrcA,
				IR_in      => IR,
				ALUsrcB    => ALUsrcB,
				RegA       => RegA, 
				RegB       => RegB, 
				zero       => zero,
				PC_out     => PC_out, 
				imm        => imm,
				imm_shift  => imm_shift, 
				ALUOut     => ALUOut ,
				ALU_result => ALU_result
				);

memory_access_unit : memory_access 
	port map (
				pc_out    => pc_out, 
				ALUOut_in => ALUOut, 
				IorD      => IorD,
				adress_in => adress_in
				);

write_back_unit : write_back 
	port map (
				MDR_out    => MDR_out, 
				ALUOut_in  => ALUOut, 
				MemtoReg   => MemtoReg,
				Write_Data => Write_Data
				);

control_unit_unit : control_unit 
	port map (
				CLK         => CLK, 
				reset       =>reset, 
				MemtoReg    => MemtoReg,
				RegDst      => RegDst,
				OPcode      => OPcode,  
				RegWrite    => RegWrite, 
				MemRead     => MemRead,
				MemWrite    => MemWrite , 
				PCWriteCond => PCWriteCond,  
				PCWrite     => PCWrite, 
				IorD        => IorD,
				IRWrite     => IRWrite ,  
				PCSource    => PCSource,  
				ALUSrcB     => ALUSrcB, 
				ALUSrcA     => ALUSrcA,
				Flag_State  => Flag_State ,
				ALUOPcode   => ALUOP
				);
 
PC_source_mux_unit : PC_source_mux 
	port map (
				PCSource   => PCSource,
				ALUOut     => ALUOut,
				ALU_result => ALU_result, 
				jumpAddr   => jumpAddr,
				PC_in      => PC_in
				);

PC_in_flag      <= PC_in;
adress_in_flag  <= adress_in;
RegB_flag       <= RegB;
zero_flag       <= zero;
PC_out_flag     <= PC_out;
MDR_out_flag    <= MDR_out;
IR_flag         <= IR;			
Write_Data_flag <= Write_Data;
RegA_flag       <= RegA;			
jumpAddr_flag   <= jumpAddr;			
OPcode_flag     <= OPcode;			
imm_flag        <= imm;
imm_shift_flag  <= imm_shift;
ALUOut_flag     <= ALUOut;			
ALU_result_flag <= ALU_result;			
Flag_State_flag <= Flag_State;			

end behavioral;  