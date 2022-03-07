#include "soc-hw.h"

uart_t   *uart0  = (uart_t *)   0xF0000000;
uart1_t   *uart1  = (uart1_t *) 0xF0030000;
uart2_t   *uart2  = (uart2_t *) 0xF0040000;//RFID
timer_t  *timer0 = (timer_t *)  0xF0010000;
gpio_t   *gpio0  = (gpio_t *)   0xF0020000;
//ultrasonico_t *ultrasonico0 = (ultrasonico_t *)   0xF0040000;
// uint32_t *sram0  = (uint32_t *) 0x40000000;

uint32_t msec = 0;
/***************************************************************************
 * General utility functions
 */

void sleep(int msec)
{
	uint32_t tcr;

	// Use timer0.1
	timer0->compare1 = (FCPU/1000)*msec;
	//timer0->compare1 = (FCPU/1000000)*msec;
	timer0->counter1 = 0;
	timer0->tcr1 = TIMER_EN | TIMER_IRQEN;

	do {
		//halt();
 		tcr = timer0->tcr1;
 	} while ( ! (tcr & TIMER_TRIG) );
}

void tic_init()
{
	// Setup timer0.0
	timer0->compare0 = (FCPU/1000);
	timer0->counter0 = 0;
	timer0->tcr0     = TIMER_EN | TIMER_AR | TIMER_IRQEN;
}

/***************************************************************************
 * UART0 Functions
 */
void uart0_init()
{
	//uart0->ier = 0x00;  // Interrupt Enable Register
	//uart0->lcr = 0x03;  // Line Control Register:    8N1
	//uart0->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart0->div = (FCPU/(57600*16));
}

char uart0_getchar()
{   
	while (! (uart0->ucr & UART_DR)) ;
	return uart0->rxtx;
}

void uart0_putchar(char c)
{
	while (uart0->ucr & UART_BUSY) ;
	uart0->rxtx = c;
}

void uart0_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart0_putchar(*c);
		c++;
	}
}

/***************************************************************************
*/

/***************************************************************************
 * UART1 Functions
 */
void uart1_init()
{
	//uart0->ier = 0x00;  // Interrupt Enable Register
	//uart0->lcr = 0x03;  // Line Control Register:    8N1
	//uart0->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart0->div = (FCPU/(57600*16));
}

char uart1_getchar()
{   
	while (! (uart1->ucr & UART_DR)) ;
	return uart1->rxtx;
}

void uart1_putchar(char c)
{
	while (uart1->ucr & UART_BUSY) ;
	uart1->rxtx = c;
}

void uart1_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart1_putchar(*c);
		c++;
	}
}

/***************************************************************************
*/



/***************************************************************************
 * UART2 Functions
 */
void uart2_init()
{
	//uart2->ier = 0x00;  // Interrupt Enable Register
	//uart2->lcr = 0x03;  // Line Control Register:    8N1
	//uart2->mcr = 0x00;  // Modem Control Register

	// Setup Divisor register (Fclk / Baud)
	//uart2->div = (FCPU/(57600*16));
}

char uart2_getchar()
{   
	while (! (uart2->ucr & UART_DR)) ;
	return uart2->rxtx;
}

void uart2_putchar(char c)
{
	while (uart2->ucr & UART_BUSY) ;
	uart2->rxtx = c;
}

void uart2_putstr(char *str)
{
	char *c = str;
	while(*c) {
		uart2_putchar(*c);
		c++;
	}
}

/***************************************************************************
  GPIO Functions*/
uint32_t readGpio()
{
return gpio0->in;
}

void writeGpio(int data)
{
gpio0->out = data;
}





