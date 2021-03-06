//---------------------------------------------------------------------------
// LatticeMico32 System On A Chip
//
// Top Level Design for the Xilinx Spartan 3-200 Starter Kit
//---------------------------------------------------------------------------

module system
#(
//	parameter   bootram_file     = "../firmware/cain_loader/image.ram",
//	parameter   bootram_file     = "../firmware/boot0-serial/image.ram",
	parameter   bootram_file     = "../firmware/proyecto/image.ram",
	parameter   clk_freq         = 100000000,
	parameter   uart_baud_rate   = 9600
) (
	    input             clk, 
        input             rst,
	// UART0
        input             UartRx,
        output            UartTx,
	// UART1
        input             Uart1Rx,
        output            Uart1Tx,
	// UART2
        input             Uart2Rx,
        output            Uart2Tx,

	//GPIO
	inout [7:0] leds
);
	
	
//------------------------------------------------------------------
// Whishbone Wires
//------------------------------------------------------------------
wire         gnd   =  1'b0;
wire   [3:0] gnd4  =  4'h0;
wire  [31:0] gnd32 = 32'h00000000;

 
wire [31:0]  lm32i_adr,
             lm32d_adr,
             uart0_adr,
	     uart1_adr,
	     uart2_adr, //RFID
	     gpio0_adr, //JAVIER-------------------
             timer0_adr,
             bram0_adr,
             sram0_adr;


wire [31:0]  lm32i_dat_r,
             lm32i_dat_w,
             lm32d_dat_r,
             lm32d_dat_w,
             uart0_dat_r,
             uart0_dat_w,
             uart1_dat_r,
             uart1_dat_w,
             uart2_dat_r, //RFID
             uart2_dat_w, //
             gpio0_dat_r, //JAVIER------------------
             gpio0_dat_w,
             timer0_dat_r,
             timer0_dat_w,
             bram0_dat_r,
             bram0_dat_w,
             sram0_dat_w,
             sram0_dat_r;

wire [3:0]   lm32i_sel,
             lm32d_sel,
             uart0_sel,
	     uart1_sel,
	     uart2_sel, //RFID
	     gpio0_sel, //JAVIER -------------
             timer0_sel,
             bram0_sel,
             sram0_sel;

wire         lm32i_we,
             lm32d_we,
             uart0_we,
	     uart1_we,
	     uart2_we, //RFID
             gpio0_we, //JAVIER ---------------
             timer0_we,
             bram0_we,
             sram0_we;

wire         lm32i_cyc,
             lm32d_cyc,
             uart0_cyc,
	     uart1_cyc,
	     uart2_cyc, //RFID
	     gpio0_cyc, //JAVIER -----------------
             timer0_cyc,
             bram0_cyc,
             sram0_cyc;

wire         lm32i_stb,
             lm32d_stb,
             uart0_stb,
             uart1_stb,
             uart2_stb, //RFID
             gpio0_stb, //JAVIER --------------
             timer0_stb,
             bram0_stb,
             sram0_stb;

wire         lm32i_ack,
             lm32d_ack,
             uart0_ack,
	     uart1_ack,
	     uart2_ack, //RFID
	     gpio0_ack, //JAVIER --------------
             timer0_ack,         
             bram0_ack,
             sram0_ack;

wire         lm32i_rty,
             lm32d_rty;

wire         lm32i_err,
             lm32d_err;

wire         lm32i_lock,
             lm32d_lock;

wire [2:0]   lm32i_cti,
             lm32d_cti;

wire [1:0]   lm32i_bte,
             lm32d_bte;

//---------------------------------------------------------------------------
// Interrupts
//---------------------------------------------------------------------------//??qu?? hace esto defino para uart1 y uart2?
wire [31:0]  intr_n;
wire         uart0_intr = 0;
wire   [1:0] timer0_intr;
wire        gpio0_intr;

assign intr_n = { 28'hFFFFFFF, ~timer0_intr[1], ~gpio0_intr, ~timer0_intr[0], ~uart0_intr };

//ultrasonic ultrasonic(clk,reset,ping,distance);

//---------------------------------------------------------------------------
// Wishbone Interconnect
//---------------------------------------------------------------------------
wb_conbus_top #(
	.s0_addr_w ( 3 ),
	.s0_addr   ( 3'h4 ),        // sram0
	.s1_addr_w ( 3 ),
	.s1_addr   ( 3'h5 ),        
	.s27_addr_w( 15 ),
	.s2_addr   ( 15'h0000 ),    // bram0 
	.s3_addr   ( 15'h7000 ),    // uart0
	.s4_addr   ( 15'h7001 ),    // timer0
	.s5_addr   ( 15'h7004 ),    // UART2
	.s6_addr   ( 15'h7003 ),	// UART1
	.s7_addr   ( 15'h7002 )     //GPIO
) conmax0 (
	.clk_i( clk ),
	.rst_i( ~rst ),
	// Master0
	.m0_dat_i(  lm32i_dat_w  ),
	.m0_dat_o(  lm32i_dat_r  ),
	.m0_adr_i(  lm32i_adr    ),
	.m0_we_i (  lm32i_we     ),
	.m0_sel_i(  lm32i_sel    ),
	.m0_cyc_i(  lm32i_cyc    ),
	.m0_stb_i(  lm32i_stb    ),
	.m0_ack_o(  lm32i_ack    ),
	.m0_rty_o(  lm32i_rty    ),
	.m0_err_o(  lm32i_err    ),
	// Master1
	.m1_dat_i(  lm32d_dat_w  ),
	.m1_dat_o(  lm32d_dat_r  ),
	.m1_adr_i(  lm32d_adr    ),
	.m1_we_i (  lm32d_we     ),
	.m1_sel_i(  lm32d_sel    ),
	.m1_cyc_i(  lm32d_cyc    ),
	.m1_stb_i(  lm32d_stb    ),
	.m1_ack_o(  lm32d_ack    ),
	.m1_rty_o(  lm32d_rty    ),
	.m1_err_o(  lm32d_err    ),
	// Master2
	.m2_dat_i(  gnd32  ),
	.m2_adr_i(  gnd32  ),
	.m2_sel_i(  gnd4   ),
	.m2_cyc_i(  gnd    ),
	.m2_stb_i(  gnd    ),
	// Master3
	.m3_dat_i(  gnd32  ),
	.m3_adr_i(  gnd32  ),
	.m3_sel_i(  gnd4   ),
	.m3_cyc_i(  gnd    ),
	.m3_stb_i(  gnd    ),
	// Master4
	.m4_dat_i(  gnd32  ),
	.m4_adr_i(  gnd32  ),
	.m4_sel_i(  gnd4   ),
	.m4_cyc_i(  gnd    ),
	.m4_stb_i(  gnd    ),
	// Master5
	.m5_dat_i(  gnd32  ),
	.m5_adr_i(  gnd32  ),
	.m5_sel_i(  gnd4   ),
	.m5_cyc_i(  gnd    ),
	.m5_stb_i(  gnd    ),
	// Master6
	.m6_dat_i(  gnd32  ),
	.m6_adr_i(  gnd32  ),
	.m6_sel_i(  gnd4   ),
	.m6_cyc_i(  gnd    ),
	.m6_stb_i(  gnd    ),
	// Master7
	.m7_dat_i(  gnd32  ),
	.m7_adr_i(  gnd32  ),
	.m7_sel_i(  gnd4   ),
	.m7_cyc_i(  gnd    ),
	.m7_stb_i(  gnd    ),

	// Slave0
	.s0_dat_i(  sram0_dat_r   ),
	.s0_dat_o(  sram0_dat_w   ),
	.s0_adr_o(  sram0_adr     ),
	.s0_sel_o(  sram0_sel     ),
	.s0_we_o(   sram0_we      ),
	.s0_cyc_o(  sram0_cyc     ),
	.s0_stb_o(  sram0_stb     ),
	.s0_ack_i(  sram0_ack     ),
	.s0_err_i(  gnd    ),
	.s0_rty_i(  gnd    ),
	// Slave1
	.s1_dat_i(  gnd32  ),
	.s1_ack_i(  gnd    ),
	.s1_err_i(  gnd    ),
	.s1_rty_i(  gnd    ),
	// Slave2
	.s2_dat_i(  bram0_dat_r ),
	.s2_dat_o(  bram0_dat_w ),
	.s2_adr_o(  bram0_adr   ),
	.s2_sel_o(  bram0_sel   ),
	.s2_we_o(   bram0_we    ),
	.s2_cyc_o(  bram0_cyc   ),
	.s2_stb_o(  bram0_stb   ),
	.s2_ack_i(  bram0_ack   ),
	.s2_err_i(  gnd         ),
	.s2_rty_i(  gnd         ),
	// Slave3
	.s3_dat_i(  uart0_dat_r ),
	.s3_dat_o(  uart0_dat_w ),
	.s3_adr_o(  uart0_adr   ),
	.s3_sel_o(  uart0_sel   ),
	.s3_we_o(   uart0_we    ),
	.s3_cyc_o(  uart0_cyc   ),
	.s3_stb_o(  uart0_stb   ),
	.s3_ack_i(  uart0_ack   ),
	.s3_err_i(  gnd         ),
	.s3_rty_i(  gnd         ),
	// Slave4
	.s4_dat_i(  timer0_dat_r ),
	.s4_dat_o(  timer0_dat_w ),
	.s4_adr_o(  timer0_adr   ),
	.s4_sel_o(  timer0_sel   ),
	.s4_we_o(   timer0_we    ),
	.s4_cyc_o(  timer0_cyc   ),
	.s4_stb_o(  timer0_stb   ),
	.s4_ack_i(  timer0_ack   ),
	.s4_err_i(  gnd          ),
	.s4_rty_i(  gnd          ),
	// Slave5
	.s5_dat_i(  uart2_dat_r ),
	.s5_dat_o(  uart2_dat_w ),
	.s5_adr_o(  uart2_adr   ),
	.s5_sel_o(  uart2_sel   ),
	.s5_we_o(   uart2_we    ),
	.s5_cyc_o(  uart2_cyc   ),
	.s5_stb_o(  uart2_stb   ),
	.s5_ack_i(  uart2_ack   ),
	.s5_err_i(  gnd         ),
	.s5_rty_i(  gnd         ),
	// Slave6
	.s6_dat_i(  uart1_dat_r ),
	.s6_dat_o(  uart1_dat_w ),
	.s6_adr_o(  uart1_adr   ),
	.s6_sel_o(  uart1_sel   ),
	.s6_we_o(   uart1_we    ),
	.s6_cyc_o(  uart1_cyc   ),
	.s6_stb_o(  uart1_stb   ),
	.s6_ack_i(  uart1_ack   ),
	.s6_err_i(  gnd         ),
	.s6_rty_i(  gnd         ),
	// Slave7
	.s7_dat_i(  gpio0_dat_r ), //JAVIER ------------------------------------------------
	.s7_dat_o(  gpio0_dat_w ),
	.s7_adr_o(  gpio0_adr   ),
	.s7_sel_o(  gpio0_sel   ),
	.s7_we_o(   gpio0_we    ),
	.s7_cyc_o(  gpio0_cyc   ),
	.s7_stb_o(  gpio0_stb   ),
	.s7_ack_i(  gpio0_ack   ),
	.s7_err_i(  gnd         ),
	.s7_rty_i(  gnd         )
);


//---------------------------------------------------------------------------
// LM32 CPU 
//---------------------------------------------------------------------------
lm32_cpu lm0 (
	.clk_i(  clk  ),
	.rst_i(  ~rst  ),
	.interrupt_n(  intr_n  ),
	//
	.I_ADR_O(  lm32i_adr    ),
	.I_DAT_I(  lm32i_dat_r  ),
	.I_DAT_O(  lm32i_dat_w  ),
	.I_SEL_O(  lm32i_sel    ),
	.I_CYC_O(  lm32i_cyc    ),
	.I_STB_O(  lm32i_stb    ),
	.I_ACK_I(  lm32i_ack    ),
	.I_WE_O (  lm32i_we     ),
	.I_CTI_O(  lm32i_cti    ),
	.I_LOCK_O( lm32i_lock   ),
	.I_BTE_O(  lm32i_bte    ),
	.I_ERR_I(  lm32i_err    ),
	.I_RTY_I(  lm32i_rty    ),
	//
	.D_ADR_O(  lm32d_adr    ),
	.D_DAT_I(  lm32d_dat_r  ),
	.D_DAT_O(  lm32d_dat_w  ),
	.D_SEL_O(  lm32d_sel    ),
	.D_CYC_O(  lm32d_cyc    ),
	.D_STB_O(  lm32d_stb    ),
	.D_ACK_I(  lm32d_ack    ),
	.D_WE_O (  lm32d_we     ),
	.D_CTI_O(  lm32d_cti    ),
	.D_LOCK_O( lm32d_lock   ),
	.D_BTE_O(  lm32d_bte    ),
	.D_ERR_I(  lm32d_err    ),
	.D_RTY_I(  lm32d_rty    )
);
	
//---------------------------------------------------------------------------
// Block RAM
//---------------------------------------------------------------------------
wb_bram #(
	.adr_width( 12 ),
	.mem_file_name( bootram_file )
) bram0 (
	.clk_i(  clk  ),
	.rst_i(  ~rst  ),
	//
	.wb_adr_i(  bram0_adr    ),
	.wb_dat_o(  bram0_dat_r  ),
	.wb_dat_i(  bram0_dat_w  ),
	.wb_sel_i(  bram0_sel    ),
	.wb_stb_i(  bram0_stb    ),
	.wb_cyc_i(  bram0_cyc    ),
	.wb_ack_o(  bram0_ack    ),
	.wb_we_i(   bram0_we     )
);

//---------------------------------------------------------------------------
// uart0
//---------------------------------------------------------------------------
//wire uart0_rxd;
//wire uart0_txd;

wb_uart #(
	.clk_freq( clk_freq        ),
	.baud(     uart_baud_rate  )
) uart0 (
	.clk( clk ),
	.reset( ~rst ),
	//
	.wb_adr_i( uart0_adr ),
	.wb_dat_i( uart0_dat_w ),
	.wb_dat_o( uart0_dat_r ),
	.wb_stb_i( uart0_stb ),
	.wb_cyc_i( uart0_cyc ),
	.wb_we_i(  uart0_we ),
	.wb_sel_i( uart0_sel ),
	.wb_ack_o( uart0_ack ), 
//	.intr(       uart0_intr ),
	.uart_rxd( UartRx ),
	.uart_txd( UartTx )
);

//---------------------------------------------------------------------------
// uart1
//---------------------------------------------------------------------------
//wire uart1_rxd;
//wire uart1_txd;

wb_uart #(
	.clk_freq( clk_freq        ),
	.baud(     uart_baud_rate  )
) uart1 (
	.clk( clk ),
	.reset( ~rst ),
	//
	.wb_adr_i( uart1_adr ),
	.wb_dat_i( uart1_dat_w ),
	.wb_dat_o( uart1_dat_r ),
	.wb_stb_i( uart1_stb ),
	.wb_cyc_i( uart1_cyc ),
	.wb_we_i(  uart1_we ),
	.wb_sel_i( uart1_sel ),
	.wb_ack_o( uart1_ack ), 
//	.intr(       uart0_intr ),
	.uart_rxd( Uart1Rx ),
	.uart_txd( Uart1Tx )
);

//---------------------------------------------------------------------------
// uart2
//---------------------------------------------------------------------------
//wire uart2_rxd;
//wire uart2_txd;

wb_uart #(
	.clk_freq( clk_freq        ),
	.baud(     uart_baud_rate  )
) uart2 (
	.clk( clk ),
	.reset( ~rst ),
	//
	.wb_adr_i( uart2_adr ),
	.wb_dat_i( uart2_dat_w ),
	.wb_dat_o( uart2_dat_r ),
	.wb_stb_i( uart2_stb ),
	.wb_cyc_i( uart2_cyc ),
	.wb_we_i(  uart2_we ),
	.wb_sel_i( uart2_sel ),
	.wb_ack_o( uart2_ack ), 
//	.intr(       uart2_intr ),
	.uart_rxd( Uart2Rx ),
	.uart_txd( Uart2Tx )
);


//---------------------------------------------------------------------------
// timer0
//---------------------------------------------------------------------------
wb_timer #(
	.clk_freq(   clk_freq  )
) timer0 (
	.clk(      clk          ),
	.reset(    ~rst          ),
	//
	.wb_adr_i( timer0_adr   ),
	.wb_dat_i( timer0_dat_w ),
	.wb_dat_o( timer0_dat_r ),
	.wb_stb_i( timer0_stb   ),
	.wb_cyc_i( timer0_cyc   ),
	.wb_we_i(  timer0_we    ),
	.wb_sel_i( timer0_sel   ),
	.wb_ack_o( timer0_ack   ), 
	.intr(  timer0_intr  )
);

//---------------------------------------------------------------------------JAVIER
// General Purpose IO
//---------------------------------------------------------------------------

wire [31:0] gpio0_in;
wire [31:0] gpio0_out;
wire [31:0] gpio0_oe;

wb_gpio gpio0 (
    .clk(      clk          ),
    .reset(    ~rst          ),
    //
    .wb_adr_i( gpio0_adr    ),
    .wb_dat_i( gpio0_dat_w  ),
    .wb_dat_o( gpio0_dat_r  ),
    .wb_stb_i( gpio0_stb    ),
    .wb_cyc_i( gpio0_cyc    ),
    .wb_we_i(  gpio0_we     ),
    .wb_sel_i( gpio0_sel    ),
    .wb_ack_o( gpio0_ack    ),
    //.intr(     gpio0_intr   ),
    // GPIO
    .gpio_in(  gpio0_in     ),
    .gpio_out( gpio0_out    ),
    .gpio_oe(  gpio0_oe     )
);
	
assign leds[0]= gpio0_out[0];
assign leds[1]= gpio0_out[1];
assign leds[2]= gpio0_out[2];
assign leds[3]= gpio0_out[3];
	assign leds[4]= gpio0_out[4];
	assign leds[5]= gpio0_out[5];
	assign leds[6]= gpio0_out[6];
	assign leds[7]= gpio0_out[7];




//----------------------------------------------------------------------------
// Mux UART wires according to sw[0]
//----------------------------------------------------------------------------

endmodule 
