module top_module (
    input clk,
    input reset,
    input miso,
    output sclk,
    output mosi,
    output cs
);

    wire clk_25MHz;
    // wire nclk_25MHz;
    wire ready;
    wire load;
    reg [4095:0] r_dout;

    clk_25MHz clk_inst(
        .clk_in1(clk),
        .reset(reset),
        .clk_out1(clk_25MHz),
        .clk_out2(nclk_25MHz)
    );

    // sd_controller sd_inst(
    //     .clk(clk_25MHz),
    //     .nclk(nclk_25MHz),
    //     .reset(reset),
    //     .miso(miso),
    //     .sclk(sclk),
    //     .mosi(mosi),
    //     .cs(cs),
    //     .led(led)
    // );

    assign load = (ready)? 1:0;

    sd_controller sd_inst(
        .clk(clk_25MHz),
        .load(load),
        .address(0),
        .reset(reset),
        .miso(miso),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .ready(ready),
        .dout(dout)
    );

endmodule
