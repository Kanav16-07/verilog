module fifo (
    input clk,
    input reset,
    input wr_en,
    input rd_en,
    input [7:0] din,
    output reg [7:0] dout,
    output reg full,
    output reg empty
);

    reg [7:0] mem [15:0]; // 16-depth FIFO, 8-bit wide
    reg [3:0] wr_ptr = 0;
    reg [3:0] rd_ptr = 0;
    reg [4:0] count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            full <= 0;
            empty <= 1;
            dout <= 0;
        end else begin
            // Write
            if (wr_en && !full) begin
                mem[wr_ptr] <= din;
                wr_ptr <= wr_ptr + 1;
                count <= count + 1;
            end

            // Read
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
                count <= count - 1;
            end

            // Update flags
            full <= (count == 16);
            empty <= (count == 0);
        end
    end

endmodule
