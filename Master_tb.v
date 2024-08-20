module SPI_Master_tb();
reg MOSI, SS_n, clk, rst_n;
wire MISO;
SPI_Master spi_interface(clk, rst_n, MOSI, SS_n,MISO);
initial begin
	clk=0;
	forever
	#1 clk=~clk;
end

initial begin
$readmemh ("mem.dat", spi_interface.m1.mem);
rst_n=0; MOSI=0; SS_n=1; @(negedge clk);
rst_n=1; @(negedge clk);
SS_n=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
repeat(8) begin
	MOSI=1;
	@(negedge clk);
end

SS_n=1; MOSI=0; @(negedge clk); 
SS_n=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=1; @(negedge clk);
repeat(8) begin
    MOSI=1;
	@(negedge clk);
end

SS_n=1; @(negedge clk);
SS_n=0; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=0; @(negedge clk);
repeat(8) begin
    MOSI=1;
	@(negedge clk);
end

SS_n=1; MOSI=0; @(negedge clk);
SS_n=0; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
repeat(8) begin
    MOSI=1;
	@(negedge clk);
end


SS_n=1; @(negedge clk);
SS_n=1; @(negedge clk);

SS_n=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
repeat(8) begin
	MOSI=$random;
	@(negedge clk);
end

SS_n=1; MOSI=0; @(negedge clk); 
SS_n=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=0; @(negedge clk);
MOSI=1; @(negedge clk);
repeat(8) begin
    MOSI=$random;
	@(negedge clk);
end

SS_n=1; @(negedge clk);
SS_n=0; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=0; @(negedge clk);
repeat(8) begin
    MOSI=$random;
	@(negedge clk);
end

SS_n=1; MOSI=0; @(negedge clk);
SS_n=0; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
MOSI=1; @(negedge clk);
repeat(8) begin
    MOSI=$random;
	@(negedge clk);
end
SS_n=0; @(negedge clk);
SS_n=1; @(negedge clk);
$stop;
end
endmodule