module fifo #(
    parameter ADDR_WIDTH = 2,
    parameter DATA_WIDTH = 4
) (
    input clk,
    input we,
    input rst,
    input re,
    input [DATA_WIDTH-1:0] wrdata,
    output reg full,
    output reg empty,
    output reg [DATA_WIDTH-1:0] rddata
);
    
    reg [ADDR_WIDTH:0] WrPtr;
    reg [ADDR_WIDTH:0] RdPtr;

    wire wdata1_tie_off;
    wire we1_const_zero;
    assign we1_const_zero = 1'b0;
    wire unused1;

    // dual_mem_model #(
    //     .DATA_WIDTH(DATA_WIDTH),
    //     .ADDR_WIDTH(ADDR_WIDTH)
    // )  
    // mem_model (
    //     .clk(clk),
    //     .we0(we),
    //     .addr0(WrPtr[ADDR_WIDTH-1:0]),
    //     .wdata0(wrdata),
    //     .rdata0(unused1),
    //     .we1(we1_const_zero),
    //     .addr1(RdPtr[ADDR_WIDTH-1:0]),
    //     .wdata1(wdata1_tie_off),
    //     .rdata1(rddata)
    // );
    
    dual_port_register_memory#(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    )  
    mem_model (
        .clk(clk),
        .we0(we),
        .addr0(WrPtr[ADDR_WIDTH-1:0]),
        .wdata0(wrdata),
        .rdata0(unused1),
        .we1(we1_const_zero),
        .addr1(RdPtr[ADDR_WIDTH-1:0]),
        .wdata1(wdata1_tie_off),
        .rdata1(rddata)
    );


    always@(posedge clk) begin
        if (rst) begin
            WrPtr <= 0;
        end
        else if (we == 1 && !full) begin
            WrPtr <= WrPtr + 1'b1;
        end
    end

    always@(posedge clk) begin
        if (rst) begin
            RdPtr <= 0;
        end
        else if (re == 1 && !empty) begin
            RdPtr <= RdPtr + 1'b1;
        end
    end

    always@(*) begin
        if (WrPtr[ADDR_WIDTH] == RdPtr[ADDR_WIDTH] && WrPtr[ADDR_WIDTH-1:0] == RdPtr[ADDR_WIDTH-1:0]) begin
            empty <= 1'b1;
        end
        else begin
            empty <= 1'b0;
        end
        if (WrPtr[ADDR_WIDTH] != RdPtr[ADDR_WIDTH] && (WrPtr[ADDR_WIDTH-1:0] == RdPtr[ADDR_WIDTH-1:0])) begin
            full <= 1'b1;
        end
        else begin
            full <= 1'b0;
        end
    end

endmodule