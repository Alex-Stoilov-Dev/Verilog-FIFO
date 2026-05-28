# FIFO in Verilog

The FIFO is a synchronus design. It buffers data from a write source to a read output.
The read output is shown in the same order as the it was writen to the FIFO.

The FIFO is realized using an underlying memory model which can also be found in the files of the FIFO. 
The memory model was later replaced with a synthesizeable register array so the whole design can be produced.

The FIFO writes and reads in a circular manner. Meaning that when it reaches the last address it wraps around
and goes to the first address.

The FIFO has two additional outputs "FULL" and "EMPTY". The FULL output is HIGH if the all of the data slots inside the FIFO have information in them that hasn't been read.
The EMTPY output is HIGH if all of the data in the FIFO has been read.

The outputs are also used to determine valid read and write operations. As we do not want the Write/Read pointers 
to be incremented if we are full/empty.
