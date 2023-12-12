.data
.text
main: 
	lui $1,0xFFFF			
	ori $28,$1,0xF000
	addi $17, $0, 0
	addi $18, $0, 1
	addi $19, $0, 2
	addi $20, $0, 3
	addi $21, $0, 4
	addi $22, $0, 5
	addi $23, $0, 6
	addi $24, $0, 7  
loop:
	addi $3,$0,0
	addi $5,$0,0
	addi $8,$0,0
	lw $1, 0xC72($28)	#left-8 switch in $1
	#no need to shift srl5 ?
	beq $1,$17,Add	#000 0
	beq $1,$18,Odd	#001 1
	beq $1,$19,bitOr	#010 2
	beq $1,$20, bitNor	#011 3
	beq $1,$21, bitXor	#100 4
	beq $1,$22, bitSlt		#101 5
	beq $1,$23, bitSltu		#110 6
	beq $1,$24, loadAndShow	#111 7
	
Add:
	lw   $2,0xC70($28)	#switch
	
	
	
	
	
t000_fin2:
	lui $t2， 0x0010
	ori $t2， $t2，0x0000
	addi $t3, $zero，16
	add $t4， $zero，$zero# 1oop2用来进行闪烁
tb000_1oop2:
	andi $vo, $t4，1
	sw $v0，0x60($28)
	add $t1, $zero, $zero
	addi $t4， $t4，1
	beq $t3, $t4, begin_1
#1oop3用来控制闪烁的频率
tb000_1oop3:
	beq $t1, $t2， tb000_1ooaddi $t1, $t1，1j tb000_1oop3