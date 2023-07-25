// ======================================================
//                      VI SEnC 2022
// ======================================================

module Power_Sequencer(
    input clk, reset_n, onoff,
    output reg v33, v25, v12, Ready
);
//=======================================================
//  PARAMETER declarations
//=======================================================
parameter   off_state = 0, 
            on_state = 1, 
            power_up = 2, 
            power_down = 3; 
//=======================================================
// REG/WIRE declarations
//=======================================================
reg [1:0] state;

reg       rst_count;
reg       incr_count;
reg [32:0] counter;
reg [32:0] counter_next;

//=======================================================
// Structural coding
//=======================================================

always @ (posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= off_state;
        counter <= 0;
    end
    else
    begin
        counter <= counter_next;

        case (state)
            off_state:
                if (onoff == 1) begin
                    // turn on
                    state <= power_up;
                end 
                else begin
                    state <= off_state;
                end

            power_up:
                if(counter > 50000000) begin
                    //wait t1 + t1 = 5+6
                    state <= on_state;
                end
					 else begin
						  state <= power_up;
					 end
                    
            power_down:
                if (counter > 50000000) begin
                    // wait t3 + t4 +t5 = 5+3+3
                    state <= off_state;
                end
					 else begin
						  state <= power_down;
					 end
                    
            on_state:
                if (onoff == 1) begin
                    state <= on_state;
                end
                else begin
                    //turn off
                    state <= power_down;
                end
        endcase
	end
end


always @ (state or onoff) begin
    
    incr_count <= 0;
    rst_count <= 0;

    v12 <= 0;
    v25 <= 0;
    v33 <= 0;
    Ready <= 0;

    case (state)
        off_state:
            if (onoff == 1) begin
                // turn on
                rst_count <= 0;
            end 

		power_up:
			begin
				incr_count <= 1;
				v33 <= 1;

				if (counter > 20000000) begin
                    //wait t1=5
                    v25 <= 1;
				end

				if(counter > 50000000) begin
                    //wait t1 + t1 = 5+6
                    v12 <= 1;
                    Ready <= 1;
				end
			end
				
		power_down:
			begin
				incr_count <= 1;
				v12 <= 1;
				v25 <= 1;
				v33 <= 1;
				Ready <= 1;

				if (counter > 4) begin
                    // wait t3 = 5
                    v12 <= 0; 
                    Ready <= 0;
				end

				if (counter > 35000000) begin
					 // wait t3 + t4 = 5+3
					  v25 <= 0;
				end

				if (counter > 50000000) begin
					 // wait t3 + t4 +t5 = 5+3+3
					  v33 <= 0;
				end
			end
				
        on_state:
		    begin
                v12 <= 1;
                v25 <= 1;
                v33 <= 1;
                Ready <= 1;

                rst_count <= 1;
			end
    endcase
end

always @ (rst_count, incr_count, counter)
    begin
        counter_next <= counter;
        if (rst_count == 1)
            counter_next <= 0;
        else
            if (incr_count == 1)
                counter_next <= counter + 1;
    end

endmodule
