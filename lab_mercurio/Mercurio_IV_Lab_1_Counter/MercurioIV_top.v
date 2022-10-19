// ======================================================
//                      VI SEnC 2022
// ======================================================

module MercurioIV_top(
    CLOCK_50MHz,
    LEDM_C,
    LEDM_R,
    KEY
);

input                    CLOCK_50MHz;
output         [4:0]     LEDM_C;
output         [7:0]     LEDM_R;
input          [11:0]     KEY;

wire [2:0] nLEDM_R;

assign	LEDM_C[0]     =    1'b1;
assign	LEDM_C[4:1]   =    4'b0000;
assign	LEDM_R[7:3]   =    5'b11111;
assign  LEDM_R[2:0]   =    ~nLEDM_R[2:0];

LED_Controller u0 (
                    .CLK_IN(CLOCK_50MHz),
                    .RESET_N(~KEY[0]),
                    .LED_OUT(nLEDM_R[2:0])
);

endmodule
