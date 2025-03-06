/* for this homework you want to look into the ld manual
 * specifically look in section 3:
 * https://sourceware.org/binutils/docs/ld/Scripts.html
 */

/* TODO: set the output architecture to arm using OUTPUT_ARCH */
OUTPUT_ARCH(arm)
/* TODO: set the output format using OUTPUT_FORMAT */
OUTPUT_FORMAT(elf32-littlearm)
/* TODO: set the entry point to __reset using ENTRY */
ENTRY(__reset)
/* memories */
MEMORY {
	/* add the memory region for the bootloader */
	/* TODO: complete */
	BOOTLOADER(rwx) :	ORIGIN = 0x20041f00, LENGTH = 256B
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

		/* TODO: complete, add the contents of the bootloader ssection */
		KEEP(*(.bootloader*))
		/* ensure that the end of the section is 256 byte aligned */
		. = ALIGN(256);
	} > FLASH
	/* the above mirrors a copy in flash */
	/* provide the symbol __bl2_checksum to be at the end of the load address
	 * of the bootloader in the FLASH memory, minus 4 bytes; we need to use an
	 * external tool to put a checksum in here */
	__bl2_checksum = LOADADDR(.bootloader) + LENGTH(BOOTLOADER) - 4;

	/* TODO: add .vector_table section and its contents to FLASH */
	.vectors : {
		/* TODO: add contents of the vector table, ensure that linker garbage
		 * collection does not eat it away */
		KEEP(*(.vector_table))
		
	} > FLASH

	/* TODO: complete the .text section */
	.text : {
		/* TODO: add the contents of the .text section */
		*(.text)
		*(.text*)
		/* provide a hidden symbol to mark the end of the .text section */
		PROVIDE_HIDDEN(__text_end = .);
	} > FLASH 
	/* TODO: above, put it in FLASH */

	/* TODO: place .rodata in FLASH */
	.rodata : {
		*(.rodata)
		*(.rodata*) /* Readonly section */
    } > FLASH
	/* TODO: complete the .data section */
	.data : {
		/* ensure the start is 4 byte (word) aligned */
		. = ALIGN(4);
		/* TODO: provide __data_start to point here */
		PROVIDE(__data_start = .);
		/* TODO: add the contents of the data section */
		*(.data)		
		*(.data*)
		. = ALIGN(4);		
		/* TODO: ensure word alignment and provide a symbol for __data_end */
		PROVIDE(__data_end = .);
	} > SRAM AT > FLASH
	/* TODO: above, put it in SRAM, don't forget to mirror to FLASH */

	/* TODO: provide symbol for __data_load_start located at the address in
	 * FLASH where the initializataion data is found */
	PROVIDE(__data_load_start = LOADADDR(.data));
	/* TODO: add the .bss section with the required symbols; ensure alignment
	 * as well as placement in SRAM */
	.bss :
{
    PROVIDE(__bss_start = .);
    *(.bss)
    *(.bss.*)
    . = ALIGN(4);
    PROVIDE(__bss_end = .);
    . = ALIGN(4);
} > SRAM

.ctors : {
    PROVIDE(__ctors_start = .);
    KEEP(*(.ctors))
    KEEP(*(.ctors.*))
    PROVIDE(__ctors_end = .);
} > FLASH
.dtors :
{
    PROVIDE(__dtors_start = .);
    KEEP(*(.dtors))
    KEEP(*(.dtors.*))
    PROVIDE(__dtors_end = .);
} > SRAM

/* TODO: provide a symbol for __ram_end which points to the end of the SRAM memory */
PROVIDE(__ram_end = ORIGIN(SRAM) + LENGTH(SRAM));
}
