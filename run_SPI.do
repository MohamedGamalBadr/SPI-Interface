vlib work
vlog SPI_Slave.v RAM.v Master.v Master_tb.v
vsim -voptargs=+acc work.SPI_Master_tb
add wave /spi_interface/*
run -all
#quit -sim