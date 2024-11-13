module ALU(
    input [31:0]alu_op1,
    input [31:0]alu_op2,
    input [3:0]alu_ctrl,
    output reg [31:0]alu_res
);
 always@(*)
    begin
     case(alu_ctrl)
        4'b0000:
        begin
        alu_res=alu_op1+alu_op2;
        end
        4'b0001:
        begin
        alu_res=alu_op1-alu_op2;
        end
        4'b0010:
        begin
        alu_res=(alu_op1==alu_op2);
        end
        4'b0011:
        begin
        alu_res=(alu_op1<alu_op2);
        end
        4'b0100:
        begin
        if(alu_op1[32-1]>alu_op2[32-1])
        alu_res=1;
        else if(alu_op1[32-1]<alu_op2[32-1])
        alu_res=0;
        else 
        if(alu_op1[32-2]<alu_op2[32-2])
        alu_res=1;
        else 
        alu_res=0;
        end
        4'b0101:
        begin
        alu_res=(alu_op1&alu_op2);
        end
        4'b0110:
        begin
        alu_res=(alu_op1|alu_op2);
        end
        4'b0111:
        begin
        alu_res=(alu_op1^alu_op2);
        end
        4'b1000:
        begin
        
        alu_res=alu_op1>>alu_op2;
        end
        4'b1001:
        begin
        alu_res=alu_op1<<alu_op2;        
        end
        default:
        begin
            alu_res = 0;
        end
     endcase
    end
endmodule