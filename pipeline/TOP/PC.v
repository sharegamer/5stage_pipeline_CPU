module PC (
    input clk,
    input stall,
    input rst,
    input [31:0]pc_next,
    output reg[31:0] pc_cur
);
always @(posedge clk or posedge rst) begin
    if(rst)
    pc_cur<=32'h3000;
    else if(stall)
    pc_cur<=pc_cur;
    else
    pc_cur<=pc_next;
end
    
endmodule