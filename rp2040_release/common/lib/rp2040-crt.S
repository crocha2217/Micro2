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

	/* TODO: add loop to copy data into RAM */
copy_data:
	cmp r0, r1
	beq end_loop	//end loopif r0 eq r1
	//ldr r3, [r2], #4 actually not suppored for v6 //load into r3 from [r2], [] means the memory address #4 is increment because each word is 4 bytes 
	ldr r3, [r2]  //load  memory addreass from r2 into r3
        adds r2, #4	//is a way to increment by 4bytes for ArmV6
        str r3, [r0] //store value at r3 into mem address at r0
        adds r0, #4		//increment 4bytes to get to next word
        b copy_data	//loop
/* TODO: load pointers for .bss initialization */
end_loop:
    	ldr r0, =__bss_start  //load r0 as bss start
    	ldr r1, =__bss_end    //load r1 as __bss end
   /* TODO: add loop to clear the section */
clear_bss:
    	cmp r0, r1		//the check to see if r0 = r1
    	beq call_main	//go back to main
    	movs r3, #0		//Load immediate 0 into r3 //help from class partner mike smith
    	str r3, [r0]	// Store 0 into mem address at r0
    	adds r0, #4		//Move to next word supported by V6 :)
    	b clear_bss		//loop

ctors_extcredit: //the constructors
	ldr r0, =__ctors_start  // Start of .ctors section
        ldr r1, =__ctors_end    // End of .ctors section
ctor_loop:
        cmp r0, r1              // same cmp as other loops
        beq call_main

        ldr r2, [r0]            // Load function pointer
        adds r0, #4             // Move to next function pointer
        cmp r2, #0              // Check if function pointer isnothing
        beq ctor_loop           // Skip if so

        blx r2                  // Bl is to call constructor

        b ctor_loop             // Repeat until all constructors are called

call_main:
	bl main		// call main

dtors_attempt:		//Call destructors after main
        ldr r0, =__dtors_start
        ldr r1, =__dtors_end

dtor_loop:
        cmp r0, r1		//same comarison for loops
        beq exit			// wfe exit
        ldr r2, [r0]		//load pointer for dtor
        adds r0, #4
        cmp r2, #0		//if empty
        beq dtor_loop
        blx r2			//call for r2  dtor
        b dtor_loop

exit:	/* gracefully halt execution waiting for event */
1:	wfe
	b 1b		/* branch to first occurrence of label 1 going backwards */

	.size __reset, . - __reset	/* it's always a good idea to have the size
								 * of the symbol around; the . means current
								 * address at link time, let the linker do the
								 * math subtracting the addresses */


	/* TODO: add globally visible symbol for __bad_interrupt and implement the
	 * function to be an idle loop that awaits for events */
	.section .text.__bad_interrupt
        .global __bad_interrupt
        .type __bad_interrupt, %function	//global symbol and function
__bad_interrupt:
	wfe		//wait for event
	b __bad_interrupt		//loop back 
	/* make symbols weak and alias them to __bad_interrupt; declaring another
	 * symbol with the same name will make the ``strong'' symbol be used
	 * instead */
		//using .macro and .irp cause lazy(from slack) and https://stackoverflow.com/questions/44736820/x86-assembly-macro-for-invoking-a-function-with-arguments and chatgbt and https://users.cs.fiu.edu/~downeyt/cop3402/rept.html#irp_macro

        .section .vectors, "a"

	.section .vectors, "a"

.weak __vector_0
.set __vector_0, __bad_interrupt
.weak __vector_1
.set __vector_1, __bad_interrupt
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
        
        //.set __vector_\n, __bad_interrupt
        

//        .rept 47   // the 47 vectors for vector table
//	WEAK_VECTOR (1 + \@)
  //      .endr
	/* TODO: add all other vectors; hint: use .irp for core vectors and use a
	 * combination of .altmacro, .macro, and .rept for external vectors */

