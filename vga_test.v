module vga_test (
    input clk,
    input reset,
    output wire [11:0] rgb,
    output wire hsync,
    output wire vsync
);

    wire clk_25MHz;

    clk_25MHz(
        .clk_in1(clk),
        .reset(reset),
        .clk_out1(clk_25MHz)
    );

    wire video_on;

    vga_controller(
        .clk(clk_25MHz),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .curr_x(),
        .curr_y()
    );

    assign rgb = (video_on) ? 12'b111111111111 : 12'b0;

endmodule
