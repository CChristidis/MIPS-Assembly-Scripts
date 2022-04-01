# Encodes a string directive as follows:
# 1) Let i be an index which can take values 0 to 25, as english alphabet has 26 letters. Then i = 0 corresponds to A, i = 1 corresponds to B, ... , i = 25 corresponds
# to Z. The first step of this encoding is to replace letter at index i with the corresponding letter at index 26 - i. Thus, A will be replaced with Z, B with Y etc.
# 2) Right after finishing the letter swaping, we replace every appearance of 'I' (ascii code 73) with '!' (ascii code 33) and 'O' (ascii code 79) with '0' (ascii
# code 48).

.data
aadvark : .asciiz "AADVARK" 
# pattern is : (90 - x) - (x - 65) + x = [155 - x] , where x : ascii value of current character in string.
# I -> 73
# O -> 79
# ! -> 33
# 0 -> 48 
.text

main :
	la $a0, aadvark
	jal encode
	addi $v0, $zero 10
	syscall

encode :
	addi  $s0, $zero , 155 # $s0 = 155 (constant)
	addi  $s1, $zero, 73 # $s1 = 73 = I
	addi  $s2, $zero, 79 # $s2 = 79 = O
	
	loop :
		lbu $t0, 0($a0) # store char at which $a0 points (x) 
		beq $t0, $zero, exitloop # if end of $a0 has been reached , exit 
		sub $t0, $s0, $t0 # 155 - x
		beq $t0, $s1, loop1 # if x  == I
		beq $t0, $s2, loop2 # if x == O
		sb $t0, 0($a0)
		addi $a0, $a0, 1 # go to next character
		j loop
	
	loop1 : 
		addi $t0, $zero, 33 # x = !
		sb $t0, 0($a0)
		addi $a0, $a0, 1
		j loop
	
	loop2 :
		addi $t0, $zero, 48 # x = 0
		sb $t0, 0($a0)
		addi $a0, $a0, 1
		j loop
	
	exitloop :
		add $v1, $a0, $zero
		jr $ra
		
		
	
