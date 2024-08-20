module SPI_Master(clk, rst_n, MOSI, SS_n,MISO);
input MOSI, SS_n, clk, rst_n;
output MISO;
wire [9:0] rx_data;
wire [7:0] tx_data;
wire rx_valid, tx_valid;
RAM m1(rx_data, rx_valid, clk, rst_n, tx_data, tx_valid);
SPI_Slave spi(MOSI, MISO, SS_n, clk, rst_n, rx_data, rx_valid, tx_data, tx_valid);
endmodule