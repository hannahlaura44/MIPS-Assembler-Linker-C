# CS 61C Spring 2016 Project 2-2 
# string.s

#==============================================================================
#                              Project 2-2 Part 1
#                               String README
#==============================================================================
# In this file you will be implementing some utilities for manipulating strings.
# The functions you need to implement are:
#  - strlen()
#  - strncpy()
#  - copy_of_str()
# Test cases are in linker-tests/test_string.s
#==============================================================================

.data
newline:	.asciiz "\n"
tab:	.asciiz "\t"

.text
#------------------------------------------------------------------------------
# function strlen()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string input
#
# Returns: the length of the string
#------------------------------------------------------------------------------
strlen:
	# YOUR CODE HERE
	li $v0, 0 #initialize the counter
	beq $a0, $0, end #if an empty string is passed in.
strlen_loop:
	lb $t0, 0($a0) #load the current character
	beq $t0, $0, end #if null terminator (is this a valic check for null terminator?)
	addiu $v0, $v0, 1 #increment the counter.
	addiu $a0, $a0, 1 #move to the next character
	j strlen_loop
end:
	jr $ra

#------------------------------------------------------------------------------
# function strncpy()
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = pointer to destination array
#  $a1 = source string
#  $a2 = number of characters to copy
#
# Returns: the destination array
#------------------------------------------------------------------------------
strncpy:
	# YOUR CODE HERE
	addu $v0, $a0, 0 #load the address of the destination array into the return value.
	beq $a1, $0, end #if an empty string is passed in.
	beq $a2, $0, end #if number of char to copy == 0.
strncpy_loop:
	beq $a2, $0, strncpy_end
	lb $t0, 0($a1) #load the current character from the source string.
	sb $t0 0($a0) #store the current character into the destination array
	beq $t0, $0, strncpy_end #check for end of string (null terminator)
	addiu $a2, $a2, -1 #decrement the number of characters to copy.
	addiu $a1, $a1, 1 #move to the next character in the source string
	addiu $a0, $a0, 1#move to the next character in the destination array.
	j strncpy_loop
strncpy_end:
	jr $ra

#------------------------------------------------------------------------------
# function copy_of_str()
#------------------------------------------------------------------------------
# Creates a copy of a string. You will need to use sbrk (syscall 9) to allocate
# space for the string. strlen() and strncpy() will be helpful for this function.
# In MARS, to malloc memory use the sbrk syscall (syscall 9). See help for details.
#
# Arguments:
#   $a0 = string to copy
#
# Returns: pointer to the copy of the string
#------------------------------------------------------------------------------
copy_of_str:
	# YOUR CODE HERE
	addiu $sp, $sp, -12 #create space on stack
	sw $ra, 0($sp) # save the return address on the stack
	sw $a0, 4($sp) # save the input string onto the stack
	jal strlen # $v0 = length of string
	addiu $a0, $v0, 0 # $a0 = the number of bytes to allocate (argument for syscall)
	sw $v0, 8($sp) # save the length of the string onto the stack
	li $v0, 9 # syscall 9 is the memory allocation service
	syscall # $v0 = return address of the allocated memory
	addiu $a0, $v0, 0 # $a0 = pointer to destination array
	lw $a1, 4($sp) # $a1 = the input string
	lw $a2, 8($sp) # $a2 = length of the string
	jal strncpy
	lw $ra, 0($sp)
	addiu $sp, $sp, 12 #move stack back up
	jr $ra

###############################################################################
#                 DO NOT MODIFY ANYTHING BELOW THIS POINT                       
###############################################################################

#------------------------------------------------------------------------------
# function streq() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Arguments:
#  $a0 = string 1
#  $a1 = string 2
#
# Returns: 0 if string 1 and string 2 are equal, -1 if they are not equal
#------------------------------------------------------------------------------
streq:
	beq $a0, $0, streq_false	# Begin streq()
	beq $a1, $0, streq_false
streq_loop:
	lb $t0, 0($a0)
	lb $t1, 0($a1)
	addiu $a0, $a0, 1
	addiu $a1, $a1, 1
	bne $t0, $t1, streq_false
	beq $t0, $0, streq_true
	j streq_loop
streq_true:
	li $v0, 0
	jr $ra
streq_false:
	li $v0, -1
	jr $ra			# End streq()

#------------------------------------------------------------------------------
# function dec_to_str() - DO NOT MODIFY THIS FUNCTION
#------------------------------------------------------------------------------
# Convert a number to its unsigned decimal integer string representation, eg.
# 35 => "35", 1024 => "1024". 
#
# Arguments:
#  $a0 = int to write
#  $a1 = character buffer to write into
#
# Returns: the number of digits written
#------------------------------------------------------------------------------
dec_to_str:
	li $t0, 10			# Begin dec_to_str()
	li $v0, 0
dec_to_str_largest_divisor:
	div $a0, $t0
	mflo $t1		# Quotient
	beq $t1, $0, dec_to_str_next
	mul $t0, $t0, 10
	j dec_to_str_largest_divisor
dec_to_str_next:
	mfhi $t2		# Remainder
dec_to_str_write:
	div $t0, $t0, 10	# Largest divisible amount
	div $t2, $t0
	mflo $t3		# extract digit to write
	addiu $t3, $t3, 48	# convert num -> ASCII
	sb $t3, 0($a1)
	addiu $a1, $a1, 1
	addiu $v0, $v0, 1
	mfhi $t2		# setup for next round
	bne $t2, $0, dec_to_str_write
	jr $ra			# End dec_to_str()
