import FIFO_transaction_pkg::*;
import Functional_Coverage_Collection_pkg::*;
import FIFO_scoreboard_pkg::*;
import shared_pkg::*;

module FIFO_Monitor(FIFO_Interface.MONITOR FIFO_if);


    FIFO_transaction fifo_tr ;
    FIFO_Scoreboard fifo_scoreboard ;
    FIFO_coverage fifo_coverage ;
initial begin
     fifo_tr = new();
     fifo_scoreboard = new();
     fifo_coverage = new();
    forever begin

        @(negedge FIFO_if.clk);
        fifo_tr.rst_n=FIFO_if.rst_n;
        fifo_tr.data_in=FIFO_if.data_in;
        fifo_tr.rd_en=FIFO_if.rd_en;
        fifo_tr.wr_en=FIFO_if.wr_en;
        fifo_tr.data_out=FIFO_if.data_out;
        fifo_tr.almostfull=FIFO_if.almostfull;
        fifo_tr.full=FIFO_if.full;
        fifo_tr.almostempty=FIFO_if.almostempty;
        fifo_tr.empty=FIFO_if.empty;
        fifo_tr.overflow=FIFO_if.overflow;
        fifo_tr.underflow=FIFO_if.underflow;
        fifo_tr.wr_ack=FIFO_if.wr_ack;
        
        fork
        begin
            fifo_coverage.sample_data(fifo_tr);
        end 

        begin
            fifo_scoreboard.check_data(fifo_tr);
        end
     join        
     if( test_finished == 1 ) begin
        $display("Testbench Summary: %0d Test Cases Passed , %0d Test Cases Failed",correct_count,error_count);
        $stop;
    end
    end

end

endmodule