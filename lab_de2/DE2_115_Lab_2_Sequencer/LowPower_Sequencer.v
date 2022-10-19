// ======================================================
//                      VI SEnC 2022
// ======================================================

module LowPower_Sequencer(
    input clk, reset_n, onoff, lowpow, lowbat,
    output reg v33, v25, v12, Ready
);
//=======================================================
//  PARAMETER declarations
//=======================================================
parameter off_state = 0, on_state = 1, lp = 2, lb = 3, 
          power_up = 4, power_down = 5, low_power = 6;
//=======================================================
// REG/WIRE declarations
//=======================================================
reg [2:0] state;

reg       rst_count;
reg       incr_count;
reg [4:0] counter;
reg [4:0] counter_next;

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
                if (onoff == 1 &&
                    lowbat == 0 &&
                    lowpow == 0)
                begin
                    // turn on
                    state <= power_up;
                end 
                else
                begin
                    if (onoff == 1 &&
                        lowbat == 0 &&
                        lowpow == 1)
                    begin
                        //turn on in low power mode
                        state <= low_power;
                    end
                    else
                    begin
                        state <= off_state;
                    end
                end

                power_up:
                begin
                    if(counter > 10)
                    begin
                        //wait t1 + t1 = 5+6
                        state <= on_state;
                    end
                end
                    
                power_down:
                begin
                    if (counter > 10)
                    begin
                        // wait t3 + t4 +t5 = 5+3+3
                        if (onoff == 1 &&
                                lowbat ==1)
                        begin
                            state <= lb;
                        end
                        else
                        begin
                            state <= off_state;
                        end
                    end
                end
                    
                low_power:
                begin
                    if(counter > 10)
                    begin
                        //wait t3+t4+t5 = 5+3+3
                        state <= lp;
                    end
                end
                    
            on_state:
            begin
                if (onoff == 1 &&
                    lowbat == 0 &&
                    lowpow == 0)
                begin
                    state <= on_state;
                end
                else if (onoff == 1 &&
                        lowbat == 0 &&
                        lowpow == 1)
                begin
                    state <= low_power;
                end
                else if (onoff == 1 &&
                        lowbat == 1)
                begin
                    //low battery
                    state <= power_down;
                end
                else if (onoff == 0)
                begin
                    //turn off
                    state <= power_down;
                end
            end
                
            lp:
            begin
                if (onoff == 1 &&
                    lowbat == 0 &&
                    lowpow == 0)
                begin
                    state <= on_state;
                end
                else if (onoff == 1 &&
                        lowbat == 0 &&
                        lowpow == 1)
                begin
                    state <= lp;
                end
                else if (onoff == 1 &&
                        lowbat == 1)
                begin
                    //low battery
                    state <= power_down;
                end
                else if (onoff == 0)
                begin
                    //turn off
                    state <= power_down;
                end
            end
                
            lb:
            begin
                if (onoff == 1 &&
                    lowbat == 0 &&
                    lowpow == 0)
                begin
                    //turn on
                    state <= power_up;
                end
                else if (onoff == 1 &&
                        lowbat == 0 &&
                        lowpow == 1)
                begin
                    //low power mode
                    state <= low_power;
                end
                else if (onoff == 1 &&
                        lowbat == 1)
                begin
                    //low battery
                    state <= lb;
                end
                else if (onoff == 0)
                begin
                    //turn off
                    state <= off_state;
                end
            end
        endcase
	end
end


always @ (state or onoff or lowpow or lowbat) begin
    
    incr_count <= 0;
    rst_count <= 0;

    v12 <= 0;
    v25 <= 0;
    v33 <= 0;
    Ready <= 0;

    case (state)
        off_state:
            if (onoff == 1 &&
                lowbat == 0 &&
                lowpow == 0)
            begin
                // turn on
                rst_count <= 0;
            end 
            else
            begin
                if (onoff == 1 &&
                    lowbat == 0 &&
                    lowpow == 1)
                begin
                    //turn on in low power mode
                    rst_count <= 1;
                end
            end

			power_up:
			begin
				incr_count <= 1;
				v33 <= 1;

				if (counter > 4)
				begin
					 //wait t1=5
					 v25 <= 1;
				end

				if(counter > 10)
				begin
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

				if (counter > 4)
				begin
					 // wait t3 = 5
					  v12 <= 0; 
					  Ready <= 0;
				end

				if (counter > 7)
				begin
					 // wait t3 + t4 = 5+3
					  v25 <= 0;
				end

				if (counter > 10)
				begin
					 // wait t3 + t4 +t5 = 5+3+3
					  v33 <= 0;
				end
			end
				
			low_power:
			begin
				incr_count <= 1;
				v12 <= 1;
				v25 <= 1;
				v33 <= 1;
				Ready <= 0;

				if (counter > 7)
				begin
					 //wait t3+t4 = 5+3
					 v25 <= 0;
				end

				if(counter > 10)
				begin
					 //wait t3+t4+t5 = 5+3+3
					 v33 <= 0;
					 Ready <= 1;
				end
			end
				
        on_state:
		  begin
            v12 <= 1;
            v25 <= 1;
            v33 <= 1;
            Ready <= 1;

            if (onoff == 1 &&
                     lowbat == 0 &&
                     lowpow == 1)
            begin
                rst_count <= 1;
            end
            else if (onoff == 1 &&
                     lowbat == 1)
            begin
                //low battery
                rst_count <= 1;
            end
            else if (onoff == 0)
            begin
                //turn off
                rst_count <= 1;
            end
			end
			
			lp:
			begin
            v12 <= 1;
            v25 <= 0;
            v33 <= 0;
            Ready <= 1;

            if (onoff == 1 &&
                     lowbat == 1)
            begin
                //low battery
                rst_count <= 1;
            end
            else if (onoff == 0)
            begin
                //turn off
                rst_count <= 1;
            end
			end
			
			lb:
			begin
            v12 <= 0;
            v25 <= 0;
            v33 <= 0;
            Ready <= 0;

            if (onoff == 1 &&
                lowbat == 0 &&
                lowpow == 0)
            begin
                //turn on
                rst_count <= 1;
            end
            else if (onoff == 1 &&
                     lowbat == 0 &&
                     lowpow == 1)
            begin
                //low power mode
                rst_count <= 1;
            end
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
