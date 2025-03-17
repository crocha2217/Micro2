/* for this homework you want to look into the ld manual
 * specifically look in section 3:
 * https://sourceware.org/binutils/docs/ld/Scripts.html
 */

/* set the output architecture to arm using OUTPUT_ARCH */

OUTPUT_ARCH(arm)
/* set the output format using OUTPUT_FORMAT */
OUTPUT_FORMAT(elf32-littlearm)
/* set the entry point to __reset using ENTRY */
ENTRY(__reset)
/* memories */
MEMORY {
	/* add the memory region for the bootloader */
	/* add memories for FLASH and SRAM */
	BOOTLOADER(rwx) :	ORIGIN = 0x20041f00, LENGTH = 256
	SRAM(rwx) :             ORIGIN = 0x20000000, LENGTH = 264K
	FLASH(rx) :             ORIGIN = 0x10000000, LENGTH = 2M
}

/* sections */
SECTIONS {
	/* add the bootloader section into BOOTLOADER memory */
	.bootloader : {
		/* there will be no references to symbols in this section outside of
		 * it, ensure the linker does not garbage collect us; use KEEP to have
		 * it keep everything it puts here */
		/* complete, add the contents of the bootloader ssection */
		
		KEEP(*(.bootloader))
		/* ensure that the end of the section is 256 byte aligned */
		. = ALIGN(256);
	} > BOOTLOADER AT> FLASH
	/* the above mirrors a copy in flash */

	/* provide the symbol __bl2_checksum to be at the end of the load address
	 * of the bootloader in the FLASH memory, minus 4 bytes; we need to use an
	 * external tool to put a checksum in here */
	__bl2_checksum = LOADADDR(.bootloader) + LENGTH(BOOTLOADER) - 4;

	/* add .vector_table section and its contents to FLASH */
	.vectors : {
		/* add contents of the vector table, ensure that linker garbage
		 * collection does not eat it away */
		KEEP(*(.vector_table))
	} > FLASH

	/* complete the .text section */
	.text : {
		/* add the contents of the .text section */
		*(.text)            
		*(.text.*)
		/* provide a hidden symbol to mark the end of the .text section */
		PROVIDE_HIDDEN(__text_end = .);
	} > FLASH
	/* above, put it in FLASH */
	
	.rodata : {
	
	/* add contents of .rodata section*/
	*(.rodata)
	*(.rodata.*)
	
	} > FLASH
	/* place .rodata in FLASH */

	/* complete the .data section */
	.data : {
		/* ensure the start is 4 byte (word) aligned */
		. = ALIGN(4);
		/* provide __data_start to point here */
		PROVIDE(__data_start = .);
		/* add the contents of the data section */
		*(.data)
		*(.data.*)

		/*ensure word alignment and provide a symbol for __data_end */
		PROVIDE(__data_end = .);
		. = ALIGN(4);
	} > SRAM AT > FLASH
	/* above, put it in SRAM, don't forget to mirror to FLASH */

	/* provide symbol for __data_load_start located at the address in
	 * FLASH where the initializataion data is found */
	
	PROVIDE(__data_load_start = LOADADDR(.data));
	
	/* add the .bss section with the required symbols; ensure alignment
	 * as well as placement in SRAM */
	.bss : {
		. = ALIGN(4);
	
		PROVIDE(__bss_start = .);
		*(.bss)
		*(.bss.*)
		
		PROVIDE(__bss_end = .);
		. = ALIGN(4);
		} > SRAM

	/* provide a symbol for __ram_end which points to the end of the SRAM
	 * memory */
	PROVIDE(__ram_end = .);
}
