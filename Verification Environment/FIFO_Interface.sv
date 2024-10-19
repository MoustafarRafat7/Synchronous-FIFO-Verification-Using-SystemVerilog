interface FIFO_Interface(clk);

// FIFO Parameters //
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8 ;

input clk;

// FIFO Signals //
bit rst_n;
bit [FIFO_WIDTH-1 :0] data_in;
bit wr_en,rd_en;
bit [FIFO_WIDTH-1 :0] data_out;
bit almostfull,full;
bit almostempty,empty;
bit overflow,underflow;
bit wr_ack;

// Modports // 

modport DUT (input clk, rst_n, wr_en, rd_en, data_in , output data_out, almostfull, full,
                       almostempty, empty, overflow, underflow, wr_ack );

modport TEST (input clk, data_out, almostfull, full, almostempty, empty, overflow, underflow, wr_ack,
              output rst_n, wr_en, rd_en, data_in );

modport MONITOR (input clk, rst_n, data_in, wr_en, rd_en, data_out, almostfull, full,
                       almostempty, empty, overflow, underflow, wr_ack );

endinterface