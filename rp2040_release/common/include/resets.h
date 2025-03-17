#ifndef RESETS_H__
#define RESETS_H__

extern struct {
	volatile unsigned reset;
	volatile unsigned wdsel;
	volatile unsigned reset_done;
} RESETS;

/* RESETS */
#define RESETS_reset_io_bank0		(5)
#define RESETS_reset_done_io_bank0	(5)
#define RESETS_pll_sys			(12)
#define RESETS_uart0			(22)
#define RESETS_spi0			(16) 
#endif	/* RESETS_H__ */
