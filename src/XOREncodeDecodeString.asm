# Encodes and decodes a string directive but executing a xor operation with an integer directive, key.

.data
aadvark : .asciiz "aadvark"
key : .word 5 
.text

main :
	la $a0, aadvark
	la $a1, key
	jal encode
	jal decode
	addi $v0, $zero, 10 
	syscall
	 
encode : 
		add $s1, $zero, $zero # counter
	loop :
		lbu $s0, 0($a0) # load first address that string points at
		beq $s0, $zero, endloop
		xor $t0, $s0, $a1 # encode byte of aadvark
		sb $t0, 0($a0)
		addi $a0, $a0, 1 # point to next byte
		addi $s1, $s1, 1 # counter ++
		j loop
		
	endloop:
		addi $t0, $a0, 1
		lw $v0, 0($a1)
		sub $a0, $a0, $s1 
		lw $v1, 0($a0)
		jr $ra

decode : # if we want to decode a xor-encoded number we have to simply xor-it with the same number it was encoded in the first place.
	lw $s2, 0($v1)# store encoded string to $s2
	lw $s0, 0($v0) # decode key
	loop1 :
		lbu $s1, 0($s2)
		beq $s1, $zero, exitloop
		xor $t0, $s1, $s0
		sb $t0, 0($s2)
		addi $s2, $zero , 1
		j loop1
	
	exitloop :
		add $v0, $s2, $zero
		jr $ra
		
		 
