#include <bitmanip.h>

#include <clocks.h>

#include <ioregs.h>

#include <resets.h>



/* the following assumes the extra credit from Homeworks 1 and 2 were done; if

 * not, then uncomment the function call in main() */

/* use the first user constructor to set up resets */

__attribute__((constructor(101)))

void do_unresets(void) {

	/* lift IO_BANK0 out of reset */

	RESETS.reset &= ~(1u << RESETS_reset_io_bank0);

	loop_until_bit_is_set(RESETS.reset_done, RESETS_reset_io_bank0);



	/* lift system PLL out of reset */

	RESETS.reset &= ~(1u << RESETS_pll_sys);

	loop_until_bit_is_set(RESETS.reset_done, RESETS_pll_sys);

}



int main(void) {

	/* uncomment the following if extra credit for the first two homeworks was

	 * not done */

	do_unresets();



	/* enable the oscillator */

	XOSC.ctrl = XOSC_enable | XOSC_freq_range_1_15MHz;

	loop_until_bit_is_set(XOSC.status, XOSC_stable);



	/* enable the system PLL (150 MHz) */

	PLL_SYS.cs = 1;		/* program the reference clock divider */

	PLL_SYS.fbdiv_int = 125;	/* then the feedback divider */

	PLL_SYS.pwr &= ~(

				(1u << PLL_pwr_pd)		/* turn on main power */

			|	(1u << PLL_pwr_vcopd));	/* and VCO */

	loop_until_bit_is_set(PLL_SYS.cs, PLL_lock);	/* wait for VCO lock */





	PLL_SYS.prim =						/* set up postdividers */

					(5 << PLL_postdiv1_offset)

				|	(2 << PLL_postdiv2_offset);

	PLL_SYS.pwr &= ~(1u << PLL_pwr_postdivpd);	/* turn the postdividers */



	/* enable CLK_GPOUT0 and set it to the system PLL */

	CLOCKS.clk_gpout0_ctrl =

					(1u << CLOCKS_enable)

				|	(CLOCKS_GPOUT_clksrc_pll_sys);



	/* and set GP21 to export that clock */

	IO_BANK0.io[21].ctrl = 8;



	return 0;

}
