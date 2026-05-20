// Should be all good to start looking into rewriting the memory module 
module test_bench ();

    parameter ADDR_WIDTH = 2;
    parameter DATA_WIDTH = 4;
    parameter WRITE_COUNTER_EMTPY = {ADDR_WIDTH{1'b0}};
    parameter WRITE_COUNTER_FULL = {ADDR_WIDTH{1'b1}};

    reg clk;
    reg rst;
    reg WriteEnable;
    reg ReadEnable;
    reg [DATA_WIDTH-1:0] fifo_wdata;
    reg full_indicator;
    reg empty_indicator;
    reg [DATA_WIDTH-1:0] fifo_rdata;

    reg [ADDR_WIDTH:0] write_counter;
    reg [ADDR_WIDTH:0] read_counter;

    reg expected_full;
    reg expected_empty;

    fifo  #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) my_fifo (
        .clk(clk),
        .rst(rst),
        .we(WriteEnable),
        .re(ReadEnable),
        .wrdata(fifo_wdata),
        .rddata(fifo_rdata),
        .full(full_indicator),
        .empty(empty_indicator)
    );

    initial begin
        clk = 0;
    end

    initial begin
        rst <= 0;
        repeat(1)@(posedge clk);
        rst <= 1;
        repeat(2)@(posedge clk);
        rst <= 0;
    end

    always begin
        #5;
        clk = ~clk;
    end

    initial begin
        WriteEnable <= 1'b0;
        ReadEnable <= 1'b0;
    end

    // Block to send random data to the fifo
    always@(posedge clk) begin
       
       // repeat(20)@(posedge clk) begin
       //     WriteEnable <= 1'b1;
       // end

       // repeat(20)@(posedge clk) begin
       //     WriteEnable <= 1'b0;
       //     ReadEnable <= 1'b1;
       // end

       // ReadEnable <= 1'b0;

        integer i;

        for (i = 0; i < 20; i = i + 1) begin
            WriteEnable <= $random;
            ReadEnable <= $random;
            fifo_wdata <= $random;
        end
    end

    always @ (posedge clk) begin
        if (rst) begin
            fifo_wdata <= 4'b0000;
        end
        else begin
            fifo_wdata <= $random;
        end
    end

    // Combinational logic to determine expected empty
    // and expected full

    // Sequential logic to keep track of the write count.
    always@(posedge clk) begin
        if (rst) begin
            write_counter <= 0;
        end
        else if (WriteEnable && !expected_full) begin
            write_counter <= write_counter + 1;
        end
        else begin
            write_counter <= write_counter;
        end
    end

    always@(posedge clk) begin
        if (rst) begin
            read_counter <= 0;
        end
        else if (ReadEnable && !expected_empty) begin
            read_counter <= read_counter + 1;
        end
        else begin
            read_counter <= read_counter;
        end
    end

    always@(*) begin
        if (write_counter[ADDR_WIDTH] == read_counter[ADDR_WIDTH] && write_counter[ADDR_WIDTH-1:0] == read_counter[ADDR_WIDTH-1:0]) begin
            expected_empty <= 1'b1;
        end
        else begin
            expected_empty <= 1'b0;
        end
        if (write_counter[ADDR_WIDTH] != read_counter[ADDR_WIDTH] && (write_counter[ADDR_WIDTH-1:0] == read_counter[ADDR_WIDTH-1:0])) begin
            expected_full <= 1'b1;
        end
        else begin
            expected_full <= 1'b0;
        end
    end

    initial begin
        #1500;
        $finish;
    end

endmodule
