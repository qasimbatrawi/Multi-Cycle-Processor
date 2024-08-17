module ControlUnit(clk , opcode , RegWr , MemRd , MemWr , ALUOP) ; 
	
	`define ADD 4'b0000
	`define SUB 4'b0001
	`define AND 4'b0010
	`define OR 4'b0011
	`define XOR 4'b0100
	`define LOAD 4'b0101
	`define STORE 4'b0110  
	
	input clk ;
	input [3:0] opcode ;
	output RegWr , MemRd , MemWr ;
	output [2:0] ALUOP ;
	
	assign RegWr = (clk && (opcode == `ADD || opcode == `SUB || opcode == `AND || opcode == `OR || opcode == `XOR || opcode == `LOAD)) ? 1 : 0 ;
	
	assign MemRd = (clk && opcode == `LOAD) ? 1 : 0 ;
	assign MemWr = (clk && (opcode == `STORE)) ? 1 : 0 ;

	assign ALUOP = (clk && opcode == `ADD) ? 4'b0000 :
               	   (clk && opcode == `SUB) ? 4'b0001 :
                   (clk && opcode == `AND) ? 4'b0010 :
                   (clk && opcode == `OR)  ? 4'b0011 :
                   (clk && opcode == `XOR) ? 4'b0100 : 4'b0000; // Default ALUOP is add	

endmodule	