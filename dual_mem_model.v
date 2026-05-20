module dual_mem_model #(
	parameter ADDR_WIDTH = 3,
	parameter DATA_WIDTH = 8
)
(
	input clk,
	input [DATA_WIDTH-1:0] wdata0, 
	input [ADDR_WIDTH-1:0] addr0,
	input we0, 
	input [DATA_WIDTH-1:0] wdata1, 
	input [ADDR_WIDTH-1:0] addr1, 
	input we1, 
	output reg [DATA_WIDTH-1:0] rdata0, 
	output reg [DATA_WIDTH-1:0] rdata1  
);

	parameter MEMORY_DEPTH = 2**ADDR_WIDTH;

	reg [DATA_WIDTH-1:0] memory [MEMORY_DEPTH-1:0]; 

	// This is the write block
	always@(posedge clk) begin
		if((addr0 == addr1) && (we0 == 1 && we1 == 1)) begin
			memory[addr0] <= 'x;	
		end 
		
		else if (we0 == 0  && we1 == 1) begin	
			memory[addr1] <= wdata1;
		end 

		else if (we0 == 1 && we1 == 0) begin	
			memory[addr0] <= wdata0;
		end
	end

	// This is the reading block
	always@(*) begin
		if((addr0 == addr1) && (we0 == 1 && we1 == 1)) begin
			rdata1 = 'x;
			rdata0 = 'x;
		end 

		else if (we0 == 0  && we1 == 1) begin	
			if( addr0 == addr1 ) begin 
				rdata0 = 'x;
			end
		end 

		else if (we0 == 1 && we1 == 0) begin	
			if( addr1 == addr0 ) begin
				rdata1 = 'x;
			end
		end 

		else begin
			rdata0 = memory[addr0];
			rdata1 = memory[addr1];
		end
	end
endmodule
