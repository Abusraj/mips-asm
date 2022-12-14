#201968270 Omar Barasheed
.data
array: .space 10000
file: .asciiz "input1.txt"
notfound: .asciiz "File is not found"
upperL: .asciiz "Upper case letters= "
lowerL: .asciiz "Lower case letters= "
digits: .asciiz "Digits= "
specialchar: .asciiz "Special characters= "
lines: .asciiz "Lines= "
newline: .asciiz "\n"

.text
.globl main
main:

#open file for reading
la $a0,file    #open file
li $v0,13 #syscall for read
li $a1,0 #open for reading
syscall
move $s7,$v0   #file descriptor to check if found


######################################################
li $t0,0 #capital letter/s counter
li $t1,0 #small letter/s counter 
li $t2,0 #digit/s counter
li $t3,0 #special character/s counter
li $t4,0 #line/s counter
li $t5,0 #counter increment till end of file
blez $s7,wrongfile #branch to file not found if file descriptor is -1

move $a0,$s7    #open file
li $v0,14
la $a1,array
li $a2,10000
syscall
move $s1,$v0 #get the number of characters read

#################################################3#
li $a1,0  #conditional check (1=char found 0=not found go next type) 
li $t5,0 #index of the looping
loop:       #start looping
lb  $s2, array($t5) #$s2 is the content of textfile[$t2]
beqz $a1,checkupper
li $a1,0 #check if found go to the next character
#######This is where to stop########
addi $t5,$t5,1
ble $t5,$s1,loop
###########PRINTING RESULT##################
li $v0,4
la $a0,upperL
syscall
li $v0,1
move $a0,$t0
syscall
li $v0,4
la $a0,newline
syscall

la $a0,lowerL
syscall
li $v0,1
move $a0,$t1
syscall
li $v0,4
la $a0,newline
syscall

li $v0,4
la $a0,digits
syscall
li $v0,1
move $a0,$t2
syscall
li $v0,4
la $a0,newline
syscall

la $a0,specialchar
syscall
li $v0,1
move $a0,$t4
syscall
li $v0,4
la $a0,newline
syscall

la $a0,lines
syscall
li $v0,1
move $a0,$t3
syscall



j end
#################check the char in $s2#########################
checkupper: #upper
blt $s2,0x41,checklower #A
bgt $s2,0x5A,checklower #Z
addi,$t0,$t0,1 #if found increment++ 
addi,$a1,$a1,1 #stop the checking loop go to next
j loop
checklower:
blt $s2,0x61,digit #a
bgt $s2,0x7a,digit #z
addi,$t1,$t1,1
addi,$a1,$a1,1
j loop
digit:
blt $s2,0x30,line #0
bgt $s2,0x39,line  #9
addi,$t2,$t2,1
addi,$a1,$a1,1
j loop
line:
bne $s2, '\n',special  #'\n'
addi,$t3,$t3,1
addi,$a1,$a1,1
j loop
special:
blt $s2,0x21,special1 #!
bgt $s2,0x2f,special1 #/
addi,$t4,$t4,1
addi,$a1,$a1,1
j loop
special1:
blt $s2,0x3A,special2 #:
bgt $s2,0x40,special2 #@
addi,$t4,$t4,1
addi,$a1,$a1,1
j loop
special2:
blt $s2,0x5b,special3 #[
bgt $s2,0x60,special3 #`
addi,$t4,$t4,1
addi,$a1,$a1,1
j loop

special3:
blt $s2,0x7b,none #{
bgt $s2,0x7e,none #~ 
addi,$t4,$t4,1 
addi,$a1,$a1,1
j loop
none: #else go to the next char
addi,$a1,$a1,1
nop 
j loop
###############################################

##################################################
wrongfile: #wrong file
li $v0,4
la $a0,notfound
syscall
end:
li $v0, 16       # system call for close file
move $a0, $s7      # file descriptor to close
syscall

li $v0,10 #exit program
syscall
#############################################
