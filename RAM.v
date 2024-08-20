module RAM(din, rx_valid, clk, rst_n, dout, tx_valid);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
input [ADDR_SIZE+1:0] din;
input rx_valid, clk, rst_n;
output reg [ADDR_SIZE-1:0] dout;
output reg tx_valid;

reg [ADDR_SIZE-1:0] mem [MEM_DEPTH-1:0];
 reg [ADDR_SIZE-1:0] wr_add, rd_add;


always @(posedge clk ) begin
	if (~rst_n) begin
		dout<=0;
		tx_valid<=0;
		wr_add<={ADDR_SIZE{1'b0}};
		rd_add<={ADDR_SIZE{1'b0}};
	end
	else if(rx_valid) begin
		   if(din[9:8]==2'b00)
		     wr_add<=din[7:0];
		  else if(din[9:8]==2'b01)
		     mem[wr_add]<=din[7:0];
		   else if (din[9:8]==2'b10)
		     rd_add<=din[7:0];
		 
    else if (din[9:8]==2'b11) begin
               dout<=mem[rd_add];
               tx_valid<=1;
          end
         end
     else
     tx_valid<=0; 
end

endmodule