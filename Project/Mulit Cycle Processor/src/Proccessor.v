module Processor(clk , fetchedInstruction , Out) ;
	
	`define FETCH 3'b000
	`define DECODE 3'b001
	`define EXECUTE 3'b010
	`define RESSTORE1 3'b011
	`define RESSTORE2 3'b100
	`define RESSTORE3 3'b101
	
	// define alu operation
	`define OPADD 4'b0000
	`define OPSUB 4'b0001
	`define OPAND 4'b0010
	`define OPOR 4'b0011
	`define OPXOR 4'b0100
	`define OPLOAD 4'b0101
	`define OPSTORE 4'b0110
	
	// define for control signals
	`define ADD 6'b100000
	`define SUB 6'b100001
	`define AND 6'b100010
	`define OR 6'b100011
	`define XOR 6'b100100
	`define LOAD 6'b110000
	`define STORE 6'b001000
	
	input clk ;
	
	output reg [15:0] Out ;
	output reg [15:0] fetchedInstruction ;
	
	reg RegWr , MemRd , MemWr ;
	reg [2:0] ALUOP ;
	
	reg [3:0] source1 , source2 ; // this is the address for the source register to read data from it 
    reg [3:0] destination ; // this is the address for the dest. reg. to store data in it
	reg [3:0] opcode ;

   	reg [15:0] source1Content , source2Content ; // to fetch the data inside the registers	
	reg [15:0] destinationContent ; // this is to store the destinationn content 
	reg [15:0] pc ;
	
	reg [2:0] state ;
	
	reg [15:0] AluOut ;

    reg [15:0] registers [15:0] ;
	initial begin
	    registers[0]  = 16'h0010;
	    registers[1]  = 16'h0020;
	    registers[2]  = 16'h0030;
	    registers[3]  = 16'h00AA;
	    registers[4]  = 16'h1C3A;
	    registers[5]  = 16'h1180;
	    registers[6]  = 16'h22E0;
	    registers[7]  = 16'h1C86;
	    registers[8]  = 16'h22DA;
	    registers[9]  = 16'h0414;
	    registers[10] = 16'h1A32;
	    registers[11] = 16'h0102;
	    registers[12] = 16'h1CBA;
	    registers[13] = 16'h0CDE;
	    registers[14] = 16'h3994;
	    registers[15] = 16'h1984;
	end
	
	reg [15:0] DataMemory [15:0] ;
	
	initial begin
		pc = 0 ;
		state = 0 ;
		DataMemory[0] = 16'h0001 ;
		DataMemory[1] = 16'h0020 ;
		DataMemory[2] = 16'h0000 ;
		DataMemory[3] = 16'h00AA ;
		DataMemory[4] = 16'h1C3A ;
		DataMemory[5] = 16'h0000 ;
		DataMemory[6] = 16'h22E0 ; 
		DataMemory[7] = 16'h0000 ;
		DataMemory[8] = 16'h22DA ;
		DataMemory[9] = 16'h0000 ;
		DataMemory[10] = 16'h1A32 ;
		DataMemory[11] = 16'h0102 ;
		DataMemory[12] = 16'h000 ;
		DataMemory[13] = 16'h0CDE ;
		DataMemory[14] = 16'h0000 ;
		DataMemory[15] = 16'h1984 ;
	end
	
	reg [15:0] InstructionMemory [15:0] ; // this is instruction memory

	initial begin
		InstructionMemory[0] = 16'h0312 ;
		InstructionMemory[1] = 16'h3ABA ;
		InstructionMemory[2] = 16'h2296 ;
		InstructionMemory[3] = 16'h00AA ;
		InstructionMemory[4] = 16'h1C3A ;
		InstructionMemory[5] = 16'h1180 ;
		InstructionMemory[6] = 16'h22E0 ; 
		InstructionMemory[7] = 16'h1C86 ;
		InstructionMemory[8] = 16'h22DA ;
		InstructionMemory[9] = 16'h0414 ;
		InstructionMemory[10] = 16'h1A32 ;
		InstructionMemory[11] = 16'h0102 ;
		InstructionMemory[12] = 16'h1CBA ;
		InstructionMemory[13] = 16'h0CDE ;
		InstructionMemory[14] = 16'h3994 ;
		InstructionMemory[15] = 16'h1984 ;
	end	
	
	
	always @ (posedge clk) 	begin
		
		case (state)
			
			`FETCH: begin
				
				fetchedInstruction = InstructionMemory[pc] ;
				
				pc = pc + 1 ;	 
				
				state = 3'b001 ;
				
			end
			
			`DECODE: begin //decode and initialize control signals						   
				
				{opcode , destination , source1 , source2} = fetchedInstruction ;

				case (opcode)  
					
					`OPADD: begin RegWr = 1 ; MemRd=0 ; MemWr=0 ; ALUOP=0 ; end
					`OPSUB: begin RegWr=1 ; MemRd=0 ; MemWr=0 ; ALUOP=1 ;	end
					`OPAND: begin RegWr=1 ; MemRd=0 ; MemWr=0 ; ALUOP=2 ; end
					`OPOR: begin RegWr=1 ; MemRd=0 ; MemWr=0 ; ALUOP=3 ; end
					`OPXOR: begin RegWr=1 ; MemRd=0 ; MemWr=0 ; ALUOP=4 ; end
					`OPLOAD: begin RegWr=1 ; MemRd=1 ; MemWr=0 ; ALUOP=0 ; end // 0 is any value for ALUOP
					`OPSTORE: begin RegWr=0 ; MemRd=0 ; MemWr=1 ; ALUOP=0 ; end // 0 is any value for ALUOP
					default: begin RegWr=1 ; MemRd=0 ; MemWr=0 ; ALUOP=0 ; end  // default case is add
						
				endcase
				
				state = 3'b010 ;
				
			end
			
			`EXECUTE: begin
				
				case ({RegWr , MemRd , MemWr , ALUOP}) 
			
					`ADD: begin 
							 
							 source1Content = registers[source1] ;
							 source2Content = registers[source2] ;
						
							 AluOut = source1Content + source2Content ;
							 
							 state = 3'b011 ;
						
					end
					
					
					`SUB: begin  
					
							source1Content = registers[source1] ;
							source2Content = registers[source2] ;
						
							AluOut = source1Content - source2Content ;
							
							state = 3'b011 ;

					end
					
					`AND: begin 
						
						source1Content = registers[source1] ;
						source2Content = registers[source2] ;
					
						AluOut = source1Content & source2Content ;
						
						state = 3'b011 ;
					
					end
					
					`OR: begin 
						
						source1Content = registers[source1] ;
						source2Content = registers[source2] ;
					
						AluOut = source1Content | source2Content ;
						
						state = 3'b011 ;
					
					end	
					
					`XOR: begin 
						
						source1Content = registers[source1] ;
						source2Content = registers[source2] ;
					
						AluOut = source1Content ^ source2Content ;
						
						state = 3'b011 ;

					end	
					
					
					`LOAD: begin 
						
						source1Content = registers[source1] ;
						
						state = 3'b100 ;
					
					end	
						
					`STORE: begin  
						
						source1Content = registers[source1] ;
						
						state = 3'b101 ;
					
					end
					
					
					default: begin // default case is return to fetch
							 
							 state = 3'b000 ;
							
					end
					
					
				endcase
				
				
			end
			
			`RESSTORE1: begin // after (add sub or xor and)
				
					registers[destination] = AluOut ;	
							 
					Out = AluOut ;
					
					state = 3'b000 ;
			end
			
			`RESSTORE2: begin // after load	 
				
				 		registers[destination] = DataMemory[source1Content] ;
						
						Out = DataMemory[source1Content] ;
						
						state = 3'b000 ;
			end
			
			`RESSTORE3: begin // after store
						
				DataMemory[source1Content] = registers[destination] ; 
				
				Out = registers[destination] ;
				
				state = 3'b000 ;
				
			end
			
			default: begin // default case is return to fetch
							 
				 state = 3'b000 ;
					
			end
			
			
		endcase
		
		
	end
		
endmodule