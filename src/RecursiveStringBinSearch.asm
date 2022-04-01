# Recursive binary search on string array.
# The string directive to be searched is stored at $a2 after found.
          .globl strcmp, rec_b_search

          .data

aadvark:  .asciiz "aadvark"
ant:      .asciiz "ant"
elephant: .asciiz "elephant"
gorilla:  .asciiz "gorilla"
hippo:    .asciiz "hippo"
empty:    .asciiz ""

          # make sure the array elements are correctly aligned
          .align 2
sarray:   .word aadvark, ant, elephant, gorilla, hippo
endArray: .word 0  # dummy

.text

main:
            la   $a0, empty
            addi $a1, $a0,   0 # 16 # a1 = a0 (+ 0)
            jal  strcmp

            la   $a0, sarray
            la   $a1, endArray
	    addi $a1, $a1,     -4  # point to the last element of sarray
            la   $a2, elephant     # string directive to be searched.
            jal  rec_b_search

            addiu      $v0, $zero, 10    # system service 10 is exit
            syscall                      # we are outa here.
 
 
 

# a0 - address of string 1
# a1 - address of string 2
strcmp:
######################################################
#  strcmp code here!
######################################################
		add $v0, $zero, $zero
	
		loop1:	
			lbu $t2, 0($a0)
			lbu $t3, 0($a1)
			beq $t2, $t3, equalChars1 # NOTE if the currently pointed character's ASCII value is equal for both of the strings , goto... 
			slt $t4, $t2, $t3 # if string's 2 currenlty pointed character's ASCII value is greater than the corresponding indexe's character of string1 ...
			bne $t4, $zero, string2IsGreater1 # a0 < a1 case
			addi $v0, $zero, 1 # a0 > a1 case. If so , return a random positive number
			jr   $ra
	
		equalChars1:
			beq $t2, $zero , exitLoop2
			addi $t0, $t0, 1 # pointer is transfered to the next character 
			addi $a1, $a1, 1 # pointer is transfered to the next character 
			j loop1 # keep comparing , this time for the next character of both strings
		
		string2IsGreater1:
			addi $v0, $zero, -1 
			jr   $ra
	
		exitLoop2:
			addi $v0, $zero, 0 
			jr $ra
jr $ra
            
                        







# a0 - base address of array
# a1 - address of last element of array
# a2 - pointer to string to try to match
rec_b_search:
######################################################
#  rec_b_search code here!
######################################################
		add $v0, $zero, $zero # $v0 = 0
		addi $sp , $sp , -8
		sw $s0, 0($sp)
		sw $ra, 4($sp) # preserving return to main $ra value so that we can jump back to main after we find the sought element
		beq $t4, $a2, exitLoop1 # base case / sunthiki termatismou anadromhs -> sarray[mid] == sought element
		jal callee 
		lw $s0, 0($sp)
		
	callee:
		sub $t0, $a1 , $a0 # &R - &L
		srl $t2, $t0, 2 # (&R - &L)/4 -> 1st step of calculating the cardinality of sarray
		addi $t2, $t2 , 1 # ((&R - &L)/4) + 1 == cardinality of sarray
		srl $t3, $t2 , 1 # index of mean element + 1
		sll $t4, $t3, 2 # calculating the offset
		add $s0, $a0, $t4 # memory address of mean element is calculated
		
		
		addi $sp, $sp , -12 # make space for 3 variables in stack ( $ra, $a1, $a2)
		sw $a0, 0($sp) # save return address in the stack 
		sw $a1, 4($sp)
		sw $ra, 8($sp)
		jal strcmp1
		# if $v0 cases ...
		lw $a0, 0($sp) # save return address in the stack 
		lw $a1, 4($sp)
		lw $ra, 8($sp)
		addi $sp ,$sp , 12  
		beq $v0, $zero, exitLoop1 # (sought element == mean element) case
		slti $t1, $v0, 0 # if $t1 == 1 then (sought element > mean element) case , else (sought element < mean element) case
		beq $t1, $zero, leftSideOfArray # R = ( m - 1 ) case
		
	rightSideOfArray:
		addi $a0 , $s0, 4 # L = (m + 1)
		lw $t4,0($s0)		
		jal rec_b_search # j callee goto caller
		
	leftSideOfArray: 
		addi $a1, $s0, -4 # R = (m - 1)
		lw $t4,0($s0)
		jal rec_b_search  # j callee goto caller
		
	exitLoop1:
		lw $ra, 4($sp)
		addi $sp, $sp, 8
		add $v0, $a2, $zero # $ v0 = $a2 , where : $a2 = &hippo
		jr $ra # goto caller
		
jr $ra

strcmp1:
		add $v0, $zero, $zero
		lw  $t0, 0($s0) # $t0 now has mean element's memory address loaded # $t1 now has last elemen't memory address loaded
		add $a1, $a2 , $zero
	
		loop0:	
			lbu $t2, 0($t0)
			lbu $t3, 0($a1)
			beq $t2, $t3, equalChars #  if the currently pointed character's ASCII value is equal for both of the strings , goto... 
			slt $t4, $t2, $t3 # if strings2's currenlty pointed character's ASCII value is greater than the corresponding indexe's character of string1 ...
			bne $t4, $zero, string2IsGreater # a0 < a1 case
			addi $v0, $zero, 1 # a0 > a1 case. If so , return a random positive number
			jr   $ra
	
		equalChars:
			beq $t2, $zero , exitLoop
			addi $t0, $t0, 1 # pointer is transfered to the next character 
			addi $a1, $a1, 1 # pointer is transfered to the next character 
			j loop0 # keep comparing , this time for the next character of both strings
		
		string2IsGreater:
			addi $v0, $zero, -1 
			jr   $ra
	
		exitLoop:
			addi $v0, $zero, 0 
			lw $t4,0($s0)
			jr $ra
