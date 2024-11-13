module RF (
    input clk,
    input we,
    input [4:0]ra0,
    input [4:0]ra1,
    input [4:0]wa,
    input [31:0]wd,
    input [4:0]ra_dbg,
    output reg[31:0]rd0,
    output reg[31:0]rd1,
    output reg[31:0]rd_dbg
);
reg [31:0] regfile[31:0];
integer i; 
initial begin
    for(i=0;i<32;i++)   regfile[i]=0;
end
always@(posedge clk)
begin
    if(we&&wa!=0)
    regfile[wa]<=wd;
    else
    regfile[wa]<=regfile[wa];
end
always @(*) begin
    if(we&&wa==rd0)
    rd0=wd;
    else
    rd0=regfile[ra0];
    if(we&&wa==rd1)
    rd1=wd;
    else
    rd1=regfile[ra1];
    if(we&&wa==rd0)
    rd0=wd;
    else
    rd0=regfile[ra0];

end
assign rd0=(we&&wa==rd0)?wd:regfile[ra0];
assign rd1=(we&&wa==rd1)?wd:regfile[ra1];
assign rd_dbg=(we&&wa==rd_dbg)?wd:regfile[ra_dbg];
endmodule