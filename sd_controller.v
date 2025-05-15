module sd_controller (
    input clk,
    input load,
    input address,
    input reset,
    input miso,
    output wire sclk,
    output reg mosi,
    output reg cs,
    output wire ready,
    output reg [4095:0] dout
);
    parameter CMD0   = {8'h40, 8'h00, 8'h00, 8'h00, 8'h00, 8'h95};
    parameter CMD8   = {8'h48, 8'h00, 8'h00, 8'h01, 8'haa, 8'h87};
    parameter CMD55  = {8'h77, 8'h00, 8'h00, 8'h00, 8'h00, 8'hff};
    parameter ACMD41 = {8'h69, 8'h40, 8'h00, 8'h00, 8'h00, 8'hff};

    reg [47:0] cmd;
    reg [5:0] outIdx;
    reg [12:0] inIdx;
    reg [4119:0] dataBuffer;
    reg [9:0] counter;
    reg [4:0] waitConter;

    assign sclk = clk;

    reg [2:0] state;

    initial begin
        mosi = 1;
        cs = 1;
    end

    always @(posedge sclk or posedge reset) begin
        if (reset) begin
            mosi = 1;
            cs = 1;
            cmd = CMD0;
            state = 0;
            counter = 1000;
        end else begin
            case (state)
                0:  begin
                    counter = counter - 1;
                    if(counter == 0) begin
                        cs = 0;
                        outIdx = 47;
                        state = 1;
                    end
                end
                1: begin
                    mosi = cmd[outIdx];
                    if (outIdx == 0) begin
                        state = 2;
                    end
                    outIdx = outIdx - 1;
                end
                2: begin
                    if(cmd[45:40] == 6'd18) inIdx = 512 + 3;
                    else if (cmd == CMD8 || CMD55) inIdx = 39;
                    else inIdx = 7;
                    dataBuffer = 0;
                    waitConter = 16;
                    state = 3;
                    // led[1] = 1;
                    // mosi = 1;
                    // if(miso == 0) begin
                    //     dataBuffer[inIdx] = miso;
                    //     if(inIdx == 0) begin
                    //         state = 3;
                    //     end
                    //     inIdx = inIdx - 1;
                    // end else begin
                    //     counter = counter + 1;
                    // end

                    // if(counter >= 16) begin
                    //     state = 1;
                    // end
                end
                3: begin
                    mosi = 1;
                    if(miso == 0) begin
                        state = 4;
                        dataBuffer[inIdx] = miso;
                        inIdx = inIdx-1;
                    end else waitConter = waitConter - 1;

                    if(waitConter == 0) begin
                        state = 1;
                    end
                    // led[2] = 1;
                    // mosi = CMD8[outIdx];
                    // if (outIdx == 0) begin
                    //     inIdx = 39;
                    //     counter = 0;
                    //     state = 4;
                    // end
                    // outIdx = outIdx - 1;
                end
                4: begin
                    dataBuffer[inIdx] = miso;
                    if (inIdx == 0) begin
                        state = 5;
                    end
                    inIdx = inIdx - 1;
                    // outIdx = 47;
                    // led[3] = 1;
                    // mosi = 1;
                    // if(miso == 0) begin
                    //     dataBuffer[inIdx] = miso;
                    //     if(inIdx == 0) begin
                    //         if (dataBuffer[39:32] == 8'b00000001 ||
                    //             dataBuffer[39:32] == 8'b00000101) begin
                    //             state = 5;
                    //         end else begin
                    //             led[5] = 1;
                    //             state = 3;
                    //         end
                    //         // state = 5;
                    //     end
                    //     inIdx = inIdx - 1;
                    // end else begin
                    //     counter = counter + 1;
                    // end

                    // if(counter == 16) begin
                    //     state = 3;
                    // end
                end
                5: begin
                    case (cmd)
                        CMD0: begin
                            cmd = CMD8;
                            state = 1;
                        end
                        CMD8: begin
                            cmd = CMD55;
                            state = 1;
                        end
                        CMD55: begin
                            cmd = ACMD41;
                            state = 1;
                        end
                        ACMD41: begin
                            if(dataBuffer == 1) begin
                                cmd = CMD55;
                                state = 1;
                            end else begin
                                state = 6;
                            end
                        end
                        default: ;
                    endcase
                    // led[4] = 1;
                end
                6: begin
                    if (load) begin
                        cmd = {2'b01, 6'd18, address, 7'd67, 1'b1};
                        outIdx = 47;
                        state = 1;
                    end
                end
                default: state = 0;
            endcase
        end
    end

    assign ready = (state == 6);

    always @(posedge sclk) begin
        dout <= dataBuffer[4095:16];
    end

endmodule
