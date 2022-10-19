// ======================================================
//                      VI SEnC 2022
// ======================================================

module DE2_115_fsm_top(

    //////// CLOCK //////////
    CLOCK_50,

    //////// LED //////////
    LEDG,
    LEDR,

    //////// KEY //////////
    KEY
);

//=======================================================
//  PARAMETER declarations
//=======================================================


//=======================================================
//  PORT declarations
//=======================================================

//////////// CLOCK //////////
input                    CLOCK_50;

//////////// LED //////////
output         [8:0]     LEDG;
output         [17:0]    LEDR;

//////////// KEY //////////
input          [3:0]     KEY;

/////////////////////////////////////////////////////////
//=======================================================
// REG/WIRE declarations
//=======================================================


//=======================================================
// Structural coding
//=======================================================

assign	LEDG        =    9'bz;
assign	LEDR[17:2]  =    16'bz;

// mealy_mac u2
// (
// 	.clk(CLOCK_50), 
// 	.data_in(KEY[1]), 
// 	.reset(KEY[0]),
// 	.data_out(LEDR[1:0])
// );

endmodule
