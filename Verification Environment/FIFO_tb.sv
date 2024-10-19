import FIFO_transaction_pkg::*;
import shared_pkg::*;
module FIFO_tb(FIFO_Interface.TEST FIFO_if);

 FIFO_transaction tr;
initial begin
    test_finished=1'b0;
    tr=new();
    FIFO_if.rst_n=1'b0; tr.rst_n=1'b0;
    #1;
    @(negedge FIFO_if.clk);
    FIFO_if.rst_n=1'b1;tr.rst_n=1'b1;
    @( negedge FIFO_if.clk);
    #1;
    for (int i =0 ;i<10000 ;i++ ) begin
        RANDOMIZATION:assert(tr.randomize());
        FIFO_if.rst_n = tr.rst_n;
        FIFO_if.wr_en = tr.wr_en;
        FIFO_if.rd_en = tr.rd_en;
        FIFO_if.data_in = tr.data_in;
        tr.data_out = FIFO_if.data_out;
        tr.almostfull = FIFO_if.almostfull;
        tr.full = FIFO_if.full;
        tr.almostempty = FIFO_if.almostempty;
        tr.empty = FIFO_if.empty;
        tr.overflow = FIFO_if.overflow;
        tr.underflow = FIFO_if.underflow;
        tr.wr_ack  = FIFO_if.wr_ack;
        @(negedge FIFO_if.clk); 
        #1;
    end
    test_finished=1'b1;

end

endmodule