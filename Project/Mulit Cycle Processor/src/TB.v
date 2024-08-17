module TB;
	
	reg clk ;
	wire [15:0] Out ;
	wire [15:0] IR , Stored , Loaded ;
	
	Processor P1(clk , IR , Loaded , Stored , Out) ;
	
	initial begin 
		
		clk = 0 ;
		
        repeat(64) begin
            #10ns clk = ~clk;
        end
		
	end   	 

	
endmodule	