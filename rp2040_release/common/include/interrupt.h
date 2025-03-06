#ifndef INTERRUPT_H__
#define INTERRUPT_H__

#define ISR_(x)	\
		void __vector_ ## x (void); \
		void __vector_ ## x (void)
#define ISR(x) ISR_(x)

#define SPI0_vect	34
#define SPI1_vect	35
#define UART0_vect	36
#define UART1_vect	37

#define NVIC_BIT(x)	((x) - (16))

extern volatile unsigned NVIC_ISER;
extern volatile unsigned NVIC_ICER;
extern volatile unsigned NVIC_ISPR;
extern volatile unsigned NVIC_ICPR;
extern volatile unsigned NVIC_IPR[8];

#endif
