`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2026 11:48:13 AM
// Design Name: 
// Module Name: i2c_slave
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
//////////////////////////////////////////
module i2c_slave (
    input  wire reset_n,
    inout  wire scl,
    inout  wire sda,
    output reg  [6:0] address_out,
    output reg  [7:0] data_out
);

    // Slave address
    parameter SLAVE_ADDR = 7'h55;

    // Open drain SDA
    reg sda_drv;
    assign sda = (sda_drv) ? 1'b0 : 1'bz;

    // FSM states
    localparam IDLE = 3'd0,
               ADDR = 3'd1,
               ACK1 = 3'd2,
               DATA = 3'd3,
               ACK2 = 3'd4;

    reg [2:0] state;
    reg [3:0] bit_cnt;
    reg [7:0] shift_reg;

    // START detection (SDA falling while SCL high)
    wire start_cond = (scl === 1'b1 && sda === 1'b0);

    // Main FSM - sample on posedge SCL
    always @(posedge scl or negedge reset_n) begin
        if (!reset_n) begin
            state       <= IDLE;
            bit_cnt     <= 0;
            shift_reg   <= 0;
            address_out <= 0;
            data_out    <= 0;
            sda_drv     <= 0;
        end else begin
            case (state)

            IDLE: begin
                sda_drv <= 0;
                if (start_cond) begin
                    bit_cnt   <= 0;
                    shift_reg <= 0;
                    state     <= ADDR;
                end
            end

            ADDR: begin
                shift_reg <= {shift_reg[6:0], sda};
                bit_cnt   <= bit_cnt + 1;

                if (bit_cnt == 7) begin
                    address_out <= shift_reg[6:0];
                    bit_cnt     <= 0;
                    state       <= ACK1;
                end
            end

            ACK1: begin
                // ACK if address matches
                if (address_out == SLAVE_ADDR)
                    sda_drv <= 1;
                else
                    sda_drv <= 0;
                state <= DATA;
            end

            DATA: begin
                sda_drv   <= 0;
                shift_reg <= {shift_reg[6:0], sda};
                bit_cnt   <= bit_cnt + 1;

                if (bit_cnt == 7) begin
                    data_out <= shift_reg;
                    bit_cnt  <= 0;
                    state    <= ACK2;
                end
            end

            ACK2: begin
                sda_drv <= 1;   // ACK data
                state   <= IDLE;
            end

            default: state <= IDLE;
            endcase
        end
    end

endmodule


