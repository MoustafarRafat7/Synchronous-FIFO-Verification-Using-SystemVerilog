package FIFO_scoreboard_pkg;

import FIFO_transaction_pkg::*;
import shared_pkg::*;

class FIFO_Scoreboard;

bit almostfull_ref,full_ref;
bit almostempty_ref,empty_ref;
bit overflow_ref,underflow_ref;
bit wr_ack_ref;
bit [FIFO_WIDTH-1:0]data_out_ref;

bit [FIFO_WIDTH-1:0] mem [$];
int count = 0 ;
function void reference_model(FIFO_transaction tr1);
    if (tr1.rst_n) begin
        if (tr1.wr_en && !tr1.rd_en && count < FIFO_DEPTH) begin
            mem.push_front(tr1.data_in);  // Write data into memory
            count++;  // Increment count
        end
        else if (!tr1.wr_en && tr1.rd_en && count != 0) begin
            data_out_ref = mem.pop_back;  // Read data from memory
            count--;  // Decrement count
        end
        else if (tr1.wr_en && tr1.rd_en && count > 0 && count < FIFO_DEPTH) begin
            mem.push_front(tr1.data_in);  // Write and Read simultaneously
            data_out_ref = mem.pop_back;
            count = count;  // Count remains unchanged
        end
        else if (tr1.wr_en && tr1.rd_en && count == FIFO_DEPTH) begin
            data_out_ref = mem.pop_back;  // Read when FIFO is full
            count--;  // Decrement count as a read is happening
        end
        else if (tr1.wr_en && tr1.rd_en && count == 0) begin
            mem.push_front(tr1.data_in);  // Write when FIFO is empty
            count++;  // Increment count as a write is happening
        end
    end
    else if (!tr1.rst_n) begin
        mem.delete;  // Reset memory
        count = 0;   // Reset count
    end
endfunction

function void check_data(FIFO_transaction tr2);
    reference_model(tr2);
    if (data_out_ref == tr2.data_out) begin
        correct_count = correct_count + 1;
    end
    else begin
        error_count = error_count + 1;
        $display("Error: at %0t ns  Expected data_out = 0x%0h, Actual data_out = 0x%0h", $time, data_out_ref, tr2.data_out);
        $display("Transaction details at %0t ns: rst_n = %0b, wr_en = %0b, rd_en = %0b, data_in = 0x%0h, data_out = 0x%0h, full = %0b, empty = %0b, wr_ack = %0b",
                 $time, tr2.rst_n, tr2.wr_en, tr2.rd_en, tr2.data_in, tr2.data_out, tr2.full, tr2.empty, tr2.wr_ack);
    end
endfunction

endclass
endpackage