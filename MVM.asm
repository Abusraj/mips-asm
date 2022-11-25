.macro newline
li $v0,11
li $a0,'\n'
syscall
.end_macro 
.macro print_float(%x)
	li $v0, 2
	mov.s $f12, %x
	syscall
.end_macro	
.macro newLine
	li $v0, 11
	li $a0, '\n'
	syscall
.end_macro 
.macro exit
li $v0,10
syscall
.end_macro
.macro print
li $v0,2
syscall
.end_macro
.data
input: .asciiz "Enter n: "
store_m: .asciiz "\nEnter the number to store in matrix: "
store_v: .asciiz "\nEnter the number to store in vector: "
read_v: .asciiz "\nThe vector is:"
result_v: .asciiz "The result vector is:\n"
.text
main:
	li $v0,4
	la $a0,input #call get n from user
	syscall
	li $v0,5 #get n from user
	syscall
	move $s0,$v0 #save n in $s0
	move $a0,$s0 #call read matrix
	jal read_matrix
	move $s1,$v0 #save matrix address
	
	move $a0,$s0 #put the n argument in function
	jal read_vector
	move $s2,$v0 #save vector address
	
	move $a0,$s0
	move $a1,$s1
	move $a2,$s2
	jal MVM
	move $s2,$v0 #move result vector in $s2
	
	li $v0,4
	la $a0,result_v
	syscall
	move $a0,$s0 #put the n argument in function
	move $a1,$s2 #put the &vector argument in function
	jal print_vector
	exit #exit the program DONE!
print_vector:
	move $t0,$a0 #n
	move $t1,$a1 #&vector
	
	loop_print:
	l.s $f12,0($t1)
	print_float($f12)
	newline
	
	subi $t0,$t0,1
	addi $t1,$t1,4
	bnez $t0,loop_print
jr $ra
read_matrix:
	move $t0,$a0 #t0=n
	mul $t1,$t0,$t0 #$t1=n*n
	li $v0,9 # make a n*n float dynamic array
	sll $a0,$t1,2 #(n*n)*4 to make it float
	syscall
	move $t2,$v0 #$t2=array address
	subi $sp ,$sp,8
	sw $t2,0($sp)#save address not to get lost
	sw $ra,4($sp)
	li $t1,0 #i=0
loopi:
	jal loopj
	li $t3,0 #j=0
	addi $t1,$t1,1 #i++
	beq $t1,$t0,end
	j loopi
loopj:
	li $v0,4
	la $a0,store_m #ask for input to store
	syscall
	li $v0,6 #ask user for float 
	syscall
	mul $t4,$t1,$t0 #$t4=i*n
	add $t4,$t4,$t3 #$t4=(i*n+j)
	sll $t4,$t4,2	#$t4=(i*n+j)*4
	addu $t2,$t2,$t4 #&array[i][j]
	s.s $f0,0($t2) #store float on heap array
	addi $t3,$t3,1 #j++
	lw $t2,0($sp)
	bne $t3,$t0,loopj
jr $ra
end:
	lw $v0,0($sp)
	lw $ra,4($sp)
	addi $sp,$sp,8
jr $ra
MVM:
	move $t0,$a0 #save n
	move $t1,$a1 #save matrix address
	move $t2,$a2 #save vector address
	sll $a0,$a0,2 #n*4 for local float vector
	li $v0,9
	syscall
	subi $sp ,$sp,8
	sw $ra,0($sp) #store return 
	sw $v0,4($sp)#save local vector address not to get lost
	move $t3,$v0 #store local float vector in $t3
	li $t4,0 #i=0
	li $t5,0 #j=0
	loopii:
	jal loopjj #jump to the j loop
	addi $t4,$t4,1 #i++
	li $t5,0 #j=0
	li $t7,0 #load 0 to float number (Sum)
	mtc1 $t7,$f1 # move 0 to 0.0
	cvt.s.w $f1,$f1
	beq $t4,$t0,done
	j loopii
	loopjj:
	move $t1,$a1 #save matrix address
	sll $t2,$t5,2 #next element
	add $t2,$a2,$t2 #add with address
	mul $t6,$t4,$t0 #$t6=i*n
	add $t6,$t6,$t5 #$t6=(i*n+j)
	sll $t6,$t6,2	#$t6=(i*n+j)*4
	addu $t1,$t6,$t1 #&array[i][j]
	
	nop
	l.s $f0,0($t1) #load float in $f0
	l.s $f2,0($t2) #load vector[j] in $f2 
	mul.s $f0,$f0,$f2 #matrix[i][j] * vector[j]
	add.s $f1,$f1,$f0 #sum = sum +matrix[i][j] * vector[j]
	addi $t5,$t5,1 #j++
	bne $t5,$t0,loopjj
	s.s $f1,0($t3) #local vector[i] = sum;
	addi $t3,$t3,4 #next element 
	jr $ra #return from j loop
	done:
	lw $v0,4($sp)
	lw $ra,0($sp)
	addi $sp,$sp,8
	jr $ra
read_vector:
	move $t0,$a0 #save n
	sll $a0,$a0,2 #n*4 for float
	li $v0,9
	syscall
	move $t1,$v0 #save vector address
	move $t2,$t1 #save vector address
	vector_s:
	li $v0,4
	la $a0,store_v
	syscall
	li $v0,6
	syscall
	s.s $f0,0($t1) #store float in the vector
	subi $t0,$t0,1 #n--
	addi $t1,$t1,4 #next array element
	bnez $t0,vector_s #while n !=0 
	move $v0,$t2 #return vector address
jr $ra