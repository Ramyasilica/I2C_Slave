`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2026 11:48:44 AM
// Design Name: 
// Module Name: i2c_slave_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_i2c_slave;

    reg reset_n;
    reg scl_drv;
    reg sda_drv;

    wire scl;
    wire sda;

    wire [6:0] address_out;
    wire [7:0] data_out;

    // Open drain modeling
    assign scl = scl_drv;
    assign sda = (sda_drv) ? 1'b0 : 1'bz;

    // Pull-up for SDA (MANDATORY)
    pullup(sda);

    // DUT
    i2c_slave dut (
        .reset_n(reset_n),
        .scl(scl),
        .sda(sda),
        .address_out(address_out),
        .data_out(data_out)
    );

    // Clock
    always #5 scl_drv = ~scl_drv;

    initial begin
        scl_drv = 1;
        sda_drv = 0;
        reset_n = 0;

        #20 reset_n = 1;

        // START condition
        #10 sda_drv = 1;
        #10 sda_drv = 0;

        // Send address 0x55 + write (0)
        send_byte(8'hAA);   // 10101010 → addr 55 + write

        // ACK bit
        #10;

        // Send data
        send_byte(8'hA5);

        #50;
        $finish;
    end

    task send_byte(input [7:0] data);
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                @(negedge scl);
                sda_drv = ~data[i];
            end
            @(negedge scl);
            sda_drv = 0; // release for ACK
        end
    endtask

endmodule

