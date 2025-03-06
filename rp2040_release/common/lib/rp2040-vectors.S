
	.section .vector_table
__vector_table:
	/* Section B1.5.2 of the ARMv6-M Architecture Reference Manual */
	.word	__ram_end	/* TODO: symbol for the end of RAM */ /* loaded into msp by the bootloader */
	.word	__reset		/* reset vector */
	.word	__vector_2	/* Non-Maskable Interrupt */
	.word	__vector_3	/* TODO: core vector 3, HardFault */
	/* from 3 to 10: vectors are reserved, point to __bad_interrupt */
	.word __bad_interrupt		//rept repeats the code <count> times
	.word __bad_interrupt		//next 7 are reserved for bad interupt
	.word __bad_interrupt
.word __bad_interrupt
.word __bad_interrupt
.word __bad_interrupt
.word __bad_interrupt
.word __vector_12	/* TODO: core vector 12, SVCall */
		/* TODO: fill in missing 13 to 15 */
	.word __bad_interrupt
	.word __bad_interrupt
	.word __bad_interrupt
	/* TODO: add external vectors 16 to 47 */
.word __vector_16
.word __vector_17
.word __vector_18
.word __vector_19
.word __vector_20
.word __vector_21
.word __vector_22
.word __vector_23
.word __vector_24
.word __vector_25
.word __vector_26
.word __vector_27
.word __vector_28
.word __vector_29
.word __vector_30
.word __vector_31
.word __vector_32
.word __vector_33
.word __vector_34
.word __vector_35
.word __vector_36
.word __vector_37
.word __vector_38
.word __vector_39
.word __vector_40
.word __vector_41
.word __vector_42
.word __vector_43
.word __vector_44
.word __vector_45
.word __vector_46
.word __vector_47
