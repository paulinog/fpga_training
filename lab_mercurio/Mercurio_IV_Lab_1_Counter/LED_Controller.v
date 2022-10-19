// ======================================================
//                      VI SEnC 2022
// ======================================================

module LED_Controller(
    CLK_IN,
    RESET_N,
    LED_OUT
);

input                    CLK_IN;
input                    RESET_N;
output         [2:0]     LED_OUT;

reg [31:0] Counter;

assign	LED_OUT = Counter[25:23];

always@(posedge CLK_IN or negedge RESET_N)
    begin
        if(!RESET_N)
            Counter <= 0;
        else
            Counter <= Counter + 1; 
    end

endmodule
