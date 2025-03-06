#include "clocks.h"

// Function to turn on xosc
void xosc_init(void) {
    // Set the control register for the XOSC to enable it and select the frequency range (1-15 MHz) at same time
    xosc_hw->ctrl = XOSC_enable | XOSC_CTRL_FREQ_RANGE_VALUE_1_15MHZ;

    // Set the startup time for the XOSC, 0xc4 for delay
    xosc_hw->startup = 0xC4;

    // Wait until the XOSC stabilizes by checking the status register
    while (!(xosc_hw->status & (1u << XOSC_stable))) {
        tight_loop_contents();  // spin lock keeping it busy
    }

    // Once the XOSC is stable, set the peripheral clock source to the XOSC and enable the clock(same time)
    CLOCKS.clk_peri_ctrl = CLOCKS_PERI_xosc_clksrc | (1u << CLOCKS_enable);
}

// Main function
int main() {
    init_xosc();  // Call the xosc_init function to initialize and start the XOSC

}
