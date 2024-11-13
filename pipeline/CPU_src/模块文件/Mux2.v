`timescale 1ns / 1ps
/* 
 *   Author: wintermelon
 *   Last update: 2023.05.03
 */

// This is a simple 2-1 Mux.
/* Ports
    Mux2 #(32) my_mux (
        .sr1(),
        .sr2(),
        .sel(),

        .res()
    );
*/

module Mux2 #(WIDTH = 32) (
    input [WIDTH-1: 0]          sr1,
    input [WIDTH-1: 0]          sr2,
    input                       sel,

    output reg [WIDTH-1: 0]     res
);  

    always @(*) begin
        case (sel)
            1'b0: res = sr1;
            1'b1: res = sr2;
        endcase // We don't need default here
    end

endmodule