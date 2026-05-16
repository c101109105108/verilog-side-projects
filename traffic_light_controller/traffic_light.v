module traffic_light(
input clk,
input button_1,
input button_2,
output reg red_led,
output reg yellow_led,
output reg green_led
);

reg [1:0] sync_button_1;
reg [1:0] sync_button_2;

reg [15:0] debounce_button_1 = 16'hF000;
reg [15:0] debounce_button_2 = 16'hF000;

always @(posedge clk) begin

sync_button_1 <= {sync_button_1[0], button_1};
sync_button_2 <= {sync_button_2[0], button_2};

debounce_button_1 <= {debounce_button_1[14:0], sync_button_1[1]};
debounce_button_2 <= {debounce_button_2[14:0], sync_button_2[1]};

end // always @(posedge clk) begin

wire on_off_button = (debounce_button_1 == 16'hF000);
wire next_button = (debounce_button_2 == 16'hF000);

parameter state_idle = 0;
parameter state_red = 1;
parameter state_red_yellow = 2;
parameter state_green = 3;
parameter state_green_yellow = 4;

reg [2:0] current_state = state_idle;
reg [31:0] counter = 0;
reg timer_active = 0;

parameter clock_cycle = 27000000;
parameter red_clock_cycle = clock_cycle * 12;
parameter green_clock_cycle = clock_cycle * 12;
parameter yellow_clock_cycle = clock_cycle / 3;

always @(posedge clk) begin

    if (on_off_button) begin    

        if (timer_active) begin
        current_state <= state_idle;
        counter <= 0;
        timer_active <= 0;
        red_led <= 0;
        yellow_led <= 0;
        green_led <= 0;
        end // if (timer_active) begin

    else begin 
        current_state <= state_red;
        counter <= 0;
        timer_active <= 1;
        red_led <= 1;
        yellow_led <= 0;
        green_led <= 0;
        end //  else begin 
        end // if (on_off_button) begin

    else if (current_state == state_red && next_button) begin
        counter <= 0;
        timer_active <= 1;
        red_led <= 0;
        yellow_led <= 0;
        green_led <= 1;
        current_state <= state_green;
        end // else if (current_state == state_red && next_button) begin    
    
    else if (current_state == state_green && next_button) begin
        counter <= 0;
        timer_active <= 1;
        red_led <= 1;
        yellow_led <= 0;
        green_led <= 0;
        current_state <= state_red;
        end // else if (current_state == state_green && next_button) begin

        else if (timer_active) begin

        case (current_state)
            
            state_red: begin    
            red_led <= 1;
            yellow_led <= 0;
            green_led <= 0;

                if (counter == red_clock_cycle - 1) begin
    
                    counter <= 0;
                    current_state <= state_red_yellow;
                    end // if (clock_cycle == red_clock_cycle -1 )
                    else begin
                    counter <= counter + 1;
                    end // else begin
                    end // state_red: begin  
                
            state_red_yellow: begin 
            red_led <= 1;
            yellow_led <= 1;
            green_led <= 0;

                if (counter == yellow_clock_cycle - 1) begin

                    counter <= 0;
                    current_state <= state_green;
                    end // if (clock_cycle == yellow_clock_cycle - 1)
                    else begin 
                    counter <= counter + 1;
                    end // else begin 
                    end // state_red_yellow: begin 

            state_green: begin
            red_led <= 0;
            yellow_led <= 0;
            green_led <=1;
                
                if (counter == green_clock_cycle - 1) begin
                    
                    counter <= 0;
                    current_state <= state_green_yellow;
                    end // if (clock_cycle == green_clock_cycle - 1)
                    else begin
                    counter <= counter + 1;
                    end // else begin
                    end // state_green: begin

            state_green_yellow: begin   
            red_led <= 0;
            yellow_led <= 1;
            green_led <= 1;
            
                if (counter == yellow_clock_cycle - 1) begin

                counter <= 0;
                current_state <= state_red;
                end // if (clock_cycle == yellow_clock_cycle - 1)
                else begin
                counter <= counter + 1;
                end // else begin   
                end // state_green_yellow: begin 
                endcase // case (current_state)
    end // else if (timer_active) begin
    end // always @(posedge clk) begin
endmodule // module traffic_light
