# Author: 2023_COD_TA
# Last_edit: 20230503
# ============================== ��ˮ�� CPU ��ȷ�Բ��Գ��� ==============================
# ������Ϊֻ���ڿ���ð�յĲ���
# ��Ҫ��ͨ����simple test�Ļ����Ͻ���
# ָʾ�Ĵ��� Ϊ x25 �� x26 �Ĵ���
# ���������к� x26 ��ֵΪ 0xffffffff ������FAIL����ʱ x25 ָʾ��һ��δͨ���Ĳ���
# ���������к� x26 ��ֵΪ 1������ȫ������ͨ��
# !!!!!!!!!!!!!!!! �벻Ҫ�޸ı����Գ���Ĵ��� !!!!!!!!!!!!!!!!!!!!!!!
# ======================================================================================

.text
# CTRL 1 B unjump
	addi x25, x0, 1
	addi x1, x0, 1
	addi x2, x0, 2
	addi x3, x0, -1
	addi x4, x0, -2
	beq x1, x2, FAIL
	beq x1, x3, FAIL
	blt x2, x1, FAIL
	blt x3, x4, FAIL

# CTRL 2 B jump
	addi x25, x0, 2
	beq x0, x0, L1
FAIL:	
	addi x26, x0, -1
	beq x0, x0, FAIL
L1:	
	blt x4, x3, L2
	beq x0, x0, FAIL

# CTRL 3 jal
# ����ѡ��1���˲��Կ��Լ����ת���ȼ��趨�Ƿ���ȷ
L2:	addi x25, x0, 3
	jal x1, L3
	beq x0, x0, FAIL
L3:	auipc x2, 0
	addi x31, x0, 0
	addi x1, x1, 4
	blt x1, x2, FAIL
	blt x2, x1, FAIL

# CTRL 4 jalr
	addi x25, x0, 4
	auipc x2, 0
	addi x31, x0, 0
	jalr x1, 20(x2)
	beq x0, x0, FAIL
	jal x3, L4
	beq x0, x0, FAIL
L4:	addi x4, x3, -8
	blt x4, x1, FAIL
	blt x1, x4, FAIL
	
WIN:	
	addi x26, x0, 1
	beq x0, x0, WIN
