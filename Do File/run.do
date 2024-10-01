vlib work
vlog *v  +cover -covercells +define+SIM
vsim -voptargs=+acc FIFO_Top -cover -l sim.log
add wave -position insertpoint sim:/FIFO_Top/FIFO_if/*
add wave -position insertpoint sim:/FIFO_Top/FIFO_Design/*
add wave /FIFO_Top/FIFO_Design/overflow_c /FIFO_Top/FIFO_Design/underflow_c /FIFO_Top/FIFO_Design/wr_ptr_c /FIFO_Top/FIFO_Design/rd_ptr_c /FIFO_Top/FIFO_Design/wr_ack_c
add wave /FIFO_Top/FIFO_Design/wr_ack_a /FIFO_Top/FIFO_Design/overflow_a /FIFO_Top/FIFO_Design/underflow_a /FIFO_Top/FIFO_Design/wr_ptr_a /FIFO_Top/FIFO_Design/rd_ptr_a  /FIFO_Top/FIFO_Design/comb_outputs/almostempty_check /FIFO_Top/FIFO_Design/comb_outputs/empty_check /FIFO_Top/FIFO_Design/comb_outputs/full_check /FIFO_Top/FIFO_Design/comb_outputs/almost_full_check
coverage save top.ucdb -onexit 
run -all
