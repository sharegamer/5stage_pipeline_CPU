module CTRL(
    input [31:0]inst,
    output reg rf_re0,
    output reg rf_re1,
    output reg jal,
    output reg jalr,
    output reg [1:0]br_type,
    output reg wb_en,
    output reg [1:0]wb_sel,
    output reg alu_op1_sel,
    output reg alu_op2_sel,
    output reg [3:0]alu_ctrl,
    output reg [2:0]imm_type,
    output reg mem_we
);
wire [6:0]opcode;
reg [5:0]type;
wire [2:0]func;
assign func=inst[14:12];
assign opcode=inst[6:0];
always@(*)
begin
    case(type)
    6'b000001,
    6'b000010,
    6'b000100,
    6'b001000:
    begin
        if(inst[19:15]!=5'h0)
        rf_re0=1;
        else
        rf_re0=0;
    end
    default:rf_re0=0;
    endcase
end
always @(*) begin
    case(type)
    6'b000001,
    6'b000100,
    6'b001000:
    begin
        if(inst[24:20]!=5'h0)
        rf_re1=1;
        else
        rf_re1=0;
    end
    default:rf_re1=0;
    endcase
end
always @(*) begin
        case (opcode) 
        7'b0110011: type = 6'b000001; // R-type
        7'b1100111,
        7'b0000011,
        7'b0010011: type = 6'b000010; // I-type
        7'b1100011: type = 6'b000100; // B-type
        7'b0100011: type = 6'b001000; // S-type
        7'b1101111: type = 6'b010000; // J-type
        7'b0110111,
        7'b0010111: type = 6'b100000; // U-type
        default:    type = 6'b000000;
        endcase
    end
always @(*) begin
        case (type)
        6'b000010:imm_type = 3'b001; // I-type
        6'b000100:imm_type = 3'b010; // B-type
        6'b001000:imm_type = 3'b011; // S-type
        6'b010000:imm_type = 3'b100; // J-type
        6'b100000:imm_type = 3'b101; // U-type
        default:  imm_type = 3'b000;
        endcase
    end

always @(*) begin
    if(type==6'b000100)
    case(inst[14:12])
    3'b000:br_type=2'b01;//beq
    3'b100:br_type=2'b10;//blt
    default:br_type=2'b00;
    endcase
    else
    br_type=2'b00;
end

always @(*) begin
    case(opcode)
    7'b0110011,
    7'b0010011,
    7'b0010111:wb_sel=2'b00;
    7'b1101111,
    7'b1100111:wb_sel=2'b01;
    7'b0000011:wb_sel=2'b10;
    7'b0110111:wb_sel=2'b11;
    default:wb_sel=2'b00;
    endcase
end
always @(*)
begin
    if(opcode==7'b1101111)
    jal=1;
    else
    jal=0;
    if(opcode==7'b1100111)
    jalr=1;
    else
    jalr=0;
end
always@(*)
begin
    case(type)
    6'b000001,
    6'b000010,
    6'b100000,
    6'b010000:
    begin
    if(inst[11:7]!=5'h0)    
    wb_en=1;
    else
    wb_en=0;
    end
    default:wb_en=0;
    endcase
end
always @(*) begin
    case(type)
    6'b000001,
    6'b000010,
    6'b001000:alu_op1_sel=0;
    default:alu_op1_sel=1;
    endcase
end
always @(*) begin
    case(type)
    6'b000001:alu_op2_sel=0;
    default:alu_op2_sel=1;
endcase
end
always @(*) begin
    case(type)
    6'b001000:mem_we=1;
    default:mem_we=0;
endcase
end
always @(*) begin
    alu_ctrl=4'h0;
end
endmodule