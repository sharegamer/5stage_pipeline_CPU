module SEG_REG (
    input clk,
    input flush,
    input stall,
    input [31:0]pc_cur,
    input [31:0]inst, 
    input [4:0]rf_ra0,
    input [4:0]rf_ra1,
    input rf_re0,
    input rf_re1,
    input [31:0]rf_rd0_raw,
    input [31:0]rf_rd1_raw,
    input [31:0]rf_rd0,
    input [31:0]rf_rd1,
    input [4:0]rf_wa,
    input [1:0]rf_wd_sel,
    input rf_we,
    input [2:0]imm_type,
    input [31:0]imm,
    input alu_src1_sel,
    input alu_src2_sel,
    input [31:0]alu_src1,
    input [31:0]alu_src2,
    input [3:0]alu_func,
    input [31:0]alu_ans,
    input [31:0]pc_add4,
    input [31:0]pc_br,
    input [31:0]pc_jal,
    input [31:0]pc_jalr,
    input jal,
    input jalr,
    input [1:0]br_type,
    input br,
    input [1:0]pc_sel,
    input [31:0]pc_next,
    input [31:0]dm_addr,
    input [31:0]dm_din,
    input [31:0]dm_dout,
    input dm_we,
    output reg [31:0]pc_cur_out,
    output reg [31:0]inst_out, 
    output reg [4:0]rf_ra0_out,
    output reg [4:0]rf_ra1_out,
    output reg rf_re0_out,
    output reg rf_re1_out,
    output reg [31:0]rf_rd0_raw_out,
    output reg [31:0]rf_rd1_raw_out,
    output reg [31:0]rf_rd0_out,
    output reg [31:0]rf_rd1_out,
    output reg [4:0]rf_wa_out,
    output reg [1:0]rf_wd_sel_out,
    output reg rf_we_out,
    output reg [2:0]imm_type_out,
    output reg [31:0]imm_out,
    output reg alu_src1_sel_out,
    output reg alu_src2_sel_out,
    output reg [31:0]alu_src1_out,
    output reg [31:0]alu_src2_out,
    output reg [3:0]alu_func_out,
    output reg [31:0]alu_ans_out,
    output reg [31:0]pc_add4_out,
    output reg [31:0]pc_br_out,
    output reg [31:0]pc_jal_out,
    output reg [31:0]pc_jalr_out,
    output reg jal_out,
    output reg jalr_out,
    output reg [1:0]br_type_out,
    output reg br_out,
    output reg [1:0]pc_sel_out,
    output reg [31:0]pc_next_out,
    output reg [31:0]dm_addr_out,
    output reg [31:0]dm_din_out,
    output reg [31:0]dm_dout_out,
    output reg dm_we_out,
        
);
always @(posedge clk) begin
    if(flush)
    begin
     pc_cur_out<=0;
     inst_out<=0; 
     rf_ra0_out<=0;
     rf_ra1_out<=0;
     rf_re0_out<=0;
     rf_re1_out<=0;
     rf_rd0_raw_out<=0;
     rf_rd1_raw_out<=0;
     rf_rd0_out<=0;
     rf_rd1_out<=0;
     rf_wa_out<=0;
     rf_wd_sel_out<=0;
     rf_we_out<=0;
     imm_type_out<=0;
     imm_out<=0;
     alu_src1_sel_out<=0;
     alu_src2_sel_out<=0;
     alu_src1_out<=0;
     alu_src2_out<=0;
     alu_func_out<=0;
     alu_ans_out<=0;
     pc_add4_out<=0;
     pc_br_out<=0;
     pc_jal_out<=0;
     pc_jalr_out<=0;
     jal_in_out<=0;
     jalr_out<=0;
     br_type_out<=0;
     br_out<=0;
     pc_sel_out<=0;
     pc_next_out<=0;
     dm_addr_out<=0;
     dm_din_out<=0;
     dm_dout_out<=0;
     dm_we_out<=0;
    end
    else if(stall==0)
    begin
     pc_cur_out<=pc_cur;
     inst_out<=inst; 
     rf_ra0_out<=rf_ra0;
     rf_ra1_out<=rf_ra1;
     rf_re0_out<=rf_re0;
     rf_re1_out<=rf_re1;
     rf_rd0_raw_out<=rf_rd0_raw;
     rf_rd1_raw_out<=rf_rd1_raw;
     rf_rd0_out<=rf_rd0;
     rf_rd1_out<=rf_rd1;
     rf_wa_out<=rf_wa;
     rf_wd_sel_out<=rf_wd_sel;
     rf_we_out<=rf_we;
     imm_type_out<=imm_type;
     imm_out<=imm;
     alu_src1_sel_out<=alu_src1_sel;
     alu_src2_sel_out<=alu_src2_sel;
     alu_src1_out<=alu_src1;
     alu_src2_out<=alu_src2;
     alu_func_out<=alu_func;
     alu_ans_out<=alu_ans;
     pc_add4_out<=pc_add4;
     pc_br_out<=pc_br;
     pc_jal_out<=pc_jal;
     pc_jalr_out<=pc_jalr;
     jal_in_out<=jal_in;
     jalr_out<=jalr;
     br_type_out<=br_type;
     br_out<=br;
     pc_sel_out<=pc_sel;
     pc_next_out<=pc_next;
     dm_addr_out<=dm_addr;
     dm_din_out<=dm_din;
     dm_dout_out<=dm_dout;
     dm_we_out<=dm_we;
    end

    
end
    
endmodule