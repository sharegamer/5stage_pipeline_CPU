module Hazard (
    input [4:0]rf_ra0_ex,
    input [4:0]rf_ra1_ex,
    input rf_re0_ex,
    input rf_re1_ex,
    input [4:0]rf_wa_mem,
    input rf_we_mem,
    input [1:0]rf_wd_sel_mem,
    input [31:0]alu_ans_mem,
    input [31:0]pc_add4_mem,
    input [31:0]imm_mem,
    input [4:0]rf_wa_wb,
    input rf_we_wb,
    input [31:0]rf_wd_wb,
    input [1:0]pc_sel_ex,
    output reg rf_rd0_fe,
    output reg rf_rd1_fe,
    output reg [31:0] rf_rd0_fd,
    output reg [31:0] rf_rd1_fd,
    output reg stall_if,
    output reg stall_id,
    output reg stall_ex,
    output reg flush_id,
    output reg flush_ex,
    output reg flush_mem
);
    always @(*) begin
        if(rf_re0_ex==1&&((rf_ra0_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem!=2'b10)||(rf_ra0_ex==rf_wa_wb&&rf_we_wb==1)))
            rf_rd0_fe=1;
        else
            rf_rd0_fe=0;
        if(rf_re1_ex==1&&((rf_ra1_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem!=2'b10)||(rf_ra1_ex==rf_wa_wb&&rf_we_wb==1)))
            rf_rd1_fe=1;
        else
            rf_rd1_fe=0;
        if(rf_re0_ex==1&&(rf_ra0_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem!=2'b10))
        begin
            case(rf_wd_sel_mem)
            2'b00:rf_rd0_fd=alu_ans_mem;
            2'b01:rf_rd0_fd=pc_add4_mem;
            2'b11:rf_rd0_fd=imm_mem;
            endcase
        end
        else if(rf_we_wb)
        begin
            rf_rd0_fd=rf_wd_wb;
        end
        if(rf_re1_ex==1&&(rf_ra1_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem!=2'b10))
        begin
            case(rf_wd_sel_mem)
            2'b00:rf_rd1_fd=alu_ans_mem;
            2'b01:rf_rd1_fd=pc_add4_mem;
            2'b11:rf_rd1_fd=imm_mem;
            endcase
        end
        if((rf_re0_ex==1&&rf_ra0_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem==2'b10)||(rf_re1_ex==1&&rf_ra1_ex==rf_wa_mem&&rf_we_mem==1&&rf_wd_sel_mem==2'b10))
        begin
            stall_ex=1;
            stall_id=1;
            stall_if=1;
            flush_mem=1;
        end
        else
        begin
            stall_if=0;
            stall_id=0;
            stall_ex=0;
            flush_mem=0;
        end
        if(pc_sel_ex!=2'b00)
        begin
            flush_id=1;
            flush_ex=1;
        end
        else
        begin
            flush_id=0;
            flush_ex=0;
        end

            

        
    end
endmodule
