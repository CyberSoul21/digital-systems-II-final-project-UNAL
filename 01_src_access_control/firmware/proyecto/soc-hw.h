#ifndef SPIKEHW_H
#define SPIKEHW_H

#define PROMSTART 0x00000000
#define RAMSTART  0x00000800
#define RAMSIZE   0x400
#define RAMEND    (RAMSTART + RAMSIZE)

#define RAM_START 0x40000000
#define RAM_SIZE  0x04000000

#define FCPU      100000000

#define UART_RXBUFSIZE 32

/****************************************************************************
 * Types
 */
typedef unsigned int  uint32_t;    // 32 Bit
typedef signed   int   int32_t;    // 32 Bit
typedef unsigned short int uint16_t; //16 bits
typedef unsigned char  uint8_t;    // 8 Bit
typedef signed   char   int8_t;    // 8 Bit
typedef float	float_t;

/****************************************************************************
 * Interrupt handling
 */
typedef void(*isr_ptr_t)(void);

void     irq_enable();
void     irq_disable();
void     irq_set_mask(uint32_t mask);
uint32_t irq_get_mak();

void     isr_init();
void     isr_register(int irq, isr_ptr_t isr);
void     isr_unregister(int irq);

/****************************************************************************
 * General Stuff
 */
void     halt();
void     jump(uint32_t addr);


/****************************************************************************
 * Timer
 */
#define TIMER_EN     0x08    // Enable Timer
#define TIMER_AR     0x04    // Auto-Reload
#define TIMER_IRQEN  0x02    // IRQ Enable
#define TIMER_TRIG   0x01    // Triggered (reset when writing to TCR)

typedef struct {
    volatile uint32_t tcr0;
    volatile uint32_t compare0;
    volatile uint32_t counter0;
    volatile uint32_t tcr1;
    volatile uint32_t compare1;
    volatile uint32_t counter1;
} timer_t;

void msleep(uint32_t msec);
void nsleep(uint32_t nsec);
void tic_init();

/***************************************************************************
 * GPIO0
 */
typedef struct {
	volatile uint32_t ctrl;
	volatile uint32_t dummy1;
	volatile uint32_t dummy2;
	volatile uint32_t dummy3;
	volatile uint32_t in;
	volatile uint32_t out;
	volatile uint32_t oe;
} gpio_t;

uint32_t readGpio();
void writeGpio(int data);
//void set_pin(uint8_t value, uint8_t npin);
//void pin_inv(uint8_t npin);

/***************************************************************************

/***************************************************************************
 * UART0
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart_t;

void uart0_init();
void uart0_putchar(char c);
void uart0_putstr(char *str);
char uart0_getchar();

/***************************************************************************
 * UART1
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart1_t;

void uart1_init();
void uart1_putchar(char c);
void uart1_putstr(char *str);
char uart1_getchar();


/***************************************************************************
 * UART2
 */
#define UART_DR   0x01                    // RX Data Ready
#define UART_ERR  0x02                    // RX Error
#define UART_BUSY 0x10                    // TX Busy

typedef struct {
   volatile uint32_t ucr;
   volatile uint32_t rxtx;
} uart2_t;

void uart2_init();
void uart2_putchar(char c);
void uart2_putstr(char *str);
char uart2_getchar();












/***************************************************************************
 * Pointer to actual components
 */
extern timer_t  *timer0;
extern uart_t   *uart0; 
extern uart1_t   *uart1;
extern uart2_t   *uart2;
extern gpio_t   *gpio0; 
extern uint32_t *sram0; 
#endif // SPIKEHW_H
