package Functional_Coverage_Collection_pkg;

import FIFO_transaction_pkg::*;

class  FIFO_coverage;

FIFO_transaction F_cvg_txn= new();

covergroup FIFO_cvg ;

wr_cp:coverpoint F_cvg_txn.wr_en {
                            bins wr_en_one = {1};
                            bins wr_en_zero = {0};
                            }

rd_cp:coverpoint F_cvg_txn.rd_en {
                            bins rd_en_one = {1};
                            bins rd_en_zero = {0};
                            }

almostfull_cp: coverpoint F_cvg_txn.almostfull {
                                bins almostfull_one = {1};
                                bins almostfull_zero = {0};
}

full_cp: coverpoint F_cvg_txn.full {
                     bins full_one = {1};
                     bins full_zero = {0};
}

almostempty_cp: coverpoint F_cvg_txn.almostempty {
                                bins almostempty_one = {1};
                                bins almostempty_zero = {0};
}

empty_cp:coverpoint F_cvg_txn.empty {
                     bins empty_one = {1};
                     bins empty_zero = {0};
}

of_cp: coverpoint F_cvg_txn.overflow {
                             bins overflow_one = {1};
                             bins overflow_zero = {0};                    
}

uf_cp: coverpoint F_cvg_txn.underflow {
                             bins underflow_one = {1};
                             bins underflow_zero = {0};                    
}

wr_ack_cp:coverpoint F_cvg_txn.wr_ack {
                             bins wr_ack_one = {1};
                             bins wr_ack_zero = {0};   

}

wr_rd_almostfull_cp:cross wr_cp,rd_cp,almostfull_cp ;

wr_rd_full_cp:cross wr_cp,rd_cp,full_cp  {
                                        illegal_bins no_write_read_full = binsof(full_cp.full_one) && binsof(rd_cp.rd_en_one) && binsof(wr_cp.wr_en_zero);
                                        illegal_bins write_read_full = binsof(full_cp.full_one) && binsof(rd_cp.rd_en_one) && binsof(wr_cp.wr_en_one);
                                        }

wr_rd_almostempty_cp:cross wr_cp,rd_cp,almostempty_cp;

wr_rd_empty_cp:cross wr_cp,rd_cp,empty_cp;

wr_rd_overflow_cp:cross wr_cp,rd_cp,of_cp {
                                        illegal_bins no_write_no_read_of = binsof(of_cp.overflow_one) && binsof(rd_cp.rd_en_zero) && binsof(wr_cp.wr_en_zero);
                                        illegal_bins no_write_read_uf = binsof(of_cp.overflow_one) && binsof(rd_cp.rd_en_one) && binsof(wr_cp.wr_en_zero);
                                        }

wr_rd_underflow_cp:cross wr_cp,rd_cp,uf_cp {
                                        illegal_bins write_no_read_uf = binsof(uf_cp.underflow_one) && binsof(rd_cp.rd_en_zero) && binsof(wr_cp.wr_en_one);
                                        illegal_bins no_write_no_read_uf = binsof(uf_cp.underflow_one) && binsof(rd_cp.rd_en_zero) && binsof(wr_cp.wr_en_zero);
                                        }

wr_rd_ack_cp:cross wr_cp,rd_cp,wr_ack_cp{
                                          illegal_bins no_write_no_read_wr_ack = binsof(wr_ack_cp.wr_ack_one) && binsof(wr_cp.wr_en_zero) && binsof(rd_cp.rd_en_zero);
                                          illegal_bins no_write_read_wr_ack = binsof(wr_ack_cp.wr_ack_one) && binsof(wr_cp.wr_en_zero) && binsof(rd_cp.rd_en_one);
                                        }
endgroup

function new ();

FIFO_cvg=new();

endfunction

function void sample_data(FIFO_transaction F_txn ) ;
F_cvg_txn=F_txn;
FIFO_cvg.start();
FIFO_cvg.sample();
endfunction

endclass

endpackage