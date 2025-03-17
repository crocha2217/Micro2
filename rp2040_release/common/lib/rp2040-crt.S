	.syntax unified	/* use unified ARM assembly syntax */
	.thumb			/* use thumb encodings only */
	.cpu cortex-m0plus	/* ensure we limit ourselves to the ARMv6-M ISA on the
						 * Cortex-M0+ core */

	.section .text.__reset	/* use subsection __reset in .text */
	.global __reset			/* make the symbol global */
	.type __reset, %function	/* make it into a function! */
__reset:
	/* load pointers required for .data initialization */
	ldr r0, =__data_start
	ldr r1, =__data_end
	ldr r2, =__data_load_start


.L_init_data:
1:
	cmp r0, r1
	beq 1f
	ldr r3, [r2]
	adds r2, #4 // increment r2 by 4 bytes
	str r3, [r0] //store value at r3 into address at r0
	adds r0, #4 // increment r0 by 4 bytes
	b 1b
1:
.L_init_bss_pointers:
	/* load pointers for .bss initialization */
	ldr r1, = __bss_start
	ldr r2, = __bss_end
	movs r0, #0

.L_init_bss:
1:
	/* loop to clear the section */
	cmp r1, r2
	beq 1f
	str r0, [r1] // store 0 into sram at address stored at r1
	adds r1, #4 // increment r1 by 4 bytes
	b 1b
.L_call_main:
1:
	bl main		/* call main */

	/* gracefully halt execution waiting for event */
1:	wfe
	b 1b		/* branch to first occurrence of label 1 going backwards */

	.size __reset, . - __reset	/* it's always a good idea to have the size
								 * of the symbol around; the . means current
								 * address at link time, let the linker do the
								 * math subtracting the addresses */

	.section .text.__bad_interrupt  /* use subsection __bad_interrupt in .text */
        .global __bad_interrupt         /* make the symbol global */
        .type __bad_interrupt, %function        /* make it into a function! */
__bad_interrupt:
	/* add globally visible symbol for __bad_interrupt and implement the
	 * function to be an idle loop that awaits for events */
	wfe
	b __bad_interrupt

	/* make symbols weak and alias them to __bad_interrupt; declaring another
	 * symbol with the same name will make the ``strong'' symbol be used
	 * instead */
	//.weak __vector_2
	//.set __vector_2, __bad_interrupt
	/* TODO: add all other vectors; hint: use .irp for core vectors and use a
	 * combination of .altmacro, .macro, and .rept for external vectors */

	.section .vectors, "a"

	.weak __vector_2
	.set __vector_2, __bad_interrupt

	.weak __vector_3
	.set __vector_3, __bad_interrupt

	.weak __vector_4
	.set __vector_4, __bad_interrupt

	.weak __vector_5
	.set __vector_5, __bad_interrupt

	.weak __vector_6
	.set __vector_6, __bad_interrupt

	.weak __vector_7
	.set __vector_7, __bad_interrupt

	.weak __vector_8
	.set __vector_8, __bad_interrupt

	.weak __vector_9
	.set __vector_9, __bad_interrupt

	.weak __vector_10
	.set __vector_10, __bad_interrupt

	.weak __vector_11
	.set __vector_11, __bad_interrupt

	.weak __vector_12
	.set __vector_12, __bad_interrupt

	.weak __vector_13
	.set __vector_13, __bad_interrupt

	.weak __vector_14
	.set __vector_14, __bad_interrupt

	.weak __vector_15
	.set __vector_15, __bad_interrupt

	.weak __vector_16
	.set __vector_16, __bad_interrupt

	.weak __vector_17
	.set __vector_17, __bad_interrupt

	.weak __vector_18
	.set __vector_18, __bad_interrupt

	.weak __vector_19
	.set __vector_19, __bad_interrupt

	.weak __vector_20
	.set __vector_20, __bad_interrupt

	.weak __vector_21
	.set __vector_21, __bad_interrupt

	.weak __vector_22
	.set __vector_22, __bad_interrupt

	.weak __vector_23
	.set __vector_23, __bad_interrupt

	.weak __vector_24
	.set __vector_24, __bad_interrupt

	.weak __vector_25
	.set __vector_25, __bad_interrupt

	.weak __vector_26
	.set __vector_26, __bad_interrupt

	.weak __vector_27
	.set __vector_27, __bad_interrupt

	.weak __vector_28
	.set __vector_28, __bad_interrupt

	.weak __vector_29
	.set __vector_29, __bad_interrupt

	.weak __vector_30
	.set __vector_30, __bad_interrupt

	.weak __vector_31
	.set __vector_31, __bad_interrupt

	.weak __vector_32
	.set __vector_32, __bad_interrupt

	.weak __vector_33
	.set __vector_33, __bad_interrupt

	.weak __vector_34
	.set __vector_34, __bad_interrupt

	.weak __vector_35
	.set __vector_35, __bad_interrupt

	.weak __vector_36
	.set __vector_36, __bad_interrupt

	.weak __vector_37
	.set __vector_37, __bad_interrupt

	.weak __vector_38
	.set __vector_38, __bad_interrupt

	.weak __vector_39
	.set __vector_39, __bad_interrupt

	.weak __vector_40
	.set __vector_40, __bad_interrupt

	.weak __vector_41
	.set __vector_41, __bad_interrupt

	.weak __vector_42
	.set __vector_42, __bad_interrupt

	.weak __vector_43
	.set __vector_43, __bad_interrupt

	.weak __vector_44
	.set __vector_44, __bad_interrupt

	.weak __vector_45
	.set __vector_45, __bad_interrupt

	.weak __vector_46
	.set __vector_46, __bad_interrupt

	.weak __vector_47
	.set __vector_47, __bad_interrupt
