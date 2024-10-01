// Module Declaration //
module FIFO_Top();

bit clk ;

// Clock Generation //
always begin
    clk=1'b1;
    #2;
    clk=1'b0;
    #2;
end

//  Interface && DUT && Testbench && Monitor Instantiation //
FIFO_Interface FIFO_if (clk) ;
FIFO FIFO_Design (FIFO_if);
FIFO_tb FIFO_TEST(FIFO_if);
FIFO_Monitor fifo_monitor(FIFO_if);

endmodule