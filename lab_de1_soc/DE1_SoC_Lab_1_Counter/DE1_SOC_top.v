// ============================================================================
// DE1-SoC
// ============================================================================

module DE1_SOC_top(
    CLOCK_50,
    LEDR,
    KEY_0
);

input                   CLOCK_50;
output         [2:0]    LEDR;
input                   KEY_0;

LED_Controller u0 (
                    .CLK_IN(CLOCK_50),
                    .RESET_N(KEY_0),
                    .LED_OUT(LEDR[2:0])
);

endmodule
