.data
.text 0x0000
start:
	lw $1, 0x70($31)
	sw $1, 0x60($31)
	lw $1, 0x72($31)
	sw $1,0x62($31)
	j start