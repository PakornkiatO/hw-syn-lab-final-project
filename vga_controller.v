module vga_controller(
    input wire clk,
    input wire reset,
    output wire hsync,
    output wire vsync,
    output wire video_on,
    output wire p_tick,
    output wire [9:0] x,
    output wire [9:0] y
);

    parameter HD = 640;
    parameter HF = 16;
    parameter HS = 96;
    parameter HB = 48;
    parameter HMAX = HD + HF + HS + HB - 1;

    parameter VD = 480;
    parameter VF = 10;
    parameter VS = 2;
    parameter VB = 33;
    parameter VMAX = VD + VF + VS + VB -1;

    reg [9:0] h_count = 0;
    reg [9:0] v_count = 0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == HMAX) begin
                h_count <= 0;
                if (v_count == VMAX) v_count <= 0;
                else v_count <= v_count + 1;
            end
            else h_count <= h_count + 1;
        end
    end

    assign hsync = (h_count >= (HD + HF) &&
                    h_count <  (HD + HF + HS)) ? 0 : 1;

    assign vsync = (v_count >= (VD + VF) &&
                    v_count <  (VD + VF + VS)) ? 0 : 1;

    assign video_on = (h_count < HD && v_count < VD);

    assign x = h_count;
    assign y = v_count;

endmodule
