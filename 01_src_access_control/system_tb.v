//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
`timescale 1 ns / 100 ps

module system_tb;

//----------------------------------------------------------------------------
// Parameter (may differ for physical synthesis)
//----------------------------------------------------------------------------
parameter tck              = 20;       // clock period in ns
parameter uart_baud_rate   = 9600;  // uart baud rate for simulation 

parameter clk_freq = 1000000000 / tck; // Frequenzy in HZ
//----------------------------------------------------------------------------
//
//----------------------------------------------------------------------------
reg        clk;
reg        rst;
//reg        echoMedida;

//wire triger;
//wire LedPrueba;
//----------------------------------------------------------------------------
// UART STUFF (testbench uart, simulating a comm. partner)
//----------------------------------------------------------------------------
wire         uart_rxd;
wire         uart_txd;

wire       [7:0] gpio_io;

//----------------------------------------------------------------------------
// Device Under Test 
//----------------------------------------------------------------------------
system #(
	.clk_freq(           clk_freq         ),
	.uart_baud_rate(     uart_baud_rate   )
) dut  (
	.clk(  clk    ),
	// Debug
	.rst(   rst    ),
        //.echoMedida(   echoMedida   )
	// Uart
	.UartTx(  uart_txd  ),
	.leds(gpio_io)

);
////////////////////////////////////////////
 


////////////////////////////////////////////

/* Clocking device */
initial         clk <= 0;
always #(tck/2) clk <= ~clk;

/* Simulation setup */
initial begin



	$dumpfile("system_tb.vcd");

$monitor("%b,%b,%b,%b",clk,rst,uart_txd,gpio_io);
	$dumpvars(-1, dut);
	$dumpvars(-1,clk,rst,uart_txd,gpio_io);
	// reset
	#0  rst <= 0;
	#80 rst <= 1;
        //#10 echoMedida<=0;
        //#10 echoMedida<=1;
        //#60000 echoMedida<=0;

	#(tck*100000) $finish;
end



endmodule
