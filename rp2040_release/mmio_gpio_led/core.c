#include <ioregs.h>
#include <bitmanip.h>
#include <resets.h>
#include <uart.h>
#include <clocks.h>

//seting peripgeral to 125mhz and baud rate to 115200
#define F_PERIPH 125000000  // 125 MHz peripheral clock
#define BAUD     115200     // 115200 baud rate
#include <uart-baud.h>
//Pins I chose for MAX7219
#define SPI_SCK_PIN     6   // GPIO6 for SPI0 SCK
#define SPI_TX_PIN      7   // GPIO7 for SPI0 TX Data In
#define SPI_CS_PIN      5   // GPIO5 for SPI0 CS

/* RESETS */
#define RESETS_reset_io_bank0		(5)
#define RESETS_reset_done_io_bank0	(5)
#define RESETS_uart0			(22)
#define RESETS_spi0			(16)
/* RESETS_H__ */

struct {
        volatile unsigned ctrl;
        volatile unsigned status;
        volatile unsigned dormant;
        volatile unsigned startup;
        volatile unsigned count;
} XOSC;


int main(void) {
	/* enable the oscillator */
	XOSC.ctrl = XOSC_enable | XOSC_freq_range_1_15MHz;
	loop_until_bit_is_set(XOSC.status, XOSC_stable);

	// Once the XOSC is stable, set the peripheral clock source to the XOSC and enable the clock(same time)
    CLOCKS.clk_peri_ctrl = CLOCKS_PERI_xosc_clksrc | (1u << CLOCKS_enable);

	/* we first must take out IO_BANK0 out of reset mode */ //Take Uart out of reset mode as well same way at same time
	RESETS.reset &= ~((1u << RESETS_reset_io_bank0) | (1u << RESETS_uart0) | (1u << RESETS_spi0));	/* deassert reset bit */
	/* wait until the reset is done for both uart amd ioBank*/
	loop_until_bit_is_set(RESETS.reset_done, RESETS_reset_done_io_bank0);
	loop_until_bit_is_set(RESETS.reset_done, RESETS_uart0);
	loop_until_bit_is_set(RESETS.reset_done, RESETS_spi0);


	// Configure GPIO0 (TX) and GPIO1 (RX) for UART0 function
    /* Function 2 (F2) is UART0 TX for GPIO0 and UART0 RX for GPIO1 according to datasheet */
    IO_BANK0.io[0].ctrl = 2;  // UART0 TX on GPIO0
    IO_BANK0.io[1].ctrl = 2;  // UART0 RX on GPIO1
	/* set GPIO25 (LED_PIN) to use the SIO function */
	IO_BANK0.io[LED_PIN].ctrl = 5;			/* SIO driver for IO[LED_PIN] */
	//outputs for MAX7219
	IO_BANK0.io[SPI_SCK_PIN].ctrl = 1;  // Function 1 (SPI0 SCK)
    IO_BANK0.io[SPI_TX_PIN].ctrl = 1;   // Function 1 (SPI0 TX)
    IO_BANK0.io[SPI_CS_PIN].ctrl = 1;   // Function 1 (SPI0 CS)
	 // Set baud rate based on calc in uart-baud
	UART0.uartibrd = UARTIBRD_VALUE;  // Integer part of baud rate divisor
	UART0.uartfbrd = UARTFBRD_VALUE;  // Fractional part of baud rate divisor

	// Configure for 8 data bits
	UART0.uartlcr_h = (UART_WLEN_8 << UART_LCR_H_WLEN_OFFSET) | (1u << UART_LCR_H_FEN);
	// Enable UART, transmitter, and receiver data sheet page 433
	UART0.uartcr = (1u << UART_CR_UARTEN) | (1u << UART_CR_TXE) | (1u << UART_CR_RXE);
	// Enable interrupt datasheet 435
	UART0.uartimsc = (1u << UART_IMSC_RXIM) | (1u << UART_IMSC_TXIM);

	 /* and now we can set the pin to output */
	SIO.gpio_oe_set = (1u << LED_PIN);		/* set the pin as output */
	SIO.gpio_out_set = (1u << LED_PIN);		/* and set it high */

	// Activate chip select (CS)
    SIO.gpio_out_clr = (1u << SPI_CS_PIN);

	return 0;
}
