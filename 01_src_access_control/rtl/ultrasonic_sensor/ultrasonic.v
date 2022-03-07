/*module ultrasonic(clk,reset,ping,distance
	);

	input clk,reset;
	inout ping;
	output [19:0] distance;

	reg [19:0] distance;
	reg [19:0] distance_counter = 0;
	reg [25:0] counter = 0;
	reg ping_old;
	reg in = 0;
	reg out = 0;
	reg pingout = 0;
	
	wire pingin;

	assign ping = (out)? pingout:1'bz;
	assign pingin = (in)? ping:1'bz;


always @ (posedge clk)
begin
	if (reset) begin
		counter <= 0;
		distance <= 0;
	end

	if (counter <= 500) begin
		in <= 0;
		out <= 1;
		pingout <= 1;
	end

	if (counter >= 38_000) begin
		if (pingin) begin 
			distance_counter <= distance_counter + 1;
			in <= 1;
			out <= 0;
		end
	end

	if (counter >= 925_000 || counter == 501) begin
		in <= 0;
		out <= 0;
		pingout <= 0;
	end

	if (counter >= 50_000_000) begin
		counter <= 0;
	end

	if (~ping & ping_old) begin
		distance <= distance_counter;
		distance_counter <= 0;
	end
	
	ping_old <= ping;
end

endmodule

*/

module ultrasonic(clk,reset,pulse,distance
	);

	input clk;
	input reset;
	input ping;
	output pulse;
	output distance;
	

	reg counter;
	reg pulse_init;
	reg ping_in;
	reg ping_init;
	
	



always @ (posedge clk)
begin

	counter <= counter + 1;


	if (reset) begin
		counter  <= 0;
	end

	if (counter < 250) begin
		pulse_init <= 0;
		ping_in <= 0;
	end

	if (counter >= 250) begin
		pulse_init <= 1;
		ping_in <= 0;
	end

	if (counter > 750) begin
		pulse_init <= 0;
		ping_in <= 1;
	end

	if (counter > 150000) begin
		ping_in <= 0;
	end

	if (counter == 50000000) begin
		counter <= 0;
	end

	if (ping_init == 1 && ping_in == 1 ) begin
		ping_counter <= ping_counter + 1;
	end
	
end

always @ ( posedge ping) begin
	
	ping_init <= 1;

end

always @ ( negedge ping) begin
	
	ping_init <= 0;

end


