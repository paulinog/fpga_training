// ============================================================================
// DE1-SoC
// ============================================================================

module DE1_SOC_fsm_top(
      CLOCK_50,
      LEDR,
      KEY
);

//=======================================================
//  PORT declarations
//=======================================================
input                   CLOCK_50;
output         [3:0]    LEDR;
input          [3:0]    KEY;
//=======================================================
// Structural coding
//=======================================================

//reg [31:0] Counter;
//assign	LEDR = Counter[26:23];
//always@(posedge CLOCK_50 or negedge KEY[0])
//    begin
//        if(!KEY[0])
//            Counter <= 0;
//        else
//            Counter <= Counter + 1; 
//    end

//  LowPower_Sequencer u1 (
//                      .clk(CLOCK_50),
//                      .reset_n(KEY[0]),
//                      .onoff(KEY[1]),
//                      .lowpow(KEY[2]),
//                      .lowbat(KEY[3]),
//                      .v33(LEDR[0]),
//                      .v25(LEDR[1]),
//                      .v12(LEDR[2]),
//                      .Ready(LEDR[3])
//  );

Power_Sequencer u1 (
                   .clk(CLOCK_50),
                   .reset_n(KEY[0]),
                   .onoff(KEY[1]),
                   .v33(LEDR[0]),
                   .v25(LEDR[1]),
                   .v12(LEDR[2]),
                   .Ready(LEDR[3])
);

// mealy_mac u2
// (
// 	.clk(CLOCK_50), 
// 	.data_in(KEY[1]), 
// 	.reset(KEY[0]),
// 	.data_out(LEDR[5:4])
// );

endmodule
