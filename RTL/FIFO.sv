////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_Interface.DUT FIFO_if);

localparam max_fifo_addr = $clog2(FIFO_if.FIFO_DEPTH);

reg [FIFO_if.FIFO_WIDTH-1:0] mem [FIFO_if.FIFO_DEPTH-1:0];

reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		wr_ptr <= 0;
		FIFO_if.wr_ack <=0;
	end
	else if (FIFO_if.wr_en && count < FIFO_if.FIFO_DEPTH) begin
		mem[wr_ptr] <= FIFO_if.data_in;
		FIFO_if.wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
	end
	else begin 
		FIFO_if.wr_ack <= 0; 
		if (FIFO_if.full & FIFO_if.wr_en)
			FIFO_if.overflow <= 1;
		else
			FIFO_if.overflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		rd_ptr <= 0;
	end
	else if (FIFO_if.rd_en && count != 0) begin
		FIFO_if.data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
	end
	else begin
		if(FIFO_if.rd_en && FIFO_if.empty )
		 FIFO_if.underflow <= 1;
		 else
		 FIFO_if.underflow <= 0;
	end
end

always @(posedge FIFO_if.clk or negedge FIFO_if.rst_n) begin
	if (!FIFO_if.rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b10) && !FIFO_if.full) 
			count <= count + 1;
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b01) && !FIFO_if.empty)
			count <= count - 1;
		else 	if	( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.empty) begin
			count <= count + 1;
		end 
		else if ( ({FIFO_if.wr_en, FIFO_if.rd_en} == 2'b11) && FIFO_if.full)
			count <= count - 1;
	end
end

assign FIFO_if.full = (count == FIFO_if.FIFO_DEPTH)? 1 : 0;
assign FIFO_if.empty = (count == 0)? 1 : 0;
//assign FIFO_if.underflow = (FIFO_if.empty && FIFO_if.rd_en)? 1 : 0;  // this is seq output not comb
assign FIFO_if.almostfull = (count == FIFO_if.FIFO_DEPTH-1)? 1 : 0;    // should be  FIFO_if.FIFO_DEPTH-1 not FIFO_if.FIFO_DEPTH-2
assign FIFO_if.almostempty = (count == 1)? 1 : 0;

`ifdef SIM

property wr_ack_p;
	@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full && !FIFO_if.rd_en) |=> 
																							FIFO_if.wr_ack ;
endproperty

wr_ack_a:assert property (wr_ack_p);
wr_ack_c:cover property (wr_ack_p);

property overflow_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.full) |=> FIFO_if.overflow;
endproperty

overflow_a:assert property (overflow_p);
overflow_c:cover property (overflow_p);

property underflow_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && FIFO_if.empty) |=> FIFO_if.underflow;
endproperty

underflow_a:assert property (underflow_p);
underflow_c:cover property (underflow_p);


property wr_ptr_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && !FIFO_if.full) |=> 
													(wr_ptr == $past(wr_ptr)+1'b1);
endproperty

wr_ptr_a:assert property(wr_ptr_p);
wr_ptr_c:cover property(wr_ptr_p);


property rd_ptr_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.rd_en && !FIFO_if.empty) |=> 
															(rd_ptr == $past(rd_ptr)+1'b1);
endproperty

rd_ptr_a:assert property(rd_ptr_p);
rd_ptr_c:cover property(rd_ptr_p);


property count_inc_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en   && !FIFO_if.rd_en && !FIFO_if.full) |=> 
															(count == $past(count)+1'b1);
endproperty

count_inc_a:assert property(count_inc_p);
count_inc_c:cover property(count_inc_p);

property count_dec_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (!FIFO_if.wr_en   && FIFO_if.rd_en && !FIFO_if.empty) |=> 
															(count == $past(count)-1'b1);
endproperty

count_dec_a:assert property(count_dec_p);
count_dec_c:cover property(count_dec_p);


property count_no_change_p;
@(posedge FIFO_if.clk) disable iff(!FIFO_if.rst_n) (FIFO_if.wr_en && FIFO_if.rd_en && !FIFO_if.full && !FIFO_if.empty )  |=> 
																					(count == $past(count));
endproperty

count_no_change_a:assert property(count_no_change_p);
count_no_change_c:cover property(count_no_change_p);




always_comb begin : comb_outputs
	if(FIFO_if.rst_n) begin
		
		if(count == FIFO_if.FIFO_DEPTH) begin
			full_check:assert(FIFO_if.full == 1'b1);
		end
		
		if(count == FIFO_if.FIFO_DEPTH-1) begin
			almost_full_check:assert(FIFO_if.almostfull == 1'b1);
		end 

		if(count == 0) begin
			empty_check:assert(FIFO_if.empty == 1'b1);
		end 
		
		if(count == 1) begin
			almostempty_check:assert(FIFO_if.almostempty == 1'b1);
		end 
		

	end
	
end

always_comb begin :reset_outputs
	if(!FIFO_if.rst_n) 
		reset:assert final (count == 0 && wr_ptr == 0 && rd_ptr == 0 && FIFO_if.empty == 1'b1 && FIFO_if.full == 0  && FIFO_if.almostempty == 0 && FIFO_if.almostfull == 0 && FIFO_if.wr_ack == 0  );
end

`endif 
endmodule

