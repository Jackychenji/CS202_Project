.data

.text
main:
    addi $29, $zero, 0x10000000
    lui $28, 0xFFFF			
    ori $28, $28, 0xFC00
    lui $s6, 0x0000
    ori $s6, $s6, 0xFF00 #sign extend
    lui $s5, 0x015E
    ori $s5, $s5,0xF3C0	
    lui $s4, 0xFFFF
    ori $s4, $s4, 0xFFFF
    lui $s3, 0x0000
    ori $s3, $s3, 0x00FF
begin_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, begin_1
begin_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, begin_2
    lw $a3, 0x72($28) #a3��ŵ��ǲ�������
    sw $a3, 0x62($28)
    sw $zero, 0x63($28)
    xor $s2, $s2, $s2
    beq $a3, $s2, tb000_1 #2power
    addi $s2, $s2, 1
    beq $a3, $s2, tb001_1 #odd
    addi $s2, $s2, 1
    beq $a3, $s2, tb010_1 #or
    addi $s2, $s2, 1
    beq $a3, $s2, tb011_1 #xor
    addi $s2, $s2, 1
    beq $a3, $s2, tb100_1
    addi $s2, $s2, 1
    beq $a3, $s2, tb101_1
    addi $s2, $s2, 1
    beq $a3, $s2, tb110_1
    addi $s2, $s2, 1
    beq $a3, $s2, tb111_1

####################################
tb000_1:
    lw $s7, 0x73($28) #s7��ʾʹ���źţ����°�ť����ʼ����
    bne $s7, $zero, tb000_1
tb000_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb000_2
    lw $a0, 0x70($28)#16λ����a0����
    sw $a0, 0x61($28)
    xor $v0, $v0, $v0
    addi $t7, $zero, 128
    slt $t5, $a0, $t7
    beq $t5, $zero, t000_fin2 #a0<0
    beq $a0, $zero, t000_fin1 #a0==0 or a0>0

tb000_loop1: 
    add $v0, $v0, $a0
    addi $a0, $a0, -1
    beq $a0, $zero, t000_fin1
    j tb000_loop1

t000_fin1:
    sw $v0, 0x60($28)
    j begin_1

t000_fin2:
    lui $t2, 0x0010         # ��0x00100000�ĸ�16λ���ص�$t0�Ĵ�����
    ori $t2, $t2, 0x0000    # ��0x00100000�ĵ�16λ��$t0�Ĵ����е�ֵ����OR����
    addi $t3, $zero, 16
    add $t4, $zero, $zero

tb000_loop2:
    andi $v0, $t4, 1
    sw  $v0, 0x60($28)
    add $t1, $zero, $zero
    addi $t4, $t4, 1
    beq $t3, $t4, begin_1

tb000_loop3:
    beq $t1, $t2, tb000_loop2
    addi $t1, $t1, 1
    j tb000_loop3

####################################
tb001_1:
    lw $s7, 0x73($28)  
    bne $s7, $zero, tb001_1
tb001_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb001_2
    lw $a0, 0x70($28)
    add $t2, $zero, $zero
    beq $a0, $zero, tb001_fin1
    add $t0, $zero, $zero
    
    # �ݹ����sum��������1��a���ۼӺ�
    addi $29, $29, -12    # ��ջ
    sw $ra, 0($29)        # ���淵�ص�ַ
    sw $a0, 4($29)        # �������a
    sw $t0, 8($29)        # ���淵��ֵ
    addi $t2, $t2, 1
    jal tb001_sum
    lw $t0, 8($29)        # �ָ�����ֵ
    lw $a0, 4($29)        # �ָ�����a
    lw $ra, 0($29)        # �ָ����ص�ַ
    addi $29, $29, 12     # ��ջ
    addi $t2, $t2, 1

tb001_fin1:
    sw $t2, 0x61($28)     #�������ջ������
    j begin_1

tb001_sum: 
    # ���a=1���򷵻�1
    addi $t1, $zero, 1
    beq $a0, $t1, tb001_return
    # ���򣬵ݹ����1��a-1���ۼӺͣ��ټ���a
    addi $a0, $a0, -1       # a-1��Ϊ�µĲ���
    addi $29, $29, -12      # ��ջ
    sw $ra, 0($29)          # ���淵�ص�ַ
    sw $a0, 4($29)          # �������a-1
    sw $t0, 8($29)          # ���淵��ֵ
    addi $t2, $t2, 1
    jal tb001_sum           # �ݹ����sum����
    lw $t0, 8($29)          # �ָ�����ֵ
    lw $a0, 4($29)          # �ָ�����a-1
    lw $ra, 0($29)          # �ָ����ص�ַ
    addi $29, $29, 12       # ��ջ
    add $t0, $t0, $a0       # ��a�ӵ������
    addi $t2, $t2, 1

tb001_return:
    jr $ra


####################################
tb010_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb010_1
tb010_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb010_2
    lw $a0, 0x70($28)
    beq $a0, $zero, tb010_fin1
    add $t0, $zero, $zero
 # �ݹ����sum��������1��a���ۼӺ�
    addi $29, $29, -12    # ��ջ
    sw $ra, 0($29)        # ���淵�ص�ַ
    sw $a0, 4($29)        # �������a
    sw $t0, 8($29)        # ���淵��ֵ
    sw $a0, 0x61($28)
    j tb010_loop1

tb010_next1:
    jal tb010_sum
    lw $t0, 8($29)        # �ָ�����ֵ
    lw $a0, 4($29)        # �ָ�����a
    lw $ra, 0($29)        # �ָ����ص�ַ
    addi $29, $29, 12     # ��ջ

tb010_fin1:
    j begin_1

tb010_loop1:
    # �ȴ�2-3��
    add $t3, $zero, $s5

tb010_delay1:
    addi $t3, $t3, -1
    beq $t3, $zero, tb010_next1
    j tb010_delay1

tb010_loop2:
    # �ȴ�2-3��
    add $t3, $zero, $s5

tb010_delay2:
    addi $t3, $t3, -1
    beq $t3, $zero, tb010_next2
    j tb010_delay2
 
tb010_sum: 
    # ���a=1���򷵻�1
    addi $t1, $zero, 1
    beq $a0, $t1, tb010_return
    # ���򣬵ݹ����1��a-1���ۼӺͣ��ټ���a
    addi $a0, $a0, -1       # a-1��Ϊ�µĲ���
    addi $29, $29, -12      # ��ջ
    sw $ra, 0($29)          # ���淵�ص�ַ
    sw $a0, 4($29)          # �������a-1
    sw $t0, 8($29)          # ���淵��ֵ
    sw $a0, 0x61($28)
    j tb010_loop2

tb010_next2:
    jal tb010_sum           # �ݹ����sum����
    lw $t0, 8($29)          # �ָ�����ֵ
    lw $a0, 4($29)          # �ָ�����a-1
    lw $ra, 0($29)          # �ָ����ص�ַ
    addi $29, $29, 12       # ��ջ
    add $t0, $t0, $a0       # ��a�ӵ������

tb010_return:
    jr $ra

####################################
tb011_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb011_1
tb011_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb011_2
    lw $a0, 0x70($28)
    beq $a0, $zero, tb011_fin1
    add $t0, $zero, $zero
 # �ݹ����sum��������1��a���ۼӺ�
    addi $29, $29, -12    # ��ջ
    sw $ra, 0($29)        # ���淵�ص�ַ
    sw $a0, 4($29)        # �������a
    sw $t0, 8($29)        # ���淵��ֵ
    jal tb011_sum
    lw $t0, 8($29)        # �ָ�����ֵ
    lw $a0, 4($29)        # �ָ�����a
    lw $ra, 0($29)        # �ָ����ص�ַ
    addi $29, $29, 12     # ��ջ
    sw $a0, 0x61($28)
    j tb011_loop1

tb011_fin1:
    j begin_1

tb011_loop1:
    # �ȴ�2-3��
    add $t3, $zero, $s5

tb011_delay1:
    addi $t3, $t3, -1
    beq $t3, $zero, tb011_fin1
    j tb011_delay1

tb011_loop2:
    # �ȴ�2-3��
    add $t3, $zero, $s5

tb011_delay2:
    addi $t3, $t3, -1
    beq $t3, $zero, tb011_return
    j tb011_delay2
 
tb011_sum: 
    # ���a=1���򷵻�1
    addi $t1, $zero, 1
    beq $a0, $t1, tb011_return
    # ���򣬵ݹ����1��a-1���ۼӺͣ��ټ���a
    addi $a0, $a0, -1       # a-1��Ϊ�µĲ���
    addi $29, $29, -12      # ��ջ
    sw $ra, 0($29)          # ���淵�ص�ַ
    sw $a0, 4($29)          # �������a-1
    sw $t0, 8($29)          # ���淵��ֵ
    jal tb011_sum           # �ݹ����sum����
    lw $t0, 8($29)          # �ָ�����ֵ
    lw $a0, 4($29)          # �ָ�����a-1
    lw $ra, 0($29)          # �ָ����ص�ַ
    addi $29, $29, 12       # ��ջ
    add $t0, $t0, $a0       # ��a�ӵ������
    sw $a0, 0x61($28)
    j tb011_loop2

tb011_return:
    jr $ra

####################################
tb100_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb100_1
tb100_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb100_2
    lw $v0, 0x70($28)
    addi $s0, $v0, 0#s0����a��ֵ
    sw $s0, 0x61($28)

tb100_inputb_1:
    lw $s7, 0x73($28) #s7��ʾʹ���źţ�������a�󣬰��°�ť��������Ҫ���°�ť��������ȡb
    bne $s7, $zero, tb100_inputb_1
tb100_inputb_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb100_inputb_2
    lw $v0, 0x70($28)
    addi $s1, $v0, 0#s1���b��ֵ
    sw $s1, 0x60($28)

tb100_show1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb100_show1

tb100_show2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb100_show2


    add $t5, $s1, $s0
    sw $t5, 0x61($28)

# ������
    addi $t8, $zero, 127
    addi $t9, $zero, 383
tb100_check1: #���s0����
    slt $t1, $t8, $s0
    beq $t1, $zero, tb100_check2
    j tb100_check3

tb100_check2: #s0Ϊ���������s1����
    slt $t2, $t8, $s1
    beq $t2, $zero, tb100_check4
    j tb100_no_overflow

tb100_check3: #s0Ϊ���������s1����
    slt $t2, $t8, $s1
    beq $t2, $zero, tb100_no_overflow
    j tb100_check5

tb100_check4: #��Ϊ�����������û�����
    slt $t4, $t8, $t5
    beq $t4, $zero, tb100_no_overflow
    j tb100_overflow

tb100_check5: #��Ϊ�����������û�����
    slt $t4, $t9, $t5
    beq $t4, $zero, tb100_overflow
    j tb100_no_overflow

tb100_no_overflow:
    addi $t3, $zero, 0
    sw $t3, 0x60($28)
    j begin_1

tb100_overflow:
    addi $t3, $zero, 1
    sw $t3, 0x60($28)
    j begin_1


####################################
tb101_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb101_1
tb101_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb101_2
    lw $v0, 0x70($28)
    addi $s0, $v0, 0#s0����a��ֵ
    sw $s0, 0x61($28)

tb101_inputb_1:
    lw $s7, 0x73($28) #s7��ʾʹ���źţ�������a�󣬰��°�ť��������Ҫ���°�ť��������ȡb
    bne $s7, $zero, tb101_inputb_1
tb101_inputb_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb101_inputb_2
    lw $v0, 0x70($28)
    addi $s1, $v0, 0#s1���b��ֵ
    sw $s1, 0x60($28)

tb101_show1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb101_show1

tb101_show2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb101_show2

    add $t6, $s1, $zero
    xor $t6, $t6, $s3
    addi $t6, $t6, 1
    add $t5, $s0, $t6
    sw $t5, 0x61($28)

# ������
    addi $t8, $zero, 127
    addi $t9, $zero, 128
tb101_check1: #���s0����
    slt $t1, $t8, $s0
    beq $t1, $zero, tb101_check2
    j tb101_check3

tb101_check2: #s0Ϊ���������s1����
    slt $t2, $t8, $s1
    beq $t2, $zero, tb101_no_overflow
    j tb101_check4

tb101_check3: #s0Ϊ���������s1����
    slt $t2, $t8, $s1
    beq $t2, $zero, tb101_check5
    j tb101_no_overflow

tb101_check4: # s0Ϊ������s1Ϊ���������û�����
    slt $t4, $t8, $t5
    beq $t4, $zero, tb101_no_overflow
    j tb101_overflow

tb101_check5: # s0Ϊ������s1Ϊ���������û�����
    xor $t5, $s0, $s3
    addi $t5, $t5, 1
    add $t5, $t5, $s1
    slt $t4, $t9, $t5
    beq $t4, $zero, tb101_no_overflow
    j tb101_overflow

tb101_no_overflow:
    addi $t3, $zero, 0
    sw $t3, 0x60($28)
    j begin_1

tb101_overflow:
    addi $t3, $zero, 1
    sw $t3, 0x60($28)
    j begin_1


####################################
tb110_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb110_1
tb110_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb110_2
    lw $v0, 0x70($28)
    addi $s0, $v0, 0#s0����a��ֵ
    sw $s0, 0x61($28)

tb110_inputb_1:
    lw $s7, 0x73($28) #s7��ʾʹ���źţ�������a�󣬰��°�ť��������Ҫ���°�ť��������ȡb
    bne $s7, $zero, tb110_inputb_1
tb110_inputb_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb110_inputb_2
    lw $v0, 0x70($28)
    addi $s1, $v0, 0#s1���b��ֵ
    sw $s1, 0x60($28)

tb110_show1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb110_show1

tb110_show2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb110_show2
    jal extend

    add $t4, $zero, $zero        # ������������ѭ��8��
    add $t2, $zero, $zero
    addi $t6, $zero, 1
    addi $t7, $zero, 8
    addi $t8, $s6, 127
    add $t9, $zero, $zero

tb110_check1: #���s0����
    slt $t9, $t8, $s0
    beq $t9, $zero, tb110_check2
    j tb110_check3

tb110_check2: #s0Ϊ���������s1����
    slt $t1, $t8, $s1
    beq $t1, $zero, tb110_mul1
    j tb110_mul2

tb110_check3: #s0Ϊ���������s1����
    slt $t1, $t8, $s1
    beq $t1, $zero, tb110_mul1
    j tb110_change

tb110_change:
    xor $s1, $s1, $s4
    addi $s1, $s1, 1
    xor $s0, $s0, $s4
    addi $s0, $s0, 1

tb110_mul1:
    andi $t5, $s1, 0x01  # ȡ�����������λ
    beq $t5, $zero, tb110_skip1     # ������λΪ0���������ӷ�����
    add $t2, $t2, $s0 

tb110_skip1:
    sll $s0, $s0, 1    # ��������1λ
    srl $s1, $s1, 1    # ����������1λ
    addi $t4, $t4, 1   # ��������1
    slt $t3, $t4, $t7   # ���������С��8�������ѭ��
    beq $t3, $t6, tb110_mul1

    add $s2, $zero, $t2
    sw $s2, 0x63($28)
    j begin_1

tb110_mul2:
    andi $t5, $s0, 0x01  # ȡ�����������λ
    beq $t5, $zero, tb110_skip2     # ������λΪ0���������ӷ�����
    add $t2, $t2, $s1  
tb110_skip2:
    sll $s1, $s1, 1    # ��������1λ
    srl $s0, $s0, 1    # ����������1λ
    addi $t4, $t4, 1   # ��������1
    slt $t3, $t4, $t7   # ���������С��8�������ѭ��
    beq $t3, $t6, tb110_mul2

    add $s2, $zero, $t2
    sw $s2, 0x63($28)
    j begin_1


####################################
tb111_1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb111_1
tb111_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb111_2
    lw $v0, 0x70($28)
    addi $s0, $v0, 0#s0����a��ֵ
    sw $s0, 0x61($28)

tb111_inputb_1:
    lw $s7, 0x73($28) #s7��ʾʹ���źţ�������a�󣬰��°�ť��������Ҫ���°�ť��������ȡb
    bne $s7, $zero, tb111_inputb_1
tb111_inputb_2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb111_inputb_2
    lw $v0, 0x70($28)
    addi $s1, $v0, 0#s1���b��ֵ
    sw $s1, 0x60($28)

tb111_show1:
    lw $s7, 0x73($28)
    bne $s7, $zero, tb111_show1

tb111_show2:
    lw $s7, 0x73($28)
    beq $s7, $zero, tb111_show2

    addi $t8, $zero, 1
    add $t3, $s0, $zero
    add $t0, $s1, $zero
    add $t9, $s1, $zero
    addi $t6, $zero, 1
    add $t2, $zero, $zero
    addi $t1, $zero, 127

tb111_check1: #���s0����
    slt $t2, $t1, $s0
    beq $t2, $zero, tb111_check2_2
    j tb111_change1

tb111_change1:
    xor $t3, $t3, $s3
    addi $t3, $t3, 1

tb111_check2_1: #���s1����
    slt $t2, $t1, $s1
    beq $t2, $zero, tb111_div1_1
    j tb111_change2_1

tb111_change2_1:
    xor $t0, $t0, $s3
    addi $t0, $t0, 1
    j tb111_div2_1

tb111_check2_2: #���s1����
    slt $t2, $t1, $s1
    beq $t2, $zero, tb111_div1_1
    j tb111_change2_2

tb111_change2_2:
    xor $t0, $t0, $s3
    addi $t0, $t0, 1
    j tb111_div3_1

tb111_div1_1: #��������
    slt $t7, $t3, $t0 
    beq $t7, $t6, tb111_checkq1_1
    beq $t8, $zero, tb111_div1_2
    xor $t9, $t0, $s4  # ��$s1ȡ����1
    addi $t9, $t9, 1
    addi $t8, $t8, -1

tb111_div1_2:
    add $t3, $t3, $t9
    addi $t2, $t2, 1
    j tb111_div1_1

tb111_div2_1: #��������
    slt $t7, $t3, $t0 
    beq $t7, $t6, tb111_checkq1_2
    beq $t8, $zero, tb111_div2_2
    xor $t9, $t0, $s4  # ��$s1ȡ����1
    addi $t9, $t9, 1
    addi $t8, $t8, -1

tb111_div2_2:
    add $t3, $t3, $t9
    addi $t2, $t2, 1
    j tb111_div2_1

tb111_div3_1: #��������
    slt $t7, $t3, $t0 
    beq $t7, $t6, tb111_checkq1_3
    beq $t8, $zero, tb111_div3_2
    xor $t9, $t0, $s4  # ��$s1ȡ����1
    addi $t9, $t9, 1
    addi $t8, $t8, -1

tb111_div3_2:
    add $t3, $t3, $t9
    addi $t2, $t2, 1
    j tb111_div3_1

    # ��ʾ�̺�������ÿ�����ֳ���5��
tb111_checkq1_1:
    slt $t4, $t1, $s0
    slt $t5, $t1, $s1
    beq $t4, $t5, tb111_checkq2_1
    j tb111_checkq3_1

tb111_checkq2_1: # s0,s1������ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_checkr1_1
    j tb111_change3_1

tb111_checkq3_1: # s0,s1���Ų�ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_change3_1
    j tb111_checkr1_1

tb111_change3_1:
    xor $t2, $t2, $s4  # ��$t2ȡ����1
    addi $t2, $t2, 1

tb111_checkr1_1:
    slt $t4, $t1, $s0
    slt $t5, $t1, $t3
    beq $t4, $t5, tb111_showres1
    j tb111_change4_1

tb111_change4_1:
    xor $t3, $t3, $s4  # ��$t3ȡ����1
    addi $t3, $t3, 1

tb111_showres1:
    sw $t2, 0x61($28)
    sw $t3, 0x60($28)
    j tb111_res

    # ��ʾ�̺�������ÿ�����ֳ���5��
tb111_checkq1_2:
    slt $t4, $t1, $s0
    slt $t5, $t1, $s1
    beq $t4, $t5, tb111_checkq2_2
    j tb111_checkq3_2

tb111_checkq2_2: # s0,s1������ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_checkr1_2
    j tb111_change3_2

tb111_checkq3_2: # s0,s1���Ų�ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_change3_2
    j tb111_checkr1_2

tb111_change3_2:
    xor $t2, $t2, $s4  # ��$t2ȡ����1
    addi $t2, $t2, 1

tb111_checkr1_2:
    slt $t4, $t1, $s0
    slt $t5, $t1, $t3
    beq $t4, $t5, tb111_showres2
    j tb111_change4_2

tb111_change4_2:
    xor $t3, $t3, $s4  # ��$t3ȡ����1
    addi $t3, $t3, 1

tb111_showres2:
    addi $t2, $t2, -1
    sw $t2, 0x61($28)
    sw $t3, 0x60($28)
    j tb111_res

 # ��ʾ�̺�������ÿ�����ֳ���5��
tb111_checkq1_3:
    slt $t4, $t1, $s0
    slt $t5, $t1, $s1
    beq $t4, $t5, tb111_checkq2_3
    j tb111_checkq3_3

tb111_checkq2_3: # s0,s1������ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_checkr1_3
    j tb111_change3_3

tb111_checkq3_3: # s0,s1���Ų�ͬ
    slt $t4, $t1, $t2
    beq $t4, $zero, tb111_change3_3
    j tb111_checkr1_3

tb111_change3_3:
    xor $t2, $t2, $s4  # ��$t2ȡ����1
    addi $t2, $t2, 1
    
tb111_checkr1_3:
    slt $t4, $t1, $s0
    slt $t5, $t1, $t3
    beq $t4, $t5, tb111_showres3
    j tb111_change4_3

tb111_change4_3:
    xor $t3, $t3, $s4  # ��$t3ȡ����1
    addi $t3, $t3, 1

tb111_showres3:
    addi $t2, $t2, 1
    sw $t2, 0x61($28)
    sw $t3, 0x60($28)
    j tb111_res

tb111_res:
    add $t4, $zero, $zero         # ���ü������ĳ�ֵΪ0
    add $t5, $zero, $zero         # t5Ϊ0��ʾ��ʾ�̣�Ϊ1��ʾ��ʾ����

tb111_loop:
    # bgtz $t4, tb111_count  # �����������Ϊ0����ת��count��ǩ
    slt $t8, $t4, $zero
    beq $t8, $zero, tb111_count 
    add $t4, $zero, $zero       # ���ü�����
    addi $t5, $t5, 1 # �л���ʾ�̻�����

tb111_count:
     # �ȴ�2-3��
    add $t1, $zero, $s5
    add $t1, $t1, $s5

tb111_delay:
    addi $t1, $t1, -1
    bne $t1, $zero, tb111_delay
    beq $t5,$zero, tb111_showq # ���t5Ϊ0����ʾ��
    j tb111_showr

tb111_showq:
    sw $t2, 0x61($28)
    sw $zero, 0x60($28)
    addi $t4, $t4, -1 # ��������1
    j tb111_loop

tb111_showr:
    sw $t3, 0x60($28)
    sw $zero, 0x61($28)
    j begin_1
####################################
extend:
    slti $t0, $s0, 0x0080
    bne $t0, $zero, ex2 # less than = 1, no need
    or $s0, $s0, $s6
ex2:
    slti $t0, $s1, 0x0080
    bne $t0, $zero, exit_ex # less than = 1, no need
    or $s1, $s1, $s6
exit_ex:    
    jr $ra
####################################



