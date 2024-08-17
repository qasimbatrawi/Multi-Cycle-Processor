module TB;
	
	reg clk ;
	wire [15:0] Out ;
	wire [15:0] fetchedInstruction ;
	
	Processor P1(clk , fetchedInstruction , Out) ;
	
	initial begin 
		
		clk = 0 ;
		
        repeat(32) begin
            #10 clk = ~clk;  // Delay specified with timescale in mind
        end
		
	end   	 

	
endmodule	