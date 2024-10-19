package FIFO_transaction_pkg;

import shared_pkg::*;


class FIFO_transaction;

bit clk;
rand bit rst_n;
rand bit [FIFO_WIDTH-1 :0] data_in;
rand bit wr_en,rd_en;
bit [FIFO_WIDTH-1 :0] data_out;
bit almostfull,full;
bit almostempty,empty;
bit overflow,underflow;
bit wr_ack;
int RD_EN_ON_DIST , WR_EN_ON_DIST;

function new (int RD_EN_ON_DIST = 30 , int WR_EN_ON_DIST = 70  );
 
  this.RD_EN_ON_DIST=RD_EN_ON_DIST;
  this.WR_EN_ON_DIST=WR_EN_ON_DIST;

endfunction

// Constraints // 

constraint Assert_reset_less_often {
                    rst_n dist {1:=98 ,0:=2};
} 


constraint WRITE_ENABLE{
                        wr_en dist {1:=WR_EN_ON_DIST , 0:=100-WR_EN_ON_DIST};
}

constraint READ_ENABLE{
                        rd_en dist {1:=RD_EN_ON_DIST , 0:=100-RD_EN_ON_DIST};
}


endclass

endpackage