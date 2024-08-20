module SPI_Slave(MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
parameter IDLE=3'b000;
parameter CHK_CMD=3'b001;
parameter WRITE=3'b010;
parameter READ_ADD=3'b011;
parameter READ_DATA=3'b100;
input MOSI, SS_n, clk, rst_n, tx_valid;
input [7:0] tx_data;
output reg MISO, rx_valid;
output reg [9:0] rx_data;
//(* fsm_encoding = "sequential" *)
//(* fsm_encoding = "gray" *)
(* fsm_encoding = "one_hot" *)
reg [2:0] cs,ns;
reg [3:0] counter;
reg addr_received=0;
reg [9:0] shift_reg;
// state memory
always @(posedge clk) begin
	if (~rst_n) begin
		cs<=IDLE; 
	end
	else begin
		cs<=ns;
	end
end

//Next state
always@(*) begin
	case(cs)
	    IDLE:   if(SS_n)
	                ns=IDLE;
	            else 
	                 ns=CHK_CMD;
        CHK_CMD: if(SS_n)
                      ns=IDLE;
                  else if(SS_n==0 && MOSI==0)
                      ns=WRITE;
                  else if(SS_n==0 && MOSI==1 && addr_received==0)
                      ns=READ_ADD;
                   else 
                      ns=READ_DATA;
        WRITE:  if(SS_n==1)
                    ns=IDLE;
                else 
                     ns=WRITE;
        READ_ADD: if(SS_n==1 )
                    ns=IDLE;
                  else 
                     ns=READ_ADD;
        READ_DATA:  if(SS_n==1)
                       ns=IDLE;
                    else 
                       ns=READ_DATA;
        default: ns=IDLE;
        endcase
end

//output logic
always @(posedge clk) begin
    if(~rst_n) begin
    	 rx_data<=0; rx_valid<=0; MISO<=0; counter<=0; shift_reg<=0; addr_received<=0;
    end
	case(cs) 
	IDLE:    begin
		       rx_valid<=0;  counter<=0; MISO<=0;
	         end
	CHK_CMD:  begin
		      rx_valid<=0; counter<=0; shift_reg<=0;
	         end
	WRITE: begin 
	           if(counter>=0 && counter<10) begin
	           	  shift_reg<={shift_reg[8:0], MOSI};        	  
	           end
	           if(counter==10) begin
	           	   rx_data<=shift_reg;
	           	   rx_valid<=1;
	           end
	             if(counter<10)
	           counter<=counter+1;
	             else 
	                counter<=0;
		       end
    READ_ADD: begin  if(counter>=0 && counter <10) begin
	           	  shift_reg<={shift_reg[8:0], MOSI};
	           end
	           if(counter==10) begin
	           	   rx_data<=shift_reg;
	           	   rx_valid<=1;
	           	   addr_received<=1;
	           end
	             if(counter<10)
	           counter<=counter+1;
	             else 
	                counter<=0;
	           end
	READ_DATA: begin 
		       if(counter==0) begin
	           	  shift_reg<={shift_reg[8:0], MOSI};
	           end
	            else if (counter==1) begin
	               rx_data<={shift_reg[0],MOSI, 8'd0};
	               rx_valid<=1;
	            end
	             else if(counter>2 && counter <=10) begin
	             	 MISO<=tx_data[10-counter];
	             end
	             if (counter==10)
	                addr_received<=0;
	                 if(counter<10)
	           counter<=counter+1;
	             else 
	                counter<=0;
	           end
	default: begin
		     rx_data<=0; rx_valid<=0; MISO<=0; counter<=0; shift_reg<=0; addr_received<=0;
	         end
	endcase
end
endmodule