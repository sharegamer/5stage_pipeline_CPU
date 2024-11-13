`timescale 1ns / 1ps

/* 
 *   Author: YOU
 *   Last update: 2023.04.20
 */

module CPU(
    input clk, 
    input rst,

    // MEM And MMIO Data BUS
    output [31:0] im_addr,      // Instruction address (The same as current PC)
    input [31:0] im_dout,       // Instruction data (Current instruction)
    output [31:0] mem_addr,     // Memory read/write address
    output mem_we,              // Memory writing enable		            
    output [31:0] mem_din,      // Data ready to write to memory
    input [31:0] mem_dout,	    // Data read from memory

    // Debug BUS with PDU
    output [31:0] current_pc, 	        // Current_pc, pc_out
    output [31:0] next_pc,              // Next_pc, pc_in    
    input [31:0] cpu_check_addr,	    // Check current datapath state (code)
    output reg [31:0] cpu_check_data    // Current datapath state data
);
    
    
    // Write your CPU here!
    // You might need to write these modules:
    //      ALU、RF、Control、Add(Or just add-mode ALU)、And(Or just and-mode ALU)、PCReg、Imm、Branch、Mux、...
    wire [31:0] inst_if,dm_dout;
    assign inst_if=im_dout;
    assign dm_dout=mem_dout;
    wire [31:0] pc_cur_if,pc_add4_if,pc_next;
    wire [31:0]rf_rd0_raw_id,rf_rd1_raw_id,rf_rd_dbg_id,imm_id;
    wire rf_re0_id,rf_re1_id,rf_we_id,alu_src1_sel_id,alu_src2_sel_id,jal_id,jalr_id,dm_we_id,stall_if;
    wire [1:0] rf_wd_sel_id,br_type_id;
    wire [2:0] imm_type_id;
    wire [3:0] alu_func_id;
    wire [31:0] pc_cur_id,inst_id,pc_add4_id;
    wire [4:0] rf_ra0_id,rf_ra1_id,rf_wa_id;
    wire flush_id,stall_id;
    wire flush_ex,stall_ex,rf_re0_ex,rf_re1_ex,rf_we_ex,alu_src1_sel_ex,alu_src2_sel_ex,jal_ex,jalr_ex,dm_we_ex,br_ex,rf_rd0_fe,rf_rd1_fe;
    wire [31:0] pc_cur_ex,inst_ex,rf_rd0_raw_ex,rf_rd1_raw_ex,imm_ex,pc_add4_ex,alu_ans_ex,pc_jalr_ex,rf_rd0_ex,alu_src1_ex,rf_rd1_ex,alu_src2_ex,rf_rd0_fd,rf_rd1_fd;
    wire [1:0] rf_wd_sel_ex,br_type_ex,pc_sel_ex;
    wire [2:0] imm_type_ex;
    wire [3:0] alu_func_ex;
    wire [4:0] rf_ra0_ex,rf_ra1_ex,rf_wa_ex;
    wire [31:0] pc_cur_mem,inst_mem,rf_rd0_raw_mem,rf_rd1_raw_mem,rf_rd0_mem,rf_rd1_mem,imm_mem,alu_src1_mem,alu_src2_mem,alu_ans_mem,pc_add4_mem,pc_br_mem,pc_jal_mem,pc_jalr_mem,pc_next_mem,dm_addr_mem,dm_din_mem;
    wire [4:0] rf_ra0_mem,rf_ra1_mem,rf_wa_mem;
    wire [3:0] alu_func_mem;
    wire [1:0] rf_wd_sel_mem,br_type_mem,pc_sel_mem;
    wire [2:0] imm_type_mem;
    wire rf_re0_mem,rf_re1_mem,rf_we_mem,alu_src1_sel_mem,alu_src2_sel_mem,jal_mem,jalr_mem,br_mem,dm_we_mem;
    assign im_addr=pc_cur_if;
    assign mem_addr=alu_ans_mem;
    assign mem_din=dm_din_mem;
    assign mem_we=dm_we_mem;
    assign current_pc=pc_cur_if;
    assign next_pc=pc_next;
    wire flush_mem;
    wire [31:0] pc_cur_wb,inst_wb,rf_rd0_raw_wb,rf_rd1_raw_wb,rf_rd0_wb,rf_rd1_wb,imm_wb,alu_src1_wb,alu_src2_wb,alu_ans_wb,pc_add4_wb,pc_br_wb,pc_jal_wb,pc_jalr_wb,pc_next_wb,dm_addr_wb,dm_din_wb,dm_dout_wb;
    wire [4:0] rf_ra0_wb,rf_ra1_wb,rf_wa_wb;
    wire [3:0] alu_func_wb;
    wire [2:0] imm_type_wb;
    wire [1:0] rf_re0_wb,rf_re1_wb,rf_wd_sel_wb,br_type_wb,pc_sel_wb;
    wire rf_we_wb,alu_src1_sel_wb,alu_src2_sel_wb,jal_wb,jalr_wb,br_wb,dm_we_wb;
    ADD add(pc_cur_if,32'h4,pc_add4_if);
    PC pc(.clk(clk),.stall(stall_if),.rst(rst),.pc_next(pc_next),.pc_cur(pc_cur_if));
    SEG_REG seg_reg_if_id(.clk(clk),.flush(flush_id),.stall(stall_id),.pc_cur(pc_cur_if),.inst(inst_if),.rf_ra0(inst_if[19:15]),.rf_ra1(inst_if[24:20]),.rf_re0(1'h0),.rf_re1(1'h0),.rf_rd0_raw(32'h0),.rf_rd1_raw(32'h0),.rf_rd0(32'h0),.rf_rd1(32'h0),.rf_wa(inst_if[11:7]),.rf_wd_sel(2'h0),.rf_we(1'h0),.imm_type(3'h0),.imm(32'h0),.alu_src1_sel(1'h0),.alu_src2_sel(1'h0),.alu_src1(32'h0),.alu_src2(32'h0),.alu_func(4'h0),.alu_ans(32'h0),.pc_add4(pc_add4_if),.pc_br(32'h0),.pc_jal(32'h0),.pc_jalr(32'h0),.jal(1'h0),.jalr(1'h0),.br_type(2'h0),.br(1'h0),.pc_sel(2'h0),.pc_next(32'h0),.dm_addr(32'h0),.dm_din(32'h0),.dm_dout(32'h0),.dm_we(1'h0),.pc_cur_out(pc_cur_id),.inst_out(inst_id),.rf_ra0_out(rf_ra0_id),.rf_ra1_out(rf_ra1_id),.rf_re0_out(),.rf_re1_out(),.rf_rd0_raw_out(),.rf_rd1_raw_out(),.rf_rd0_out(),.rf_rd1_out(),.rf_wa_out(rf_wa_id),.rf_wd_sel_out(),.rf_we_out(),.imm_type_out(),.imm_out(),.alu_src1_sel_out(),.alu_src2_sel_out(),.alu_src1_out(),.alu_src2_out(),.alu_func_out(),.alu_ans_out(),.pc_add4_out(pc_add4_id),.pc_br_out(),.pc_jal_out(),.pc_jalr_out(),.jal_out(),.jalr_out(),.br_type_out(),.br_out(),.pc_sel_out(),.pc_next_out(),.dm_addr_out(),.dm_din_out(),.dm_dout_out(),.dm_we_out());
    SEG_REG seg_reg_id_ex(.clk(clk),.flush(flush_ex),.stall(stall_ex),.pc_cur(pc_cur_id),.inst(inst_id),.rf_ra0(rf_ra0_id),.rf_ra1(rf_ra1_id),.rf_re0(rf_re0_id),.rf_re1(rf_re1_id),.rf_rd0_raw(rf_rd0_raw_id),.rf_rd1_raw(rf_rd1_raw_id),.rf_rd0(32'h0),.rf_rd1(32'h0),.rf_wa(rf_wa_id),.rf_wd_sel(rf_wd_sel_id),.rf_we(rf_we_id),.imm_type(imm_type_id),.imm(imm_id),.alu_src1_sel(alu_src1_sel_id),.alu_src2_sel(alu_src2_sel_id),.alu_src1(32'h0),.alu_src2(32'h0),.alu_func(alu_func_id),.alu_ans(32'h0),.pc_add4(pc_add4_id),.pc_br(32'h0),.pc_jal(32'h0),.pc_jalr(32'h0),.jal(jal_id),.jalr(jalr_id),.br_type(br_type_id),.br(1'h0),.pc_sel(2'h0),.pc_next(32'h0),.dm_addr(32'h0),.dm_din(32'h0),.dm_dout(32'h0),.dm_we(dm_we_id),.pc_cur_out(pc_cur_ex),.inst_out(inst_ex),.rf_ra0_out(rf_ra0_ex),.rf_ra1_out(rf_ra1_ex),.rf_re0_out(rf_re0_ex),.rf_re1_out(rf_re1_ex),.rf_rd0_raw_out(rf_rd0_raw_ex),.rf_rd1_raw_out(rf_rd1_raw_ex),.rf_rd0_out(),.rf_rd1_out(),.rf_wa_out(rf_wa_ex),.rf_wd_sel_out(rf_wd_sel_ex),.rf_we_out(rf_we_ex),.imm_type_out(imm_type_ex),.imm_out(imm_ex),.alu_src1_sel_out(alu_src1_sel_ex),.alu_src2_sel_out(alu_src2_sel_ex),.alu_src1_out(),.alu_src2_out(),.alu_func_out(alu_func_ex),.alu_ans_out(),.pc_add4_out(pc_add4_ex),.pc_br_out(),.pc_jal_out(),.pc_jalr_out(),.jal_out(jal_ex),.jalr_out(jalr_ex),.br_type_out(br_type_ex),.br_out(),.pc_sel_out(),.pc_next_out(),.dm_addr_out(),.dm_din_out(),.dm_dout_out(),.dm_we_out(dm_we_ex));
    RF rf(.ra0(rf_ra0_id),.ra1(rf_ra1_id),.wa(rf_wa_wb),.wd(rf_wd_wb),.ra_dbg(cpu_check_addr[4:0]),.we(rf_we_wb),.clk(clk),.rd0(rf_rd0_raw_id),.rd1(rf_rd1_raw_id),.rd_dbg(rf_rd_dbg_id));
    IMM imm(inst_id,imm_type_id,imm_id);
    CTRL ctrl(inst_id,rf_re0_id,rf_re1_id,jal_id,jalr_id,br_type_id,rf_we_id,rf_wd_sel_id,alu_src1_sel_id,alu_src2_sel_id,alu_func_id,imm_type_id,dm_we_id);
    AND and(32'hFFFFFFFE,alu_ans_ex,pc_jalr_ex);
    Mux2 alu_sel1(rf_rd0_ex,pc_cur_ex,alu_src1_sel_ex,alu_src1_ex);
    Mux2 alu_sel2(rf_rd1_ex,imm_ex,alu_src2_sel_ex,alu_src2_ex);
    ALU alu(alu_src1_ex,alu_src2_ex,alu_func_ex,alu_ans_ex);
    Branch branch(rf_rd0_ex,rf_rd1_ex,br_type_ex,br_ex);
    Encoder pc_sel_gen(jal_ex,jalr_ex,br_ex,pc_sel_ex);
    Mux2 rf_rd0_fwd(rf_rd0_raw_ex,rf_rd0_fd,rf_rd0_fe,rf_rd0_ex);
    Mux2 rf_rd1_fwd(rf_rd1_raw_ex,rf_rd1_fd,rf_rd1_fe,rf_rd1_ex);
    SEG_REG seg_reg_ex_mem(.clk(clk),.flush(flush_mem),.stall(1'h0),.pc_cur(pc_cur_ex),.inst(inst_ex),.rf_ra0(rf_ra0_ex),.rf_ra1(rf_ra1_ex),.rf_re0(rf_re0_ex),.rf_re1(rf_re1_ex),.rf_rd0_raw(rf_rd0_raw_ex),.rf_rd1_raw(rf_rd1_raw_ex),.rf_rd0(rf_rd0_ex),.rf_rd1(rf_rd1_ex),.rf_wa(rf_wa_ex),.rf_wd_sel(rf_wd_sel_ex),.rf_we(rf_we_ex),.imm_type(imm_type_ex),.imm(imm_ex),.alu_src1_sel(alu_src1_sel_ex),.alu_src2_sel(alu_src2_sel_ex),.alu_src1(alu_src1_ex),.alu_src2(alu_src2_ex),.alu_func(alu_func_ex),.alu_ans(alu_ans_ex),.pc_add4(pc_add4_ex),.pc_br(alu_ans_ex),.pc_jal(alu_ans_ex),.pc_jalr(pc_jalr_ex),.jal(jal_ex),.jalr(jalr_ex),.br_type(br_type_ex),.br(br_ex),.pc_sel(pc_sel_ex),.pc_next(pc_next),.dm_addr(alu_ans_ex),.dm_din(rf_rd1_ex),.dm_dout(32'h0),.dm_we(dm_we_ex),.pc_cur_out(pc_cur_mem),.inst_out(inst_mem),.rf_ra0_out(rf_ra0_mem),.rf_ra1_out(rf_ra1_mem),.rf_re0_out(rf_re0_mem),.rf_re1_out(rf_re1_mem),.rf_rd0_raw_out(rf_rd0_raw_mem),.rf_rd1_raw_out(rf_rd1_raw_mem),.rf_rd0_out(rf_rd0_mem),.rf_rd1_out(rf_rd1_mem),.rf_wa_out(rf_wa_mem),.rf_wd_sel_out(rf_wd_sel_mem),.rf_we_out(rf_we_mem),.imm_type_out(imm_type_mem),.imm_out(imm_mem),.alu_src1_sel_out(alu_src1_sel_mem),.alu_src2_sel_out(alu_src2_sel_mem),.alu_src1_out(alu_src1_mem),.alu_src2_out(alu_src2_mem),.alu_func_out(alu_func_mem),.alu_ans_out(alu_ans_mem),.pc_add4_out(pc_add4_mem),.pc_br_out(pc_br_mem),.pc_jal_out(pc_jal_mem),.pc_jalr_out(pc_jalr_mem),.jal_out(jal_mem),.jalr_out(jalr_mem),.br_type_out(br_type_mem),.br_out(br_mem),.pc_sel_out(pc_sel_mem),.pc_next_out(pc_next_mem),.dm_addr_out(dm_addr_mem),.dm_din_out(dm_din_mem),.dm_dout_out(),.dm_we_out(dm_we_mem));
    SEG_REG seg_reg_mem_wb(.clk(clk),.flush(1'h0),.stall(1'h0),.pc_cur(pc_cur_mem),.inst(inst_mem),.rf_ra0(rf_ra0_mem),.rf_ra1(rf_ra1_mem),.rf_re0(rf_re0_mem),.rf_re1(rf_re1_mem),.rf_rd0_raw(rf_rd0_raw_mem),.rf_rd1_raw(rf_rd1_raw_mem),.rf_rd0(rf_rd0_mem),.rf_rd1(rf_rd1_mem),.rf_wa(rf_wa_mem),.rf_wd_sel(rf_wd_sel_mem),.rf_we(rf_we_mem),.imm_type(imm_type_mem),.imm(imm_mem),.alu_src1_sel(alu_src1_sel_mem),.alu_src2_sel(alu_src2_sel_mem),.alu_src1(alu_src1_mem),.alu_src2(alu_src2_mem),.alu_func(alu_func_mem),.alu_ans(alu_ans_mem),.pc_add4(pc_add4_mem),.pc_br(pc_br_mem),.pc_jal(pc_jal_mem),.pc_jalr(pc_jalr_mem),.jal(jal_mem),.jalr(jalr_mem),.br_type(br_type_mem),.br(br_mem),.pc_sel(pc_sel_mem),.pc_next(pc_next_mem),.dm_addr(dm_addr_mem),.dm_din(dm_din_mem),.dm_dout(dm_dout),.dm_we(dm_we_mem),.pc_cur_out(pc_cur_wb),.inst_out(inst_wb),.rf_ra0_out(rf_ra0_wb),.rf_ra1_out(rf_ra1_wb),.rf_re0_out(rf_re0_wb),.rf_re1_out(rf_re1_wb),.rf_rd0_raw_out(rf_rd0_raw_wb),.rf_rd1_raw_out(rf_rd1_raw_wb),.rf_rd0_out(rf_rd0_wb),.rf_rd1_out(rf_rd1_wb),.rf_wa_out(rf_wa_wb),.rf_wd_sel_out(rf_wd_sel_wb),.rf_we_out(rf_we_wb),.imm_type_out(imm_type_wb),.imm_out(imm_wb),.alu_src1_sel_out(alu_src1_sel_wb),.alu_src2_sel_out(alu_src2_sel_wb),.alu_src1_out(alu_src1_wb),.alu_src2_out(alu_src2_wb),.alu_func_out(alu_func_wb),.alu_ans_out(alu_ans_wb),.pc_add4_out(pc_add4_wb),.pc_br_out(pc_br_wb),.pc_jal_out(pc_jal_wb),.pc_jalr_out(pc_jalr_wb),.jal_out(jal_wb),.jalr_out(jalr_wb),.br_type_out(br_type_wb),.br_out(br_wb),.pc_sel_out(pc_sel_wb),.pc_next_out(pc_next_wb),.dm_addr_out(dm_addr_wb),.dm_din_out(dm_din_wb),.dm_dout_out(dm_dout_wb),.dm_we_out(dm_we_wb));
    Mux4 reg_write_sel(alu_ans_wb,pc_add4_wb,dm_dout_wb,imm_wb,rf_wd_sel_wb,rf_wd_wb);
    Mux4 npc_sel(pc_add4_if,pc_jalr_ex,alu_ans_ex,alu_ans_ex,pc_sel_ex,pc_next);
    Hazard hazard(rf_ra0_ex,rf_ra1_ex,rf_re0_ex,rf_re1_ex,rf_wa_mem,rf_we_mem,rf_wd_sel_mem,alu_ans_mem,pc_add4_mem,imm_mem,rf_wa_wb,rf_we_wb,rf_wd_wb,pc_sel_ex,rf_rd0_fe,rf_rd1_fe,rf_rd0_fd,rf_rd1_fd,stall_if,stall_id,stall_ex,flush_id,flush_ex,flush_mem);
    wire [31:0]check_data_if,check_data_id,check_data_ex,check_data_mem,check_data_wb,check_data_hzd,check_data;
    Check_Data_Sel checkif(pc_cur_if,inst_if,inst_if[19:15],inst_if[24:20],1'h0,1'h0,32'h0,32'h0,32'h0,32'h0,inst_if[11:7],2'h0,32'h0,1'h0,32'h0,32'h0,32'h0,4'h0,32'h0,pc_add4_if,32'h0,32'h0,32'h0,2'h0,32'h0,32'h0,32'h0,32'h0,1'h0,cpu_check_addr[4:0],check_data_if);
    Check_Data_Sel checkid(pc_cur_id,inst_id,rf_ra0_id,rf_ra1_id,rf_re0_id,rf_re1_id,rf_rd0_raw_id,rf_rd1_raw_id,32'h0,32'h0,rf_wa_id,rf_wd_sel_id,32'h0,rf_we_id,imm_id,32'h0,32'h0,alu_func_id,32'h0,pc_add4_id,32'h0,32'h0,32'h0,2'h0,32'h0,32'h0,32'h0,32'h0,dm_we_id,cpu_check_addr[4:0],check_data_id);
    Check_Data_Sel checkex(pc_cur_ex,inst_ex,rf_ra0_ex,rf_ra1_ex,rf_re0_ex,rf_re1_ex,rf_rd0_raw_ex,rf_rd1_raw_ex,rf_rd0_ex,rf_rd1_ex,rf_wa_ex,rf_wd_sel_ex,32'h0,rf_we_ex,imm_ex,alu_src1_ex,alu_src2_ex,alu_func_ex,alu_ans_ex,pc_add4_ex,alu_ans_ex,alu_ans_ex,pc_jalr_ex,pc_sel_ex,pc_next,alu_ans_ex,32'h0,32'h0,dm_we_ex,cpu_check_addr[4:0],check_data_ex);
    Check_Data_Sel checkmem(pc_cur_mem,inst_mem,rf_ra0_mem,rf_ra1_mem,rf_re0_mem,rf_re1_mem,rf_rd0_raw_mem,rf_rd1_raw_mem,rf_rd0_mem,rf_rd1_mem,rf_wa_mem,rf_wd_sel_mem,32'h0,rf_we_mem,imm_mem,alu_src1_mem,alu_src2_mem,alu_func_mem,alu_ans_mem,pc_add4_mem,pc_br_mem,pc_jal_mem,pc_jalr_mem,pc_sel_mem,pc_next_mem,dm_addr_mem,dm_din_mem,dm_dout,dm_we_mem,cpu_check_addr[4:0],check_data_mem);
    Check_Data_Sel checkwb(pc_cur_wb,inst_wb,rf_ra0_wb,rf_ra1_wb,rf_re0_wb,rf_re1_wb,rf_rd0_raw_wb,rf_rd1_raw_wb,rf_rd0_wb,rf_rd1_wb,rf_wa_wb,rf_wd_sel_wb,rf_wd_wb,rf_we_wb,imm_wb,alu_src1_wb,alu_src2_wb,alu_func_wb,alu_ans_wb,pc_add4_wb,pc_br_wb,pc_jal_wb,pc_jalr_wb,pc_sel_wb,pc_next_wb,dm_addr_wb,dm_din_wb,dm_dout_wb,dm_we_wb,cpu_check_addr[4:0],check_data_wb);
    Check_Data_Sel_HZD checkhzd(rf_ra0_ex,rf_ra1_ex,rf_re0_ex,rf_re1_ex,rf_wa_mem,rf_we_mem,rf_wd_sel_mem,alu_ans_mem,pc_add4_mem,imm_mem,rf_wa_wb,rf_we_wb,rf_wd_wb,rf_rd0_fe,rf_rd1_fe,rf_rd0_fd,rf_rd1_fd,stall_if,stall_id,stall_ex,32'h0,flush_id,flush_ex,flush_mem,pc_sel_ex,cpu_check_addr[4:0],check_data_hzd);
    Check_Data_SEG_Sel checkseg(check_data_if,check_data_id,check_data_ex,check_data_mem,check_data_wb,check_data_hzd,cpu_check_addr[7:5],check_data);
    Mux2 check_data_sel(check_data,rf_rd_dbg_id,cpu_check_addr[12],cpu_check_data);



endmodule