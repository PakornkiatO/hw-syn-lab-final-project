module image_generator (
    input [1:0] sw,
    input clk,
    input reset,
    output wire [11:0] pixel_rgb,
    output wire hsync,
    output wire vsync
);

    wire clk_25MHz;

    clk_25MHz (
        .clk_in1(clk),
        .reset(reset),
        .clk_out1(clk_25MHz)
    );

    wire video_on;
    wire [9:0] curr_x;
    wire [9:0] curr_y;

    vga_controller (
        .clk(clk_25MHz),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .video_on(video_on),
        .curr_x(curr_x),
        .curr_y(curr_y)
    );

    wire [11:0] w_pixel_rgb;

    image_pixel_controller (
        .sw(sw[1]),
        .clk(clk_25MHz),
        .reset(reset),
        .curr_x(curr_x),
        .curr_y(curr_y),
        .video_on(video_on),
        .pixel_rgb(w_pixel_rgb)
    );

    assign pixel_rgb[11:9] = (sw[0]) ? 4097 - w_pixel_rgb[7:5] : w_pixel_rgb[7:5];
    assign pixel_rgb[7:5] = (sw[0]) ? 4097 - w_pixel_rgb[4:2] : w_pixel_rgb[4:2];
    assign pixel_rgb[3:2] = (sw[0]) ? 4097 - w_pixel_rgb[1:0] : w_pixel_rgb[1:0];

endmodule
