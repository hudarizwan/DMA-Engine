module dma_engine (
    input wire clk,
    input wire rst,

    input wire start_transfer,
    input wire [31:0] src_addr_init,
    input wire [31:0] dst_addr_init,
    input wire [31:0] transfer_length,
    input wire [7:0] burst_size,

    output wire mem_read_req,
    output wire mem_write_req,
    output wire [31:0] mem_addr,
    output wire [31:0] mem_write_data,
    input wire [31:0] mem_read_data,
    input wire mem_ready,

    output reg status_busy,
    output reg status_done,
    output reg status_error,
    output reg interrupt
);

    wire [31:0] current_src_addr;
    wire [31:0] current_dst_addr;
    wire fsm_read_req;
    wire fsm_write_req;
    wire transfer_done;
    wire transfer_active;
    
    reg [31:0] data_buffer;
    reg is_writing;

    dma_fsm fsm_inst (
        .clk(clk),
        .rst(rst),
        .start_transfer(start_transfer),
        .src_addr_init(src_addr_init),
        .dst_addr_init(dst_addr_init),
        .length_init(transfer_length),
        .bus_op_done(mem_ready),
        .current_src_addr(current_src_addr),
        .current_dst_addr(current_dst_addr),
        .bus_read_req(fsm_read_req),
        .bus_write_req(fsm_write_req),
        .transfer_done(transfer_done),
        .transfer_active(transfer_active),
        .read_data_buffer(mem_read_data)
    );

    assign mem_read_req = fsm_read_req;
    assign mem_write_req = fsm_write_req;
    assign mem_addr = is_writing ? current_dst_addr : current_src_addr;
    assign mem_write_data = data_buffer;

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            data_buffer <= 32'd0;
            is_writing <= 1'b0;
        end else begin
            if (fsm_read_req && mem_ready) begin
                data_buffer <= mem_read_data;
                is_writing <= 1'b1;
            end else if (fsm_write_req && mem_ready) begin
                is_writing <= 1'b0;
            end
        end
    end

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            status_busy <= 1'b0;
            status_done <= 1'b0;
            status_error <= 1'b0;
            interrupt <= 1'b0;
        end else begin
            if (start_transfer) begin
                status_busy <= 1'b1;
                status_done <= 1'b0;
                interrupt <= 1'b0;
            end
            
            if (transfer_done) begin
                status_busy <= 1'b0;
                status_done <= 1'b1;
                interrupt <= 1'b1; 
            end
        end
    end

endmodule
