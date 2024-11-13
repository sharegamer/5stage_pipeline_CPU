module Branch(
    input [31:0]rd0,
    input [31:0]rd1,
    input [1:0]br_type,
    output reg br
);
always@(*)
begin
    case(br_type)
    2'b01:
    begin
        if(rd0==rd1)
        br=1;
        else
        br=0;
    end
    2'b10:
    begin
        if(rd0[31]==rd1[31])
        begin
        if(rd0<rd1)
        br=1;
        else
        br=0;
        end
        else
        begin
        if(rd0[31]==1)
        br=1;
        else
        br=0;
        end
    end
    default:br=0;
endcase
end
endmodule