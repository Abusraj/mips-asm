.macro exit
li $v0,10
syscall
.end_macro

.data
input:.asciiz "Enter n > 1 : \n"
enterNum:.asciiz "Enter the numbers to store: \n"
error:.asciiz "The number is n<=1"
beforesort: .asciiz "The array elements before sorting: \n"
aftersort: .asciiz "\n The array elements after sorting:"
.text
main: 
	jal read_array
	move $t0,$v0
	ble $v1,1,exitWrong
	la $a0,beforesort
	li $v0,4
	syscall
	move $a0,$t0 
	move $a1,$v1
	jal print_array
	subi $sp,$sp,12
	sw $a0,0($sp) #save &array
	sw $a1,4($sp) #save n
	sw $ra,8($sp) #save return
	la $a0,aftersort
	li $v0,4
	syscall
	lw $a0,0($sp) #load &array
	jal	quick_sort 
	lw $a0,0($sp) #load &array
	lw $a1,4($sp) #load n
	lw $ra,8($sp) #save return
	addi $sp,$sp,12
	jal print_array
	exit
############################
exitWrong:
	li $v0,4 #print error messege
	la $a0,error
	syscall
	exit
############################
quick_sort:
	addi $sp,$sp,-12
	sw $a0,0($sp) #save the array address
	sw $a1,4($sp) #store n address 
	sw $ra,8($sp) #store return address 
	move $s0,$a0 #store array to $s0
	li $t0,0 #t0(i)=0
	subi $t1,$a1,1 #$t1(j)=n-1
	addu $t2,$t0,$t1 #t2=i+j
	srl $t2,$t2,1 #t2=i+j/2
	sll $t2,$t2,2 #t2=(i+j/2)*4 array 
	addu $s0,$s0,$t2 #array[(i+j/2)]
	lw $t3,0($s0) #t3=pivit
	bgt $t0,$t1,rec_if #skip while to recursion
	innerwhile:
	lw $s0,0($sp) #restore array address
	sll $t2,$t0,2 # get array[i]
	addu $s0,$s0,$t2 #&array[i]
	lw $t4,0($s0)#t4=array[i] 
	bge $t4,$t3,innerwhile2 #array[i] >= pivot to skip if not true
	addi $t0,$t0,1 #i++
	j innerwhile #return to the while loop
	innerwhile2:
	lw $s0,0($sp)#load array
	sll $t2,$t1,2 #get array[j]
	addu $s0,$s0,$t2 #&array[j]
	lw $t4,0($s0)#t4=array[j]
	ble $t4,$t3,if_loop #array[j] <= pivot to skip if not true
	subi $t1,$t1,1 #j--
	j innerwhile2 #return to the second while
########################
	if_loop:
	bgt $t0,$t1,rec_if #skip to the recerstion
	lw $s0,0($sp) #s0 =&array[]
	sll $t2,$t0,2 # get array[i]
	addu $s0,$s0,$t2 #&array[i]
	move $t4,$s0 #$t4=&array[i] 
	lw $t5,0($s0)#t5(temp)=array[i] 
	lw $s0,0($sp)#load array
	sll $t2,$t1,2 #get array[j]
	addu $s0,$s0,$t2 #&array[j]
	lw $t6,0($s0) # t6 = array[j] 
	sw $t6,0($t4) #array[i] = array[j] 
	sw $t5,0($s0)#array[j] = temp
	addi $t0,$t0,1 #i++
	subi $t1,$t1,1 #j--
	ble $t0,$t1,innerwhile #return to the first while 
############################
	sw $a0,0($sp) #save the array address
	sw $a1,4($sp) #store n address 
	sw $ra,8($sp) #store return address 
	rec_if: #the start of the recursive calls
	blez $t1,rec_if2 # j<=0 go to the second rec
	addi $t1,$t1,1 #j++
	move $a0,$a0 #quick_sort(&array[0],)
	move $a1,$t1 #quick_sort(,j+1)
	jal quick_sort
	lw $a0,0($sp) #save the array address
	lw $a1,4($sp) #store n address 
	lw $ra,8($sp) #store return address
	addi $sp,$sp,12 
	rec_if2:
	addi $sp,$sp,-12 
	sw $a0,0($sp) #save the array address
	sw $a1,4($sp) #store n address 
	sw $ra,8($sp) #store return address
	move $s0,$a0
	subi $t2,$a1,1 #t2=n-1
	bge $t0,$t2,exitquick #i>= n-1 exit the recursion
	sll $t2,$t0,2 #array[i]
	add $a0,$s0,$t2 #quick_sort(&array[i],)
	sub $a1,$a1,$t0 #quick_sort(,n-i)
	jal quick_sort
exitquick:
	lw $a0,0($sp) #save the array address
	lw $a1,4($sp) #store n address 
	lw $ra,8($sp) #store return address
	addi $sp,$sp,12 
	jr $ra
###########################
read_array:
	li $v0,4 #print messege
	la $a0,input
	syscall
	li $v0,5#get the input
	syscall
	move $t1,$v0 #$t1=n
	ble $t1,1,exitfun #if n<=1 exit 
	sll $t1, $t1, 2	# $t1 = n*4 bytes array
	li $v0,9 #load dynamic heap
	move $a0,$t1 
	syscall 
	move $t2,$v0 #t2=int array[n]
	srl $t1, $t1, 2	# $t1 = n again
	subi $sp,$sp,8
	sw $t1,0($sp) #store n
	sw $t2,4($sp) #store &array address
	loop:
	li $v0,4 #print messege
	la $a0,enterNum
	syscall
	li $v0,5#get the input
	syscall
	sw $v0,0($t2)
	addi $t2,$t2,4
	addi $t1,$t1,-1
	bnez $t1,loop
	lw $v1,0($sp) #return n
	lw $v0,4($sp) #return &array address
	addi $sp,$sp,8
exitfun:
	jr $ra
##########################
print_array:
	move $t1,$a0  #save array address
	move $t2,$a1 #save n
	move $t3,$a0 #save because the $a0 changes

print_loop:
	li $v0,1 #print numbers
	lw $a0,0($t1) #print array[i]
	syscall
	li $v0,11
	li $a0,',' #print seprator
	syscall
	addi $t1,$t1,4 #go to the next array[i++]
	addi $t2,$t2,-1 #n--
	bnez $t2,print_loop #n!=0 continue the loop
	move $a0,$t3 #save the $a0 to the user
jr $ra
#########################
