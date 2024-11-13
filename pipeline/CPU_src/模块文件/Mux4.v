`timescale 1ns / 1ps
/* 
 *   Author: wintermelon
 *   Last update: 2023.05.03
 */

// This is a simple 4-1 Mux.
/* Ports
    Mux4 #(32) my_mux (
        .sr1(),
        .sr2(),
        .sr3(),
        .sr4(),
        .sel(),

        .res()
    );
*/

module Mux4 #(WIDTH = 32) (
    input [WIDTH-1: 0]          sr1,
    input [WIDTH-1: 0]          sr2,
    input [WIDTH-1: 0]          sr3,
    input [WIDTH-1: 0]          sr4,
    input [1:0]                 sel,

    output reg [WIDTH-1: 0]     res
);  

    always @(*) begin
        case (sel)
            2'b00: res = sr1;
            2'b01: res = sr2;
            2'b10: res = sr3;
            2'b11: res = sr4;
        endcase // We don't need default here
    end

endmodule