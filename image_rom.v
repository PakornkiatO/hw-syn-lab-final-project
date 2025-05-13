module image_rom (
    input wire [16:0] rom_addr,
    output wire [11:0] rom_data
);

    reg [11:0] rom_memory[0:76799];
    reg [11:0] r_rom_data;

    initial begin
        $readmemh("image.mem", rom_memory);
    end

    always @(*) begin
        r_rom_data <= rom_memory[rom_addr];
    end

    assign rom_data = r_rom_data;

endmodule
