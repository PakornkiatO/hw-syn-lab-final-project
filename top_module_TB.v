`timescale 1ns/1ps

module top_module_TB;
    reg clk;
    reg reset;
    reg miso;
    wire sclk;
    wire mosi;
    wire cs;
    wire [5:0] led;

    // Instantiate the design under test
    top_module dut (
        .clk(clk),
        .reset(reset),
        .miso(miso),
        .sclk(sclk),
        .mosi(mosi),
        .cs(cs),
        .led(led)
    );

    // Clock generation: 100 MHz (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Simulation sequence
    initial begin
        // Initialize
        reset = 1;
        miso = 0;

        // Apply reset
        #50;
        reset = 0;

        // Wait some time for state transitions
        #2000;

        // End simulation
        $finish;
    end

    // Optional: Monitor signal changes
    initial begin
        $display("Time\tclk\treset\tcs\tmosi\tled");
        $monitor("%g\t%b\t%b\t%b\t%b\t%b", $time, clk, reset, cs, mosi, led);
    end

endmodule
